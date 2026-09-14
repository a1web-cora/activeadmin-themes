# spec/feedback_host_spec.rb
# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Feedback host", type: :feature do
  before do
    visit "/login"
    fill_in "Demo Password", with: "demo"
    click_button "Sign In"
    visit "/admin/feedback"
  end

  it "renders native flash severities with their visible messages" do
    expect(page).to have_css("[data-test-page-header] + div > .bg-green-50", text: "Synthetic notice")
    expect(page).to have_css("[data-test-page-header] + div > .bg-yellow-50", text: "Synthetic warning")
    expect(page).to have_css("[data-test-page-header] + div > .bg-red-50", text: "Synthetic error")
  end

  it "keeps boolean, unset and arbitrary status words in native tags" do
    expect(page).to have_css('.status-tag[data-status="yes"]', text: "Yes")
    expect(page).to have_css('.status-tag[data-status="no"]', text: "No")
    expect(page).to have_css('.status-tag[data-status="unset"]')
    expect(page).to have_css(".status-tag", text: "Waiting On Operator")
  end

  it "renders panels without replacing their semantic heading" do
    expect(page).to have_css("h3.panel-title", text: "Status Vocabulary")
    expect(page).to have_css(".panel-body .bg-green-50", text: "host-owned")
  end

  it "retains attributes and native destructive action confirmation" do
    visit "/admin/products/1"
    expect(page).to have_css(".attributes-table", text: "Synthetic Product 01")
    expect(page).to have_css('a[data-method="delete"][data-confirm]', text: "Delete Product")
  end
end
