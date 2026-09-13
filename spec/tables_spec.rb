# spec/tables_spec.rb
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V3 native index contracts", type: :feature do
  before do
    visit "/login"
    fill_in "Demo Password", with: "demo"
    click_button "Sign In"
  end

  it "retains sortable numeric columns and native row selection" do
    visit "/admin/products?order=quantity_asc"
    expect(page).to have_css('.data-table th[data-column="quantity"][data-sort-direction="asc"]')
    expect(page).to have_css('.data-table tbody input[type="checkbox"]', count: 15)
    expect(page).to have_css('.data-table tbody tr:first-child [data-column="quantity"]', text: "0", exact_text: true)
  end

  it "reverses numeric sorting through the native header link" do
    visit "/admin/products?order=quantity_asc"
    click_link "Quantity"
    expect(page).to have_css('.data-table th[data-column="quantity"][data-sort-direction="desc"]')
    expect(page).to have_css('.data-table tbody tr:first-child [data-column="quantity"]', text: "308", exact_text: true)
  end

  it "retains selected scopes and native current-page presentation hooks" do
    visit "/admin/products?scope=ready&page=2"
    expect(page).to have_css(".scopes .index-button-selected", text: "Ready 23")
    expect(page).to have_css(".paginated-collection-pagination a.bg-blue-500", text: "2", exact_text: true)
    expect(page).to have_content("Showing 16-23 of 23")
    expect(page).to have_css(".data-table tbody tr", count: 8)
  end

  it "keeps empty results free of fabricated table rows" do
    visit "/admin/products?q[name_eq]=missing-product"
    expect(page).to have_content("No Products found")
    expect(page).not_to have_css(".data-table tbody tr")
  end
end
