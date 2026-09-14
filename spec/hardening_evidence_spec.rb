# spec/hardening_evidence_spec.rb
# frozen_string_literal: true

require "spec_helper"
require "open3"

# rubocop:disable-next RSpec/DescribeClass
RSpec.describe "Hardening observation ledger" do
  it "rejects incomplete, stale, unreviewed and simulated acceptance evidence" do
    output, status = Open3.capture2e("node", "--test", "spec/hardening_evidence_test.mjs")

    expect(status.success?).to be(true), output
  end
end
