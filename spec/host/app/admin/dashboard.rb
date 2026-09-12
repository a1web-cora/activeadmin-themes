# spec/host/app/admin/dashboard.rb
# frozen_string_literal: true

ActiveAdmin.register_page "Dashboard" do
  menu priority: 1
  content do
    panel "Synthetic Operator Overview" do
      para "This local laboratory uses synthetic, disposable data."
      para "45 products exercise scopes, filters, pagination, forms and status tags."
      a "Review Products", href: admin_products_path
    end
  end
end
