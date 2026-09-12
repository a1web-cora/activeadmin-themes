# spec/active_admin/themes/version_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "active_admin/themes/version"

RSpec.describe ActiveAdmin::Themes::VERSION do
  it "is a valid semantic version" do
    expect(ActiveAdmin::Themes::VERSION).to match(
      /\A\d+\.\d+\.\d+(?:[.-][0-9A-Za-z]+(?:[.-][0-9A-Za-z]+)*)?(?:\+[0-9A-Za-z]+(?:[.-][0-9A-Za-z]+)*)?\z/
    )
    expect(Gem::Version.new(ActiveAdmin::Themes::VERSION).to_s).to eq(ActiveAdmin::Themes::VERSION)
  end
end
