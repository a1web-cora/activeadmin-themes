# spec/login_dashboard_spec.rb
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "V3 opt-in login and dashboard", type: :feature do
  it "keeps the opt-in login outside index table hooks" do
    visit "/login"
    expect(page).not_to have_css(".data-table, .paginated-collection")
  end

  it "keeps the fixture dashboard composition outside index table hooks" do
    visit "/login"
    fill_in "Demo Password", with: "demo"
    click_button "Sign In"
    expect(page).not_to have_css("[data-theme-dashboard] .data-table, [data-theme-dashboard] .paginated-collection")
  end

  it "keeps native index tables outside opt-in surface hooks" do
    visit "/login"
    fill_in "Demo Password", with: "demo"
    click_button "Sign In"
    visit "/admin/products"
    expect(page).not_to have_css("[data-theme-login], [data-theme-dashboard]")
  end

  it "exposes a labelled fixture login without pretending to be production authentication" do
    visit "/login"
    expect(page).to have_title("Login | ActiveAdmin Themes Lab")
    expect(page).to have_css('body[data-activeadmin-theme="v3"] [data-theme-login]')
    expect(page).to have_field("Demo Password", type: "password")
    expect(page).to have_content("Local synthetic demo")
  end

  it "announces rejected credentials while retaining the login form" do
    visit "/login"
    fill_in "Demo Password", with: "incorrect"
    click_button "Sign In"
    expect(page).to have_css('[role="alert"]', text: "Use the local demo password: demo")
    expect(page).to have_css("[data-theme-login]")
  end

  it "opens the native dashboard with useful product navigation" do
    visit "/login"
    fill_in "Demo Password", with: "demo"
    click_button "Sign In"
    expect(page).to have_css("[data-theme-dashboard]", text: "Synthetic Operator Overview")
    expect(page).to have_link("Review Products", href: "/admin/products")
  end

  it "leaves public pages outside both composition hooks" do
    visit "/"
    expect(page).not_to have_css("[data-theme-login], [data-theme-dashboard], [data-activeadmin-theme]")
    expect(page).not_to have_css('link[rel="stylesheet"]', visible: false)
  end
end
