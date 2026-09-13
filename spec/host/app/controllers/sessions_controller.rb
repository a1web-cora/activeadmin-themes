# spec/host/app/controllers/sessions_controller.rb
# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    render :new, layout: "demo_login"
  end

  def create
    if params[:password] == "demo"
      session[:demo] = true
      redirect_to "/admin", notice: "Synthetic demo session started."
    else
      flash.now[:error] = "Use the local demo password: demo"
      render :new, layout: "demo_login", status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to "/login"
  end

  def public_page
    render html: "<!doctype html><html><head><title>Public Page | Themes Lab</title></head>" \
                 "<body><h1>Public Page</h1><a href='/admin'>Open Themes Lab</a></body></html>".html_safe
  end
end
