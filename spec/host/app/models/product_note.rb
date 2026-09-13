# spec/host/app/models/product_note.rb
# frozen_string_literal: true

class ProductNote < ActiveRecord::Base
  belongs_to :product
  validates :body, presence: true
end
