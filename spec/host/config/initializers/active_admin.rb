# spec/host/config/initializers/active_admin.rb
# frozen_string_literal: true

ActiveAdmin.setup do |config|
  config.site_title = "ActiveAdmin Themes Lab"
  config.authentication_method = :authenticate_demo!
  config.current_user_method = :current_demo_user
  config.logout_link_path = :logout_path
  config.comments = false
  config.batch_actions = true
  config.default_per_page = 15
end
