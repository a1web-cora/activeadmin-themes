# spec/active_admin/themes/recipes/v3_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "digest/sha1"
require "active_admin/themes/recipes/v3"

RSpec.describe ActiveAdmin::Themes::Recipes::V3 do
  it "defines an explicit stable concern order" do
    expect(described_class::PARTS).to eq(%w[
      tokens chrome tables filters forms feedback login dashboard hardening
    ])
  end

  it "preserves the exact canonical recipe bytes from pre-refactor master" do
    source = described_class.source
    git_blob = "blob #{source.bytesize}\0#{source}"

    expect(Digest::SHA1.hexdigest(git_blob)).to eq("1b8079448ecd5867564ddea24cbcc19393e2c991")
  end

  it "composes populated concerns in manifest order" do
    source = described_class.source

    expect(source.index("Native AA4 drawer")).to be < source.index("Index presentation only")
  end
end
