<!-- spec/fixtures/css_migrations/README.md -->

# Accepted-Source Concern Migration Fixtures

Each migration adds one JSON manifest, an exact original CSS snapshot from its
declared PR head, and concern snippet CSS files. Record `source_head` (full commit),
`source_git_blob` (the original CSS blob), `source_fixture` (local basename),
`cross_concern_order`, and `concerns` entries with `part`, `fixture`, and `sha256`.
Verify source snapshots with Git before recording them; tests run offline.

Use production manifest concern names. Each concern may be assigned only once.
All fixture names must be plain CSS basenames inside this directory. Snippets
may reconstruct enclosing selector blocks and change comments, but must preserve
exact declaration contexts and multiplicity from the original source additions.
The pinned architectural core is never replaced by a migration fixture: additions
to `hardening/responsive` supplement its existing gutter rule.

The contract separately checks immutable core preservation, digest provenance,
snippet membership/multiplicity, per-concern structural/cascade preservation,
and full **new-manifest** composition. Snippet provenance inventory is explicitly
order-independent; it does not prove old cross-concern cascade equivalence.

Set `cross_concern_order` to `preserved` only when the strict comparator passes
between the original full source and the new core-plus-this-migration ordering.
Otherwise `requires-separate-review` fails CI until Deputy assesses commutation
against actual AA4 hooks. Only after that review may an exception use
`reviewed-native-disjoint`, with `order_review.rationale` documenting the approved
boundary and `order_review.contract_spec` naming an existing nonempty
`spec/**/*_spec.rb` contract. That contract must exercise the reviewed boundary in
the full suite. File presence is not a proof of its meaning; the reviewer remains
responsible for validating it. The exception is printed in CI and is not a claim
of arbitrary old cross-concern equivalence or visual acceptance. Do not silently
fix cascade behavior as part of an architecture-only migration.

Run `bin/ci` after installing locked npm dependencies. The original legacy fixture,
its provenance and digest remain immutable. Changes to core mapping, manifests or
golden snippets are reviewable test inputs, never an automatic baseline refresh.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
