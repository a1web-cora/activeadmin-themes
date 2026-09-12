# scripts/precompile_host.rb
# frozen_string_literal: true

ENV["RAILS_ENV"] = "production"
require "rake"
require_relative "../spec/host/config/environment"

Rails.application.load_tasks
Rake::Task["assets:precompile"].invoke
