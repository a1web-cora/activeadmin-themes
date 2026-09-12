# spec/host/app/admin/dashboard.rb
# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1
  content do
    div "data-theme-dashboard": true do
      panel "Synthetic Operator Overview" do
        para "This local laboratory uses synthetic, disposable data."
        para "45 products exercise scopes, filters, pagination, forms and status tags."
        a "Review Products", href: admin_products_path
      end
      panel "Ready For Review" do
        para "Synthetic readiness is a host fixture, not theme business logic."
        status_tag "Ready"
      end
      panel "Long Content" do
        para "Synthetic identifier: #{'REFERENCE-' * 25}"
      end
    end
  end
end
