# spec/host_recipe_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "active_admin/themes/recipes/v3"

# rubocop:disable-next RSpec/DescribeClass
RSpec.describe "Host recipe build input" do
  it "uses the same composed bytes as the installer" do
    expect(File.binread("tmp/active_admin_v3.css")).to eq(ActiveAdmin::Themes::Recipes::V3.source)
  end

  it "imports the generated recipe exactly once" do
    imports = File.read("tmp/host.css").lines.grep(/@import/)

    expect(imports).to eq(["@import \"../node_modules/tailwindcss/index.css\";\n",
                           "@import \"./active_admin_v3.css\";\n"])
  end
end
