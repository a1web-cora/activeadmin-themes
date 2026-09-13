# spec/package_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "open3"
require "rubygems/package"
require "tmpdir"

# One end-to-end process boundary intentionally keeps its setup and assertions together.
# rubocop:disable-next RSpec/DescribeClass
RSpec.describe "Built recipe package" do
  # rubocop:disable-next RSpec/ExampleLength
  it "ships and installs the recipe outside the source checkout" do
    Dir.mktmpdir("theme-package") do |directory|
      specification = Gem::Specification.load("activeadmin-themes.gemspec")
      archive = Gem::Package.build(specification, false, false, File.join(directory, "theme.gem"))
      Gem::Package.new(archive).extract_files(File.join(directory, "unpacked"))
      output, status = Open3.capture2e(
        RbConfig.ruby, "-I#{directory}/unpacked/lib", "-e", <<~RUBY, chdir: directory
          require "active_admin/themes/recipe"
          File.write("admin.css", '@import "tailwindcss";')
          recipe = ActiveAdmin::Themes::Recipe.new(root: Dir.pwd, entrypoint: "admin.css",
            active_admin_version: "4.0.0.beta22")
          abort "wrong source" unless $LOADED_FEATURES.any? { |path| path.include?("unpacked/lib/active_admin/themes/recipe.rb") }
          abort "install failed" unless recipe.install == :created && recipe.install == :identical
          abort "missing CSS" if File.read("active_admin_v3.css").empty?
        RUBY
      )
      expect(status.success?).to be(true), output
    end
  end
end
