// scripts/validate_hardening_evidence.mjs
import { readFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

export const surfaces = ["index", "show", "new", "edit", "dashboard", "login", "validation", "empty", "long"];
export const widths = [390, 768, 1024, 1440];
export const palettes = ["light", "dark"];
export const interactions = ["navigation", "index", "filters", "forms"];
export const preferences = ["coarse-pointer", "reduced-motion", "forced-colors"];

// Checks completeness of recorded observations, not visual correctness. The #11
// artifact validator separately checks provenance and the referenced image bytes.
export function validateHardeningEvidence(manifest, expectedSha) {
  const errors = [];
  if (!/^[0-9a-f]{40}$/.test(expectedSha ?? "") || manifest?.source_sha !== expectedSha) {
    errors.push("source_sha must match the requested full exact head");
  }
  const cases = Array.isArray(manifest?.cases) ? manifest.cases.filter((entry) => entry && typeof entry === "object") : [];
  if (cases.length !== manifest?.cases?.length) errors.push("cases must be an array of observation objects");
  function requireCase(label, predicate, extra = () => {}) {
    const matches = cases.filter(predicate);
    if (matches.length !== 1) {
      errors.push(`${label}: expected exactly one observation, found ${matches.length}`);
      return;
    }
    const entry = matches[0];
    if (entry.status !== "pass") errors.push(`${label}: unresolved status ${entry.status ?? "missing"}`);
    if (typeof entry.observation !== "string" || !entry.observation.trim()) errors.push(`${label}: missing observation`);
    if (typeof entry.reviewed_by !== "string" || !entry.reviewed_by.trim()) errors.push(`${label}: missing human/image review attribution`);
    if (!entry.screenshot?.path || !/^[0-9a-f]{64}$/.test(entry.screenshot?.sha256 ?? "")) errors.push(`${label}: missing screenshot reference/hash`);
    if (!Number.isFinite(entry.viewport?.height) || entry.viewport.height <= 0) errors.push(`${label}: missing viewport height`);
    extra(entry, label);
  }
  for (const width of widths) for (const palette of palettes) for (const surface of surfaces) {
    requireCase(`matrix/${width}/${palette}/${surface}`, (entry) => entry.kind === "matrix" && entry.surface === surface && entry.palette === palette && entry.viewport?.width === width && entry.zoom_percent === 100);
  }
  for (const palette of palettes) for (const surface of ["index", "new", "dashboard"]) {
    requireCase(`zoom/${palette}/${surface}`, (entry) => entry.kind === "zoom" && entry.surface === surface && entry.palette === palette && entry.zoom_percent === 200, (entry, label) => {
      const baseline = entry.zoom?.baseline_css_width;
      if (entry.zoom?.method !== "browser-native" || entry.zoom?.reported_factor !== 2 || !Number.isFinite(baseline) || baseline <= 0 || !Number.isFinite(entry.viewport?.width) || Math.abs(entry.viewport.width - baseline / 2) > 2) errors.push(`${label}: requires native browser 2x zoom and measured CSS viewport approximately half its unzoomed baseline`);
    });
  }
  for (const width of [390, 1440]) for (const palette of palettes) for (const interaction of interactions) {
    requireCase(`interaction/${width}/${palette}/${interaction}`, (entry) => entry.kind === "interaction" && entry.interaction === interaction && entry.palette === palette && entry.viewport?.width === width && entry.zoom_percent === 100);
  }
  for (const palette of palettes) for (const preference of preferences) {
    requireCase(`preference/${palette}/${preference}`, (entry) => entry.kind === "preference" && entry.preference === preference && entry.palette === palette, (entry, label) => {
      if (!["browser-emulation", "native-os", "physical-device"].includes(entry.preference_source) || entry.preference_active !== true) errors.push(`${label}: missing active preference observation/method`);
    });
  }
  return errors;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    if (process.argv.length !== 4) throw new Error("Usage: node scripts/validate_hardening_evidence.mjs MANIFEST.json FULL_SOURCE_SHA");
    const errors = validateHardeningEvidence(JSON.parse(readFileSync(process.argv[2], "utf8")), process.argv[3]);
    if (errors.length) throw new Error(errors.join("\n"));
    console.log("Hardening observation ledger complete; artifact verification and Sheriff/Deputy acceptance remain separate.");
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
