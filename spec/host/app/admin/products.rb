# spec/host/app/admin/products.rb
# frozen_string_literal: true

ActiveAdmin.register Product do
  permit_params :name, :status, :quantity, :description, :available_on, :featured, :sample_file,
                product_notes_attributes: %i[id body _destroy]
  scope :all, default: true
  scope("Ready") { |products| products.where(status: "ready") }
  scope("Pending") { |products| products.where(status: "pending") }
  filter :name
  filter :status, as: :select, collection: %w[pending ready]
  filter :quantity
  filter :available_on

  index do
    selectable_column
    id_column
    column :name
    column :status do |product|
      status_tag product.status
    end
    column :quantity
    column :available_on
    actions
  end

  form do |form|
    form.semantic_errors
    form.inputs "Product Details" do
      form.input :name, hint: "A clear operator-facing label."
      form.input :status, as: :select, collection: %w[pending ready], include_blank: false
      form.input :quantity
      form.input :description
      form.input :available_on, as: :date_picker
      form.input :featured
      form.input :sample_file, as: :file, hint: "Synthetic presentation probe; uploads are not stored."
      form.has_many :product_notes, allow_destroy: true do |note|
        note.input :body
      end
    end
    form.actions
  end
end
