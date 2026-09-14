# spec/palette_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "active_admin/themes/recipes/v3"

# rubocop:disable-next RSpec/DescribeClass
RSpec.describe "V3 semantic palette" do
  stylesheet = ActiveAdmin::Themes::Recipes::V3.source
  palettes = stylesheet.scan(/--aat-background:.*?\n\}/m).first(2)

  it "declares both light and dark palettes" do
    expect(ActiveAdmin::Themes::Recipes::V3.source.scan("--aat-background:").length).to eq(2)
  end

  palettes.each_with_index do |declarations, index|
    context "with palette #{index}" do
      let(:tokens) { declarations.scan(/--aat-([\w-]+): (#[\da-f]{6});/).to_h }

      def luminance(hex)
        channels = hex.delete_prefix("#").scan(/../).map do |channel|
          value = channel.to_i(16) / 255.0
          value <= 0.04045 ? value / 12.92 : ((value + 0.055) / 1.055)**2.4
        end
        channels.zip([0.2126, 0.7152, 0.0722]).sum { |channel, weight| channel * weight }
      end

      def contrast(first, second)
        low, high = [first, second].map { |key| luminance(tokens.fetch(key)) }.sort
        (high + 0.05) / (low + 0.05)
      end

      %w[text muted link].each do |role|
        it "gives #{role} at least 4.5:1 against the surface" do
          expect(contrast(role, "surface")).to be >= 4.5
        end
      end

      %w[danger success warning].each do |role|
        it "gives #{role} feedback at least 4.5:1" do
          expect(contrast(role, "#{role}-bg")).to be >= 4.5
        end
      end

      [%w[text background], %w[text subtle], %w[text selected], %w[muted subtle],
       %w[link subtle], %w[link selected]].each do |foreground, background|
        it "gives #{foreground} at least 4.5:1 against #{background}" do
          expect(contrast(foreground, background)).to be >= 4.5
        end
      end

      %w[surface background selected].each do |background|
        it "gives focus at least 3:1 against #{background}" do
          expect(contrast("focus", background)).to be >= 3
        end
      end

      it "gives control boundaries at least 3:1" do
        expect(contrast("border", "surface")).to be >= 3
      end
    end
  end
end
