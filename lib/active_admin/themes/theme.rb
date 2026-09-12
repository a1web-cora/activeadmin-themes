# lib/active_admin/themes/theme.rb
# frozen_string_literal: true

module ActiveAdmin
  module Themes
    Theme = Data.define(:key, :name, :description, :active_admin_requirement, :recipe_version) do
      def initialize(key:, name:, description:, active_admin_requirement:, recipe_version:)
        super(
          key: key.to_sym,
          name: String(name).freeze,
          description: String(description).freeze,
          active_admin_requirement: Gem::Requirement.create(active_admin_requirement).freeze,
          recipe_version: String(recipe_version).freeze
        )
      end

      def supports?(version)
        active_admin_requirement.satisfied_by?(Gem::Version.new(version))
      end
    end
  end
end
