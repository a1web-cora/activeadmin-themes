# scripts/check_evidence.rb
# frozen_string_literal: true

require_relative "evidence_inventory"

abort "Usage: bin/evidence-check MANIFEST.json FULL_SOURCE_SHA" unless ARGV.size == 2
begin
  counts = EvidenceInventory.new(*ARGV).validate!
  puts "Evidence integrity valid: #{counts}. This is not visual acceptance."
rescue StandardError => e
  abort "Evidence invalid: #{e.message}"
end
