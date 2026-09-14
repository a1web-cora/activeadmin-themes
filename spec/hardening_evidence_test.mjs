// spec/hardening_evidence_test.mjs
import assert from "node:assert/strict";
import test from "node:test";

import { interactions, palettes, preferences, surfaces, validateHardeningEvidence, widths } from "../scripts/validate_hardening_evidence.mjs";

const sha = "a".repeat(40);
function complete() {
  const cases = [];
  const add = (entry) => cases.push({ status: "pass", observation: "Synthetic test observation, not browser evidence", reviewed_by: "test fixture", screenshot: { path: "synthetic.png", sha256: "b".repeat(64) }, viewport: { width: 1440, height: 900 }, zoom_percent: 100, ...entry });
  for (const width of widths) for (const palette of palettes) for (const surface of surfaces) add({ kind: "matrix", surface, palette, viewport: { width, height: 900 } });
  for (const palette of palettes) for (const surface of ["index", "new", "dashboard"]) add({ kind: "zoom", surface, palette, zoom_percent: 200, viewport: { width: 720, height: 450 }, zoom: { method: "browser-native", reported_factor: 2, baseline_css_width: 1440 } });
  for (const width of [390, 1440]) for (const palette of palettes) for (const interaction of interactions) add({ kind: "interaction", interaction, palette, viewport: { width, height: 900 } });
  for (const palette of palettes) for (const preference of preferences) add({ kind: "preference", palette, preference, preference_source: "browser-emulation", preference_active: true });
  return { source_sha: sha, cases };
}

test("complete synthetic ledger has 100 explicitly reviewed observations", () => {
  const manifest = complete();
  assert.equal(manifest.cases.length, 100);
  assert.deepEqual(validateHardeningEvidence(manifest, sha), []);
});
test("rejects stale or abbreviated source provenance", () => {
  assert.ok(validateHardeningEvidence(complete(), "c".repeat(40)).length);
  assert.ok(validateHardeningEvidence(complete(), "aaaaaaa").length);
});
test("rejects missing and duplicate cases rather than counting screenshots", () => {
  const manifest = complete();
  manifest.cases[1] = structuredClone(manifest.cases[0]);
  const errors = validateHardeningEvidence(manifest, sha);
  assert.ok(errors.some((error) => error.includes("found 2")));
  assert.ok(errors.some((error) => error.includes("found 0")));
});
for (const status of ["fail", "pending", "not tested", "accepted_deviation", undefined]) test(`does not infer a pass from ${status}`, () => {
  const manifest = complete();
  manifest.cases[0].status = status;
  assert.ok(validateHardeningEvidence(manifest, sha).some((error) => error.includes("unresolved")));
});
test("requires recorded review attribution, not only overflow measurements", () => {
  const manifest = complete();
  delete manifest.cases[0].reviewed_by;
  assert.ok(validateHardeningEvidence(manifest, sha).some((error) => error.includes("review attribution")));
});
test("rejects CSS scaling or unmeasured browser zoom", () => {
  for (const mutation of [(entry) => entry.zoom.method = "css-transform", (entry) => entry.zoom.reported_factor = 1, (entry) => entry.viewport.width = 1440]) {
    const manifest = complete();
    mutation(manifest.cases.find((entry) => entry.kind === "zoom"));
    assert.ok(validateHardeningEvidence(manifest, sha).some((error) => error.includes("native browser")));
  }
});
test("rejects unsupported or inactive preferences", () => {
  const manifest = complete();
  manifest.cases.find((entry) => entry.kind === "preference").preference_active = false;
  assert.ok(validateHardeningEvidence(manifest, sha).some((error) => error.includes("active preference")));
});
test("invalid or empty input remains incomplete", () => {
  assert.ok(validateHardeningEvidence(null, sha).length > 90);
  assert.ok(validateHardeningEvidence({ source_sha: sha, cases: [null] }, sha).length > 90);
});
test("allows recorded CSS viewport rounding without assuming outer window width", () => {
  const manifest = complete();
  const entry = manifest.cases.find((item) => item.kind === "zoom");
  entry.zoom.baseline_css_width = 1425;
  entry.viewport.width = 713;
  assert.deepEqual(validateHardeningEvidence(manifest, sha), []);
});
