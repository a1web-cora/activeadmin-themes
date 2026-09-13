# spec/rails_helper.rb
# frozen_string_literal: true

require "spec_helper"

ENV["RAILS_ENV"] = "test"
require_relative "host/config/environment"
require_relative "host/spec_support/host_database"
require "capybara/rspec"

ThemeHost::Database.prepare!
Capybara.app = Rails.application
