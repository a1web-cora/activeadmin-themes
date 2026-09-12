# lib/active_admin/themes/recipe.rb
# frozen_string_literal: true

require "active_admin/themes"
require "active_admin/themes/installation_plan"

module ActiveAdmin
  module Themes
    # Copies one canonical stylesheet beside an explicitly selected Tailwind
    # entrypoint. Existing files are never replaced. Import wiring is app-owned.
    class Recipe
      class Conflict < StandardError; end

      attr_reader :destination, :entrypoint, :theme

      def initialize(root:, entrypoint:, active_admin_version:, key: :v3)
        @theme = Themes.registry.fetch(key)
        @root = Pathname.new(root).realpath
        @entrypoint = entrypoint
        @version = active_admin_version
        validate_entrypoint!
        @destination = Pathname.new(entrypoint).dirname.join("active_admin_#{theme.key}.css").to_s
      end

      def status
        plan.status.fetch(destination)
      end

      def install
        current = status
        raise Conflict, "locally modified file: #{destination}" if current == :modified
        return :identical if current == :identical

        validate_entrypoint!
        File.open(@root.join(destination), File::WRONLY | File::CREAT | File::EXCL, 0o644) do |file|
          file.write(source)
        end
        :created
      end

      def instructions
        "Add @import \"./active_admin_#{theme.key}.css\"; to #{entrypoint}, then run your existing CSS build."
      end

      private

      def source
        File.binread(File.expand_path("recipes/#{theme.key}.css", __dir__))
      end

      def plan
        InstallationPlan.new(root: @root, theme: theme, active_admin_version: @version,
                             files: { destination => source })
      end

      def validate_entrypoint!
        check = InstallationPlan.new(root: @root, theme: theme, active_admin_version: @version,
                                     files: { entrypoint => "" })
        raise ArgumentError, "styling entrypoint does not exist" if check.status.fetch(entrypoint) == :missing
        return if @root.join(entrypoint).read.include?("tailwindcss")

        raise ArgumentError, "select the existing Tailwind CSS entrypoint"
      end
    end
  end
end
