# spec/host/config/environment.rb
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

ThemeHost::Application.initialize!

# A process-local SQLite fixture shares synthetic data across Puma threads.
FileUtils.mkdir_p(Rails.root.join("tmp"))
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3", database: Rails.root.join("tmp/host-#{Process.pid}.sqlite3").to_s
)
ActiveRecord::Schema.define do
  create_table :products do |table|
    table.string :name, null: false
    table.string :status, null: false
    table.integer :quantity, default: 0, null: false
    table.text :description
    table.date :available_on
    table.boolean :featured, default: false
    table.timestamps
  end
  create_table :product_notes do |table|
    table.references :product, null: false
    table.string :body, null: false
  end
end

45.times do |index|
  Product.create!(name: "Synthetic Product #{format('%02d', index + 1)}",
                  status: index.even? ? "ready" : "pending", quantity: index * 7,
                  description: "Synthetic operator fixture with a deliberately long identifier: #{'ABC-' * 20}",
                  available_on: Date.new(2026, 1, 15), created_at: Time.utc(2026, 1, 1),
                  updated_at: Time.utc(2026, 1, 1))
end
