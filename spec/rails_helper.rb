# spec/rails_helper.rb
# frozen_string_literal: true

require "spec_helper"

ENV["RAILS_ENV"] = "test"
require_relative "host/config/environment"
require "capybara/rspec"

Capybara.app = Rails.application
