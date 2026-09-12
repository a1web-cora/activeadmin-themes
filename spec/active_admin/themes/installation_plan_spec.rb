# spec/active_admin/themes/installation_plan_spec.rb
# frozen_string_literal: true

require "spec_helper"

require "fileutils"
require "tmpdir"

require "active_admin/themes"
require "active_admin/themes/installation_plan"

RSpec.describe ActiveAdmin::Themes::InstallationPlan do
  subject(:plan) do
    described_class.new(root: root, theme: ActiveAdmin::Themes::V3.theme,
                        active_admin_version: version, files: files)
  end

  let(:root) { Dir.mktmpdir("themes-plan") }
  let(:version) { "4.0.0.beta22" }
  let(:files) { { "theme.css" => "/* recipe */\n" } }

  after { FileUtils.remove_entry(root) }

  it "reports missing files without creating them" do
    expect(plan.status).to eq("theme.css" => :missing)
    expect(Dir.children(root)).to be_empty
    expect(plan).to be_installable
  end

  it "recognizes an identical installed file" do
    File.binwrite(File.join(root, "theme.css"), files.fetch("theme.css"))
    expect(plan.status).to eq("theme.css" => :identical)
    expect(plan).to be_installable
  end

  it "blocks locally modified files and preserves their contents" do
    File.write(File.join(root, "theme.css"), "custom")
    expect(plan.status).to eq("theme.css" => :modified)
    expect(plan).not_to be_installable
    expect(File.read(File.join(root, "theme.css"))).to eq("custom")
  end

  it "rejects unsupported ActiveAdmin versions" do
    expect do
      described_class.new(root: root, theme: ActiveAdmin::Themes::V3.theme,
                          active_admin_version: "3.5.0", files: files)
    end.to raise_error(ArgumentError, "unsupported ActiveAdmin version")
  end

  ["/tmp/theme.css", "../theme.css", "./theme.css", "a//b", "a/", ""].each do |path|
    context "with unsafe path #{path.inspect}" do
      let(:files) { { path => "recipe" } }

      it "refuses the destination" do
        expect { plan.status }.to raise_error(described_class::UnsafePath)
      end
    end
  end

  it "rejects a symlink destination" do
    File.symlink("missing.css", File.join(root, "theme.css"))
    expect { plan.status }.to raise_error(described_class::UnsafePath)
  end

  it "rejects a directory destination" do
    Dir.mkdir(File.join(root, "theme.css"))
    expect { plan.status }.to raise_error(described_class::UnsafePath)
  end

  it "rejects symlinks in parent directories" do
    File.symlink(root, File.join(root, "nested"))
    nested = described_class.new(root: root, theme: ActiveAdmin::Themes::V3.theme,
                                 active_admin_version: version, files: { "nested/theme.css" => "recipe" })
    expect { nested.status }.to raise_error(described_class::UnsafePath)
  end

  it "observes files changed after planning" do
    expect(plan).to be_installable
    File.write(File.join(root, "theme.css"), "custom")
    expect(plan).not_to be_installable
  end
end
