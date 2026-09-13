# spec/host/spec_support/host_database.rb
# frozen_string_literal: true

module ThemeHost
  module Database
    def self.prepare!
      # Prepare before starting Puma threads; all threads share this process-local file.
      FileUtils.mkdir_p(Rails.root.join("tmp"))
      ActiveRecord::Base.establish_connection
      ActiveRecord::Base.connection_pool.with_connection do |connection|
        next if connection.table_exists?(:products) && connection.table_exists?(:product_notes)

        ActiveRecord::Base.transaction do
          load Rails.root.join("db/schema.rb")
          load Rails.root.join("db/seeds.rb")
        end
      end
    end
  end
end
