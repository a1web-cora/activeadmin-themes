// scripts/verify_css_migrations.mjs
import { createHash } from "node:crypto";
import { readFileSync, readdirSync, realpathSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

import { assertAdditionProvenance, compareSources } from "./css_structure.mjs";

const root = dirname(dirname(fileURLToPath(import.meta.url)));
const fixtures = join(root, "spec/fixtures");
const coreDigest = "0e07817811dee0b6a7881bf146666c84ccb0d39e6aad2c2c459b908375752bcb";
const legacyBlob = "1b8079448ecd5867564ddea24cbcc19393e2c991";
const sha256 = (bytes) => createHash("sha256").update(bytes).digest("hex");
const gitBlob = (bytes) => createHash("sha1").update(`blob ${Buffer.byteLength(bytes)}\0`).update(bytes).digest("hex");
const composed = (core, additions) => core.manifest.map((part) =>
  [core.sources[part], additions.get(part) || ""].filter(Boolean).join("\n")).filter(Boolean).join("\n");

function validReviewContract(path) {
  if (typeof path !== "string" || !/^spec\/[a-zA-Z0-9_/-]+_spec\.rb$/.test(path)) return false;
  try {
    const resolved = realpathSync(join(root, path));
    return resolved.startsWith(`${realpathSync(join(root, "spec"))}/`) && readFileSync(resolved, "utf8").trim().length > 0;
  } catch {
    return false;
  }
}

export function migrationAdditions(core, migrations, readFixture) {
  const additions = new Map();
  const notes = [];
  for (const migration of migrations) {
    if (!/^[a-f0-9]{40}$/.test(migration.source_head || "") ||
        !/^[a-f0-9]{40}$/.test(migration.source_git_blob || "")) throw new Error("Missing exact source provenance");
    if (migration.cross_concern_order === "requires-separate-review") throw new Error("Unreviewed cross-concern order: CI cannot approve this migration");
    if (!["preserved", "reviewed-native-disjoint"].includes(migration.cross_concern_order)) {
      throw new Error("Missing explicit cross-concern order disposition");
    }
    if (migration.cross_concern_order === "reviewed-native-disjoint" &&
        (typeof migration.order_review?.rationale !== "string" || !migration.order_review.rationale.trim() ||
         !validReviewContract(migration.order_review.contract_spec))) {
      throw new Error("Reviewed order exception requires rationale and an existing nonempty RSpec contract");
    }
    if (!Array.isArray(migration.concerns) || migration.concerns.length === 0) throw new Error("Empty migration manifest");
    const source = readFixture(migration.source_fixture);
    if (gitBlob(source) !== migration.source_git_blob) throw new Error("Original source fixture digest mismatch");
    const local = new Map();
    for (const concern of migration.concerns) {
      if (!core.manifest.includes(concern.part)) throw new Error(`Unknown concern: ${concern.part}`);
      if (additions.has(concern.part)) throw new Error(`Duplicate concern assignment: ${concern.part}`);
      const snippet = readFixture(concern.fixture);
      if (!/^[a-f0-9]{64}$/.test(concern.sha256 || "") || sha256(snippet) !== concern.sha256) {
        throw new Error(`Concern fixture digest mismatch: ${concern.part}`);
      }
      additions.set(concern.part, snippet);
      local.set(concern.part, snippet);
    }
    const orderedSnippets = core.manifest.map((part) => local.get(part) || "").join("\n");
    assertAdditionProvenance(composed(core, new Map()), source, orderedSnippets);
    if (migration.cross_concern_order === "preserved") compareSources(source, composed(core, local));
    else notes.push(`${migration.source_head}: native-disjoint exception uses ${migration.order_review.contract_spec}: ${migration.order_review.rationale}`);
  }
  return { additions, notes };
}

export function verify(composedPath) {
  const coreBytes = readFileSync(join(fixtures, "v3_core_concerns.json"));
  if (sha256(coreBytes) !== coreDigest) throw new Error("Pinned core concern fixture changed");
  const core = JSON.parse(coreBytes);
  const legacy = readFileSync(join(fixtures, "v3_pre_concerns.css"));
  if (gitBlob(legacy) !== legacyBlob) throw new Error("Immutable legacy fixture changed");
  compareSources(legacy.toString(), composed(core, new Map()));

  const directory = join(fixtures, "css_migrations");
  const readFixture = (name) => {
    if (typeof name !== "string" || !/^[a-z0-9][a-z0-9_.-]*\.css$/.test(name)) throw new Error("Unsafe fixture filename");
    const path = realpathSync(join(directory, name));
    if (dirname(path) !== realpathSync(directory)) throw new Error("Fixture escapes migration directory");
    return readFileSync(path, "utf8");
  };
  const migrations = readdirSync(directory).filter((name) => name.endsWith(".json")).sort()
    .map((name) => JSON.parse(readFileSync(join(directory, name), "utf8")));
  const { additions, notes } = migrationAdditions(core, migrations, readFixture);
  // Sheriff-authorized post-migration correction. Historical fixtures above remain immutable.
  // Keep the exact media/selector/value contract independent of production CSS.
  const preferenceCorrection = `@media (forced-colors: active) {
    body:has(:where(#main-menu)) > div:has(> [data-drawer-target="main-menu"]) button svg {
      color: ButtonText;
    }
  }`;
  additions.set("hardening/preferences", `${additions.get("hardening/preferences") || ""}\n${preferenceCorrection}`);
  for (const part of core.manifest) {
    const expected = [core.sources[part], additions.get(part) || ""].filter(Boolean).join("\n");
    const actual = readFileSync(join(root, `lib/active_admin/themes/recipes/v3/${part}.css`), "utf8");
    compareSources(expected, actual);
  }
  compareSources(composed(core, additions), readFileSync(composedPath, "utf8"));
  return notes;
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    if (process.argv.length !== 3) throw new Error("Usage: node scripts/verify_css_migrations.mjs COMPOSED.css");
    const notes = verify(process.argv[2]);
    for (const note of notes) console.log(`ORDER REVIEW: ${note}`);
    console.log("Pinned core, source provenance, per-concern preservation and new-manifest composition passed");
    console.log("This is not browser equivalence or blanket old cross-concern order approval");
  } catch (error) {
    console.error(error.message);
    process.exitCode = 1;
  }
}
