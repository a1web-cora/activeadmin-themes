# spec/host_spec.rb
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Synthetic theme host", type: :feature do
  before do
    visit "/login"
    fill_in "Demo Password", with: "demo"
    click_button "Sign In"
  end

  it "renders the dashboard and real resource controls" do
    expect(page).to have_content("Synthetic Operator Overview")
    visit "/admin/products"
    expect(page).to have_content("Showing 1-15 of 45")
    expect(page).to have_field("Name")
    expect(page).to have_link("Ready 23")
  end

  it "filters synthetic products through ActiveAdmin" do
    visit "/admin/products"
    fill_in "Name", with: "Product 01"
    click_button "Filter"
    expect(page).to have_content("Synthetic Product 01")
    expect(page).not_to have_content("Synthetic Product 45")
  end

  it "renders validation errors through the host form" do
    visit "/admin/products/new"
    fill_in "Name", with: ""
    click_button "Create Product"
    expect(page).to have_content("can't be blank")
  end

  it "serves admin CSS" do
    visit "/admin"
    asset = find('link[rel="stylesheet"]', visible: false)[:href]
    page.driver.browser.get(asset)
    expect(page.driver.response.status).to eq(200)
    expect(page.driver.response.headers["content-type"]).to include("text/css")
  end

  it "renders native JavaScript hooks exactly once" do
    expect(page).to have_css('script[type="importmap"]', count: 1, visible: false)
    expect(page).to have_css('script[type="module"]', text: 'import "active_admin"', count: 1, visible: false)
    expect(page).to have_css('button[aria-label="Toggle dark mode"]')
  end

  it "renders native method-aware logout for the synthetic operator" do
    expect(page).to have_css('#user-menu a[data-method="delete"][href="/logout"]', visible: false)
    expect(page).to have_css("#user-menu", text: "Synthetic Operator", visible: false)
  end

  it "renders nested and file input controls" do
    visit "/admin/products/new"
    expect(page).to have_link("Add New Product note")
    expect(page).to have_field("Sample file", type: "file")
    expect(page).to have_field("Available on", type: "date")
  end

  it "preserves scope and pagination queries" do
    visit "/admin/products?scope=ready&page=2"
    expect(page).to have_content("Showing 16-23 of 23")
    expect(page).not_to have_css('.status-tag[data-status="pending"]')
  end

  it "renders a genuine empty result" do
    visit "/admin/products?q[name_eq]=no-synthetic-match"
    expect(page).not_to have_css(".data-table tbody tr")
    expect(page).to have_content("No Products found")
  end

  it "excludes admin CSS from the public layout" do
    visit "/"
    expect(page).not_to have_css('link[rel="stylesheet"]', visible: false)
  end
end
