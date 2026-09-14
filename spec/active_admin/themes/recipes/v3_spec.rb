# spec/active_admin/themes/recipes/v3_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "active_admin/themes/recipes/v3"

RSpec.describe ActiveAdmin::Themes::Recipes::V3 do
  let(:expected_parts) do
    %w[
      foundation/tokens foundation/base components/navigation components/tables
      components/filters components/forms components/panels components/feedback
      surfaces/login surfaces/dashboard hardening/responsive hardening/preferences
    ]
  end

  it "defines an explicit stable concern order" do
    expect(described_class::PARTS).to eq(expected_parts)
  end

  it "composes identical bytes on repeated calls" do
    first = described_class.source

    expect(described_class.source).to eq(first)
  end

  it "ignores empty concern slots without introducing separators" do
    contents = described_class::PARTS.map do |part|
      File.binread(File.expand_path("../../../../lib/active_admin/themes/recipes/v3/#{part}.css", __dir__))
    end

    expect(described_class.source).to eq(contents.reject(&:empty?).join("\n"))
  end

  it "composes populated concerns in manifest order" do
    source = described_class.source

    expect(source.index("Native AA4 drawer")).to be < source.index("Index presentation only")
  end

  context "with controlled empty concern files" do
    let(:contents) { { "foundation/base" => "body { color: red; }", "components/tables" => "table { color: blue; }" } }

    before do
      allow(File).to receive(:binread).and_call_original
      described_class::PARTS.each do |part|
        path = File.expand_path("../../../../lib/active_admin/themes/recipes/v3/#{part}.css", __dir__)
        allow(File).to receive(:binread).with(path).and_return(contents.fetch(part, ""))
      end
    end

    it "skips leading, intermediate and trailing empty slots without extra separators" do
      expect(described_class.source).to eq("body { color: red; }\ntable { color: blue; }")
    end
  end
end
