# spec/evidence_inventory_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "tmpdir"
require_relative "../scripts/evidence_inventory"

RSpec.describe EvidenceInventory do
  let(:evidence_directory) { Dir.mktmpdir }
  let(:sha) { "a" * 40 }
  let(:png) { "\x89PNG\r\n\x1a\nfixture".b }
  let(:record) do
    { schema_version: 1, source_sha: sha, browser: "Recorded engine/version", operating_system: "Recorded OS",
      captured_at: "2026-09-14T12:00:00Z", build_command: "bin/build-host",
      cases: [{ id: "index-light-390", route: "/admin/products", palette: "light", status: "pass",
                viewport: { width: 390, height: 900 }, zoom_percent: 100, observation: "Reviewed",
                screenshot: { path: "image.png", sha256: Digest::SHA256.hexdigest(png) } }] }
  end

  after { FileUtils.remove_entry(evidence_directory) }

  def validate(record, sha)
    File.binwrite(File.join(evidence_directory, "image.png"), png)
    manifest = File.join(evidence_directory, "manifest.json")
    File.write(manifest, JSON.generate(record))
    EvidenceInventory.new(manifest, sha).validate!
  end

  it "validates provenance and reports dispositions without granting acceptance" do
    expect(validate(record, sha)).to eq("pass" => 1)
  end

  it "refuses evidence from another head" do
    expect { validate(record, "b" * 40) }.to raise_error("Source SHA mismatch")
  end

  it "refuses changed artifacts" do
    record[:cases][0][:screenshot][:sha256] = "0" * 64
    expect { validate(record, sha) }.to raise_error("Artifact hash mismatch")
  end

  it "refuses duplicate case identities" do
    record[:cases] *= 2
    expect { validate(record, sha) }.to raise_error("Duplicate case IDs")
  end

  it "refuses absolute artifact paths" do
    record[:cases][0][:screenshot][:path] = "/tmp/image.png"
    expect { validate(record, sha) }.to raise_error("Artifact must be relative")
  end

  it "refuses traversal outside the evidence directory" do
    record[:cases][0][:screenshot][:path] = ".."
    expect { validate(record, sha) }.to raise_error("Artifact escapes evidence directory")
  end

  it "refuses symlinks escaping the evidence directory" do
    File.symlink(File.dirname(evidence_directory), File.join(evidence_directory, "outside"))
    record[:cases][0][:screenshot][:path] = "outside"
    expect { validate(record, sha) }.to raise_error("Artifact escapes evidence directory")
  end

  it "refuses missing artifact hashes" do
    record[:cases][0][:screenshot].delete(:sha256)
    expect { validate(record, sha) }.to raise_error(KeyError)
  end

  {
    schema_version: 2, browser: "", cases: []
  }.each do |key, value|
    it "rejects invalid #{key}" do
      record[key] = value
      expect { validate(record, sha) }.to raise_error(RuntimeError)
    end
  end

  it "rejects abbreviated source SHAs" do
    expect { validate(record, "abc") }.to raise_error("Expected full source SHA")
  end

  { palette: "unknown", status: "unknown", zoom_percent: 0,
    viewport: { width: 0, height: 900 } }.each do |key, value|
    it "rejects invalid case #{key}" do
      record[:cases][0][key] = value
      expect { validate(record, sha) }.to raise_error(RuntimeError)
    end
  end

  it "rejects non-PNG artifacts" do
    record[:cases][0][:screenshot][:path] = "manifest.json"
    expect { validate(record, sha) }.to raise_error("Artifact is not a PNG file")
  end

  it "retains missing observations as pending rather than passed" do
    record[:cases][0][:status] = "pending"
    record[:cases][0].delete(:screenshot)
    expect(validate(record, sha)).to eq("pending" => 1)
  end
end
