# spec/filters_spec.rb
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Native filter behavior", type: :feature do
  before do
    visit "/login"
    fill_in "Demo Password", with: "demo"
    click_button "Sign In"
    visit "/admin/products"
  end

  def apply_filters
    fill_in "Name", with: "Product 01"
    select "ready", from: "Status"
    click_button "Filter"
  end

  it "submits labelled string and select fields and describes the applied query" do
    apply_filters

    expect(page).to have_css(".data-table tbody tr", count: 1)
    expect(page).to have_css('.active-filters-list [data-filter="name_cont"]', text: "Name contains Product 01")
    expect(page).to have_css('.active-filters-list [data-filter="status_eq"]', text: "Status equals ready")
  end

  it "retains values in the labelled controls after submitting" do
    apply_filters
    expect(page).to have_field("Name", with: "Product 01")
    expect(page).to have_select("Status", selected: "ready")
  end

  it "preserves numeric predicates and date bounds without rewriting the query" do
    visit "/admin/products?q[quantity_gt]=290&q[available_on_gteq]=2026-01-15&q[available_on_lteq]=2026-01-15"

    expect(page).to have_css(".data-table tbody tr", count: 3)
    expect(page).to have_css('.active-filters-list [data-filter="quantity_gt"]', text: "Quantity greater than 290")
    expect(page).to have_css("#q_quantity_input [data-search-methods] option[selected]", text: "Greater than")
  end

  it "retains both date bounds after submitting" do
    visit "/admin/products?q[available_on_gteq]=2026-01-15&q[available_on_lteq]=2026-01-15"
    expect(page).to have_field("q_available_on_gteq", with: "2026-01-15")
    expect(page).to have_field("q_available_on_lteq", with: "2026-01-15")
  end

  it "clears an empty search through the native reset link" do
    visit "/admin/products?q[name_cont]=No+such+synthetic+product"
    expect(page).to have_content("No Products found")

    click_link "Clear Filters"
    expect(page).to have_content("Showing 1-15 of 45")
    expect(page).not_to have_css(".active-filters")
  end

  it "retains applied filters when following native pagination" do
    visit "/admin/products?q[status_eq]=ready"
    find("[data-test-pagination] a", text: "2", exact_text: true).click

    expect(page).to have_content("Showing 16-23 of 23")
    expect(page).to have_select("Status", selected: "ready")
    expect(page).to have_css('.active-filters-list [data-filter="status_eq"]', text: "Status equals ready")
  end
end
