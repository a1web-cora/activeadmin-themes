# lib/active_admin/themes/v3.rb
# frozen_string_literal: true

module ActiveAdmin
  module Themes
    module V3
      module_function

      def theme
        Theme.new(
          key: :v3,
          name: "ActiveAdmin V3",
          description: "AA3.5-inspired visual discipline on ActiveAdmin 4's modern foundation.",
          active_admin_requirement: [">= 4.0.0.beta22", "< 5"],
          recipe_version: "1"
        )
      end
    end
  end
end
