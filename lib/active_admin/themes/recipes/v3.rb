# lib/active_admin/themes/recipes/v3.rb
# frozen_string_literal: true

module ActiveAdmin
  module Themes
    module Recipes
      module V3
        PARTS = %w[
          foundation/tokens
          foundation/base
          components/navigation
          components/tables
          components/filters
          components/forms
          components/panels
          components/feedback
          surfaces/login
          surfaces/dashboard
          hardening/responsive
          hardening/preferences
        ].freeze

        module_function

        def source
          PARTS.filter_map do |part|
            content = File.binread(File.expand_path("v3/#{part}.css", __dir__))
            content unless content.empty?
          end.join("\n")
        end
      end
    end
  end
end
