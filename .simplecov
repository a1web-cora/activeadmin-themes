# .simplecov
# frozen_string_literal: true

SimpleCov.configure do
  enable_coverage :branch
  minimum_coverage 100
  minimum_coverage_by_file 100
  add_filter "/spec/"
  # Bundler loads this file from the gemspec before SimpleCov can start.
  add_filter "/lib/active_admin/themes/version.rb"
end
