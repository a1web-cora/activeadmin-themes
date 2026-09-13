# spec/host/config/routes.rb
# frozen_string_literal: true

Rails.application.routes.draw do
  get "/", to: "sessions#public_page"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  ActiveAdmin.routes(self)
end
