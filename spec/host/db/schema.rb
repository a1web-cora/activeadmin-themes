# spec/host/db/schema.rb
# frozen_string_literal: true

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
