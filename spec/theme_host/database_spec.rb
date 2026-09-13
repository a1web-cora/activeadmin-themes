# spec/theme_host/database_spec.rb
# frozen_string_literal: true

require "rails_helper"

require "open3"
require "rbconfig"

RSpec.describe ThemeHost::Database do
  let(:script) do
    <<~'RUBY'
      require_relative "spec/host/config/environment"
      path = Rails.root.join("tmp/host-#{Process.pid}.sqlite3")
      abort "boot created a database" if path.exist?
      abort "application did not initialize" unless Rails.application.initialized?

      require_relative "spec/host/spec_support/host_database"
      ThemeHost::Database.prepare!
      abort "missing fixture records" unless Product.count == 45
      product = Product.first
      product.update!(name: "Operator edit")
      product.product_notes.create!(body: "Operator note")
      ThemeHost::Database.prepare!
      abort "duplicate records" unless Product.count == 45
      abort "lost operator edit" unless product.reload.name == "Operator edit"
      abort "lost nested record" unless product.product_notes.count == 1
      count = Thread.new { ActiveRecord::Base.connection_pool.with_connection { Product.count } }.value
      abort "thread cannot see fixtures" unless count == 45
    RUBY
  end

  it "boots without a database, then explicitly prepares repeat-safe cross-thread fixtures" do
    output, status = Open3.capture2e({ "RAILS_ENV" => "test" }, RbConfig.ruby, "-e", script)

    expect(status.success?).to be(true), output
  end
end
