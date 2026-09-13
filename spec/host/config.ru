# spec/host/config.ru
# frozen_string_literal: true

require_relative "config/environment"
require_relative "spec_support/host_database"

ThemeHost::Database.prepare!
run Rails.application
