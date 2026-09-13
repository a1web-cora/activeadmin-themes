# spec/active_admin/themes/recipes/v3_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "active_admin/themes/recipes/v3"

RSpec.describe ActiveAdmin::Themes::Recipes::V3 do
  it "defines an explicit stable concern order" do
    expect(described_class::PARTS).to eq(%w[
      tokens chrome tables filters forms feedback login dashboard hardening
    ])
  end

  it "composes only non-empty concerns in manifest order" do
    source = described_class.source

    expect(source).to start_with("/* lib/active_admin/themes/recipes/v3/tokens.css")
    expect(source.index("Native AA4 drawer")).to be < source.index("Index presentation only")
    expect(source).not_to include("\n\n\n")
  end
end
