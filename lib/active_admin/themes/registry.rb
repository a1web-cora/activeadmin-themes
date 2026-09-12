# lib/active_admin/themes/registry.rb
# frozen_string_literal: true

module ActiveAdmin
  module Themes
    class Registry
      include Enumerable

      def initialize
        @themes = {}
      end

      def each(&)
        themes.each_value(&)
      end

      def fetch(key)
        themes.fetch(key.to_sym)
      end

      def register(theme)
        raise ArgumentError, "theme #{theme.key.inspect} is already registered" if themes.key?(theme.key)

        themes[theme.key] = theme
        self
      end

      def keys
        themes.keys.freeze
      end

      private

      attr_reader :themes
    end
  end
end
