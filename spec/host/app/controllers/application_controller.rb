# spec/host/app/controllers/application_controller.rb
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_demo_user

  def authenticate_demo!
    redirect_to "/login" unless session[:demo]
  end

  def current_demo_user
    nil
  end
end
