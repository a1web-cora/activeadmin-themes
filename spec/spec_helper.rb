# spec/spec_helper.rb
# frozen_string_literal: true

require "simplecov"
SimpleCov.start "rails"

require "rspec"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |expectations| expectations.syntax = :expect }
  config.order = :random
end
