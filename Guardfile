# Guardfile
# frozen_string_literal: true

guard :bundler do
  watch("Gemfile")
  watch(/^.+\.gemspec$/)
end

guard :rspec, cmd: "bin/test" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |match| "spec/#{match[1]}_spec.rb" }
  watch("spec/spec_helper.rb") { "spec" }
end

guard :rubocop, cli: ["--parallel"] do
  watch(/.+\.rb$/)
  watch(%r{(?:^|/)(?:\.rubocop\.yml|Gemfile|Rakefile|.+\.gemspec)$})
end
