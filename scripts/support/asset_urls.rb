# scripts/support/asset_urls.rb
# frozen_string_literal: true

module ThemeHost
  # Private verification helper, not part of the packaged gem API.
  module AssetUrls
    def self.local!(url)
      return url if url.is_a?(String) && url.start_with?("/assets/")

      raise ArgumentError, "Nonlocal asset cannot be verified offline: #{url.inspect}"
    end
  end
end
