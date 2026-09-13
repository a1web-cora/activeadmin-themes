# scripts/verify_host_assets.rb
# frozen_string_literal: true

ENV["RAILS_ENV"] = "production"
require "json"
require "nokogiri"
require_relative "../spec/host/config/environment"

abort "Production boot created a database" if Rails.root.join("tmp/host-#{Process.pid}.sqlite3").exist?
abort "Precompiled manifest missing" unless Rails.root.join("public/assets/.manifest.json").file?

session = ActionDispatch::Integration::Session.new(Rails.application)
session.host! "localhost"
session.get "/login"
abort "Login did not render" unless session.response.status == 200
document = Nokogiri::HTML(session.response.body)
stylesheets = document.css('link[rel="stylesheet"]').map { |link| link["href"] }
abort "Expected admin stylesheet" unless stylesheets.any? { |url| url.include?("active_admin-") }
stylesheets.each do |url|
  session.get url
  abort "Missing CSS #{url}" unless session.response.status == 200 && session.response.media_type == "text/css"
  abort "Theme not compiled into CSS" unless session.response.body.include?("--aat-surface")
end

maps = document.css('script[type="importmap"]')
abort "Expected one importmap" unless maps.length == 1
imports = JSON.parse(maps.first.text).fetch("imports")
abort "Canonical entrypoint missing" unless imports.key?("active_admin")
imports.each_value do |url|
  next unless url.start_with?("/assets/")

  session.get url
  abort "Missing JavaScript #{url}" unless session.response.status == 200 &&
                                           %w[application/javascript
                                              text/javascript].include?(session.response.media_type)
end

session.get "/"
abort "Public page did not render" unless session.response.status == 200
abort "Admin stylesheet leaked" if session.response.body.include?("active_admin-")
abort "Asset verification created a database" if Rails.root.join("tmp/host-#{Process.pid}.sqlite3").exist?
puts "Production artifact: login, CSS/theme bytes, local importmap ESM MIME, public isolation, and DB-free boot passed"
