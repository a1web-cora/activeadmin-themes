// spec/css_migrations_test.mjs
import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import test from "node:test";

import { migrationAdditions } from "../scripts/verify_css_migrations.mjs";

const core = { manifest: ["base", "addition"], sources: { base: "a {color:red;}", addition: "" } };
const snippet = ".b {color:blue;}";
const original = `${core.sources.base}\n${snippet}`;
const hash = (value) => createHash("sha256").update(value).digest("hex");
function manifest(source = original) {
  return {
    source_head: "a".repeat(40),
    source_git_blob: createHash("sha1").update(`blob ${Buffer.byteLength(source)}\0${source}`).digest("hex"),
    source_fixture: "original.css",
    cross_concern_order: "preserved",
    concerns: [{ part: "addition", fixture: "addition.css", sha256: hash(snippet) }],
  };
}
const read = (name) => name === "original.css" ? original : snippet;

test("accepts source-pinned additions without weakening core", () => {
  assert.equal(migrationAdditions(core, [manifest()], read).additions.get("addition"), snippet);
});
for (const [name, mutate] of [
  ["missing source SHA", (item) => { item.source_head = ""; }],
  ["bad original digest", (item) => { item.source_git_blob = "0".repeat(40); }],
  ["bad snippet digest", (item) => { item.concerns[0].sha256 = "0".repeat(64); }],
  ["unknown concern", (item) => { item.concerns[0].part = "unknown"; }],
  ["missing order disposition", (item) => { delete item.cross_concern_order; }],
  ["empty manifest", (item) => { item.concerns = []; }],
]) {
  test(`rejects ${name}`, () => {
    const item = manifest();
    mutate(item);
    assert.throws(() => migrationAdditions(core, [item], read));
  });
}
test("rejects duplicate assignments across manifests", () => {
  assert.throws(() => migrationAdditions(core, [manifest(), manifest()], read));
});
test("rejects invented snippet content even with an updated snippet digest", () => {
  const item = manifest();
  item.concerns[0].sha256 = hash(".b {color:green;}");
  assert.throws(() => migrationAdditions(core, [item], (name) => name === "original.css" ? original : ".b {color:green;}"));
});
test("rejects missing or duplicated additions by multiplicity", () => {
  for (const changed of ["", `${snippet}${snippet}`]) {
    const item = manifest();
    item.concerns[0].sha256 = hash(changed);
    assert.throws(() => migrationAdditions(core, [item], (name) => name === "original.css" ? original : changed));
  }
});
test("does not permit source snapshots that changed the core", () => {
  const changed = `a {color:green;}${snippet}`;
  assert.throws(() => migrationAdditions(core, [manifest(changed)], (name) => name === "original.css" ? changed : snippet));
});
test("strict order disposition rejects reordered old cross-concern rules", () => {
  const reversed = `${snippet}${core.sources.base}`;
  assert.throws(() => migrationAdditions(core, [manifest(reversed)], (name) => name === "original.css" ? reversed : snippet));
});
test("unreviewed ordering fails closed", () => {
  const reversed = `${snippet}${core.sources.base}`;
  const item = manifest(reversed);
  item.cross_concern_order = "requires-separate-review";
  assert.throws(() => migrationAdditions(core, [item], (name) => name === "original.css" ? reversed : snippet), /Unreviewed/);
});
test("a reviewed native-disjoint exception requires rationale and an existing contract", () => {
  const reversed = `${snippet}${core.sources.base}`;
  const item = manifest(reversed);
  item.cross_concern_order = "reviewed-native-disjoint";
  const readReversed = (name) => name === "original.css" ? reversed : snippet;
  assert.throws(() => migrationAdditions(core, [item], readReversed));
  item.order_review = { rationale: "Explicit test-only reviewed separation", contract_spec: "spec/nonexistent_spec.rb" };
  assert.throws(() => migrationAdditions(core, [item], readReversed));
  item.order_review.contract_spec = "../spec/css_structure_spec.rb";
  assert.throws(() => migrationAdditions(core, [item], readReversed));
  item.order_review.contract_spec = "spec/css_structure_spec.rb";
  const result = migrationAdditions(core, [item], readReversed);
  assert.match(result.notes[0], /native-disjoint exception uses spec\/css_structure_spec.rb/);
});
