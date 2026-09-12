# activeadmin-themes.gemspec
# frozen_string_literal: true

require_relative "lib/active_admin/themes/version"

Gem::Specification.new do |spec|
  spec.name = "activeadmin-themes"
  spec.version = ActiveAdmin::Themes::VERSION
  spec.authors = ["Stan Carver II"]
  spec.email = ["howdy@stancarver.com"]
  spec.summary = "Explicit, installable visual theme recipes for ActiveAdmin"
  spec.description = "Inspectable ActiveAdmin theme recipes that applications deliberately install and own."
  spec.homepage = "https://github.com/scarver2/activeadmin-themes"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"
  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "documentation_uri" => "#{spec.homepage}#readme",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
    "source_code_uri" => spec.homepage
  }
  spec.files = Dir.chdir(__dir__) { Dir["CHANGELOG.md", "LICENSE", "README.md", "lib/**/*", "signature/**/*"] }
  spec.require_paths = ["lib"]
  spec.add_dependency "activeadmin", ">= 4.0.0.beta22", "< 5"
end
