# spec/css_structure_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "open3"
require "tempfile"
require "active_admin/themes/recipes/v3"

# rubocop:disable-next RSpec/DescribeClass
RSpec.describe "CSS structural migration contract" do
  def with_composed_source
    Tempfile.create(["composed-v3", ".css"]) do |file|
      file.write(ActiveAdmin::Themes::Recipes::V3.source)
      file.flush
      yield file.path
    end
  end

  it "rejects adversarial cascade and structure changes" do
    output, status = Open3.capture2e("node", "--test", "spec/css_structure_test.mjs", "spec/css_migrations_test.mjs")

    expect(status.success?).to be(true), output
  end

  it "preserves the pinned core and declared migrations in the current composed source" do
    with_composed_source do |path|
      output, status = Open3.capture2e("node", "scripts/verify_css_migrations.mjs", path)
      warn output.lines.grep(/ORDER REVIEW:/).join unless output.lines.grep(/ORDER REVIEW:/).empty?
      expect(status.success?).to be(true), output
    end
  end
end
