# spec/host/config/application.rb
# frozen_string_literal: true

require "bundler/setup"
require "rails" # Railties require Rails to be loaded first.
require "action_controller/railtie"
require "action_view/railtie"
require "active_record/railtie"
require "activeadmin"
require "importmap-rails"
require "propshaft"

module ThemeHost
  class Application < Rails::Application
    config.root = File.expand_path("..", __dir__)
    config.eager_load = false
    config.enable_reloading = false
    # Public fixture-only secret; never deploy this host configuration.
    config.secret_key_base = "local-synthetic-theme-host-" * 8
    config.hosts = ["127.0.0.1", "localhost", "www.example.com"]
    config.consider_all_requests_local = true
    config.action_controller.allow_forgery_protection = true
    config.logger = Logger.new($stderr)
    config.log_level = :warn
    config.assets.paths << root.join("app/assets/builds")
    config.active_record.database_selector = nil
  end
end
