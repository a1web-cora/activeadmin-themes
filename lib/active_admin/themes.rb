# lib/active_admin/themes.rb
# frozen_string_literal: true

require "active_admin/themes/registry"
require "active_admin/themes/theme"
require "active_admin/themes/v3"
require "active_admin/themes/version"

module ActiveAdmin
  module Themes
    def self.registry
      @registry ||= Registry.new.tap { |registry| registry.register(V3.theme) }
    end
  end
end
