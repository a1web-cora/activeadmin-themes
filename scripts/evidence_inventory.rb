# scripts/evidence_inventory.rb
# frozen_string_literal: true

require "digest"
require "json"
require "pathname"

# Validates recorded provenance, never infers visual acceptance from an image.
class EvidenceInventory
  def initialize(path, expected_sha)
    @path = Pathname(path).realpath
    @expected_sha = expected_sha
  end

  def validate!
    data = JSON.parse(@path.read)
    validate_source!(data)
    cases = data.fetch("cases")
    validate_ids!(cases)
    cases.each { |item| validate_case!(item) }
    cases.group_by { |item| item.fetch("status") }.transform_values(&:size)
  end

  private

  def validate_source!(data)
    raise "Unsupported schema" unless data.fetch("schema_version") == 1
    raise "Expected full source SHA" unless /\A[0-9a-f]{40}\z/.match?(@expected_sha)
    raise "Source SHA mismatch" unless data.fetch("source_sha") == @expected_sha

    %w[browser operating_system captured_at build_command].each { |key| present!(data, key) }
  end

  def validate_ids!(cases)
    raise "Empty evidence inventory" unless cases.is_a?(Array) && !cases.empty?
    raise "Duplicate case IDs" unless cases.map { |item| item.fetch("id") }.uniq.size == cases.size
  end

  def present!(data, key)
    raise "Missing #{key}" unless data.fetch(key).is_a?(String) && !data.fetch(key).strip.empty?
  end

  def validate_case!(item)
    %w[id route observation].each { |key| present!(item, key) }
    raise "Invalid palette" unless %w[light dark native].include?(item.fetch("palette"))
    raise "Invalid status" unless %w[pass fail pending not-tested].include?(item.fetch("status"))

    validate_dimensions!(item)
    return unless %w[pass fail].include?(item.fetch("status"))

    verify_artifact!(item.fetch("screenshot"))
  end

  def validate_dimensions!(item)
    %w[width height].each do |dimension|
      raise "Invalid viewport" unless item.fetch("viewport").fetch(dimension).is_a?(Integer) &&
                                      item.fetch("viewport").fetch(dimension).positive?
    end
    raise "Invalid zoom" unless item.fetch("zoom_percent").is_a?(Numeric) && item.fetch("zoom_percent").positive?
  end

  def verify_artifact!(artifact)
    resolved = artifact_path(artifact.fetch("path"))
    raise "Artifact is not a PNG file" unless resolved.file? && resolved.binread(8) == "\x89PNG\r\n\x1a\n".b
    raise "Artifact hash mismatch" unless Digest::SHA256.file(resolved).hexdigest == artifact.fetch("sha256")
  end

  def artifact_path(path)
    relative = Pathname(path)
    raise "Artifact must be relative" if relative.absolute?

    resolved = @path.dirname.join(relative).realpath
    raise "Artifact escapes evidence directory" unless resolved.to_s.start_with?("#{@path.dirname}/")

    resolved
  end
end
