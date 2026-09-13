# spec/theme_host/asset_urls_spec.rb
# frozen_string_literal: true

require "spec_helper"
require_relative "../../scripts/support/asset_urls"

RSpec.describe ThemeHost::AssetUrls do
  it "accepts a locally served canonical module" do
    expect(described_class.local!("/assets/active_admin-123.js")).to eq("/assets/active_admin-123.js")
  end

  it "accepts a locally served stylesheet" do
    expect(described_class.local!("/assets/active_admin-123.css")).to eq("/assets/active_admin-123.css")
  end

  ["https://example.com/active_admin.js", "//example.com/active_admin.js",
   "active_admin.js", "/other.js", nil].each do |url|
    it "rejects #{url.inspect} instead of skipping offline verification" do
      expect { described_class.local!(url) }.to raise_error(ArgumentError, /cannot be verified offline/)
    end
  end
end
