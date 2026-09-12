# spec/active_admin/themes/theme_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "active_admin/themes"

RSpec.describe ActiveAdmin::Themes::Theme do
  subject(:theme) { ActiveAdmin::Themes::V3.theme }

  it "normalizes immutable theme metadata" do
    expect(theme.key).to eq(:v3)
    expect(theme.name).to eq("ActiveAdmin V3")
    expect(theme.recipe_version).to eq("1")
    expect(theme).to be_frozen
  end

  it "reports supported ActiveAdmin versions" do
    expect(theme).to be_supports("4.0.0.beta22")
    expect(theme).to be_supports("4.1.0")
    expect(theme).not_to be_supports("3.5.0")
    expect(theme).not_to be_supports("5.0.0")
  end
end
