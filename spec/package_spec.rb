# spec/package_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "open3"
require "rubygems/package"
require "tmpdir"

# One end-to-end process boundary intentionally keeps its setup and assertions together.
# rubocop:disable-next RSpec/DescribeClass
RSpec.describe "Built recipe package" do
  let(:packaged_concerns) do
    %w[
      foundation/tokens foundation/base
      components/navigation components/tables components/filters components/forms components/panels components/feedback
      surfaces/login surfaces/dashboard
      hardening/responsive hardening/preferences
    ].map { |part| "lib/active_admin/themes/recipes/v3/#{part}.css" }
  end

  # rubocop:disable-next RSpec/ExampleLength
  it "ships and installs the recipe outside the source checkout" do
    Dir.mktmpdir("theme-package") do |directory|
      specification = Gem::Specification.load("activeadmin-themes.gemspec")
      archive = Gem::Package.build(specification, false, false, File.join(directory, "theme.gem"))
      package = Gem::Package.new(archive)
      concern_files = package.contents.grep(%r{\Alib/active_admin/themes/recipes/v3/.*\.css\z})
      expect(concern_files).to match_array(packaged_concerns)
      package.extract_files(File.join(directory, "unpacked"))
      output, status = Open3.capture2e(
        RbConfig.ruby, "-I#{directory}/unpacked/lib", "-e", <<~RUBY, chdir: directory
          require "active_admin/themes/recipe"
          File.write("admin.css", '@import "tailwindcss";')
          recipe = ActiveAdmin::Themes::Recipe.new(root: Dir.pwd, entrypoint: "admin.css",
            active_admin_version: "4.0.0.beta22")
          abort "wrong source" unless $LOADED_FEATURES.any? { |path| path.include?("unpacked/lib/active_admin/themes/recipe.rb") }
          expected = #{packaged_concerns.inspect}.map { |path| File.binread(File.join("unpacked", path)) }
            .reject(&:empty?).join("\\n")
          composed = ActiveAdmin::Themes::Recipes::V3.source
          abort "wrong concern order or bytes" unless composed == expected
          abort "nondeterministic composition" unless ActiveAdmin::Themes::Recipes::V3.source == composed
          abort "install failed" unless recipe.install == :created && recipe.install == :identical
          abort "installed CSS differs" unless File.binread("active_admin_v3.css") == composed && !composed.empty?
        RUBY
      )
      expect(status.success?).to be(true), output
    end
  end
end
