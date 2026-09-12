# spec/host/app/models/product.rb
# frozen_string_literal: true

class Product < ActiveRecord::Base
  has_many :product_notes, dependent: :destroy
  accepts_nested_attributes_for :product_notes, allow_destroy: true
  attr_accessor :sample_file

  validates :name, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(_auth = nil)
    %w[available_on created_at description featured id name quantity status updated_at]
  end

  def self.ransackable_associations(_auth = nil)
    []
  end
end
