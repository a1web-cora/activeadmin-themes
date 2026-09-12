# lib/active_admin/themes/installation_plan.rb
# frozen_string_literal: true

require "pathname"

module ActiveAdmin
  module Themes
    # Read-only preflight for explicit, application-owned recipe files. A later
    # writer must revalidate the plan immediately before performing any writes.
    class InstallationPlan
      class UnsafePath < ArgumentError; end

      def initialize(root:, theme:, active_admin_version:, files:)
        raise ArgumentError, "unsupported ActiveAdmin version" unless theme.supports?(active_admin_version)

        @root = Pathname.new(root).realpath
        @files = files.to_h { |path, content| [String(path).dup.freeze, String(content).dup.freeze] }.freeze
      end

      def status
        files.to_h do |path, content|
          destination = resolve(path)
          [path, state(destination, content)]
        end.freeze
      end

      def installable?
        status.values.none?(:modified)
      end

      private

      attr_reader :files, :root

      def resolve(path)
        parts = path.split("/", -1)
        if Pathname.new(path).absolute? || parts.intersect?(["", ".", ".."])
          raise UnsafePath, "recipe paths must be normalized relative paths"
        end

        parts.inject(root) do |parent, part|
          candidate = parent.join(part)
          raise UnsafePath, "recipe paths cannot traverse symlinks" if candidate.symlink?

          candidate
        end
      end

      def state(destination, content)
        return :missing unless destination.exist?
        raise UnsafePath, "recipe destination must be a regular file" unless destination.file?

        destination.binread == content.b ? :identical : :modified
      end
    end
  end
end
