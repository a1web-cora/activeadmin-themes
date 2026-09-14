# spec/forms_spec.rb
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V3 host forms", type: :feature do
  before do
    visit "/login"
    fill_in "Demo Password", with: "demo"
    click_button "Sign In"
  end

  it "keeps the native index table outside Formtastic forms" do
    visit "/admin/products"
    expect(page).to have_css(".data-table")
    expect(page).not_to have_css(".formtastic .data-table")
  end

  %w[new 1/edit].each do |path|
    it "keeps the native #{path} form outside data-table styling" do
      visit "/admin/products/#{path}"
      expect(page).to have_css(".formtastic")
      expect(page).not_to have_css(".data-table")
    end
  end

  it "retains required markers, hints, disabled fields, and cancel navigation" do
    visit "/admin/products/new"
    expect(page).to have_css("#product_name_input.required label abbr", text: "*")
    expect(page).to have_content("A clear operator-facing label.")
    expect(page).to have_field("Fixture ID", disabled: true)
    expect(page).to have_link("Cancel")
  end

  it "retains native select, numeric, and multiline controls" do
    visit "/admin/products/new"
    expect(page).to have_select("Status", options: %w[pending ready])
    expect(page).to have_field("Quantity", type: "number")
    expect(page).to have_field("Description", type: "textarea")
  end

  it "retains native date, boolean, and file controls" do
    visit "/admin/products/new"
    expect(page).to have_field("Available on", type: "date")
    expect(page).to have_field("Featured", type: "checkbox")
    expect(page).to have_field("Sample file", type: "file")
  end

  context "with invalid submitted values" do
    before do
      visit "/admin/products/new"
      fill_in "Name", with: ""
      fill_in "Quantity", with: "-1"
      click_button "Create Product"
    end

    it "keeps errors textual and retains the submitted values" do
      expect(page).to have_css("#product_name_input.error .inline-errors", text: "can't be blank")
      expect(page).to have_css("#product_quantity_input.error .inline-errors",
                               text: "must be greater than or equal to 0")
      expect(page).to have_field("Quantity", with: "-1")
    end
  end

  context "with a persisted nested note" do
    let(:product) { Product.create!(name: "Form probe", status: "pending", quantity: 2) }
    let!(:note) { product.product_notes.create!(body: "Original note") }

    before do
      visit "/admin/products/#{product.id}/edit"
      fill_in "Name", with: "Updated form probe"
      fill_in "Body", with: "Updated note"
      check "Featured"
      click_button "Update Product"
    end

    after { product.destroy! }

    it "updates the record and nested note through framework submission" do
      expect(product.reload.name).to eq("Updated form probe")
      expect(product.featured).to be(true)
      expect(note.reload.body).to eq("Updated note")
    end
  end
end
