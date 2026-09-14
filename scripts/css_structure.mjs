// scripts/css_structure.mjs
import { readFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

import postcss from "postcss";

// Deliberately bounded, test-only vocabulary. Unknown syntax/properties require
// review, not optimistic equivalence. Families overapproximate property overlap.
const families = new Map();
function family(name, properties) {
  for (const property of properties.split(" ")) families.set(property, name);
}
family("background", "background background-color background-image background-position background-size background-repeat background-origin background-clip background-attachment");
family("border", "border border-color border-width border-style border-radius border-image border-image-source border-image-slice border-image-width border-image-outset border-image-repeat");
for (const side of ["top", "right", "bottom", "left", "block", "inline", "block-start", "block-end", "inline-start", "inline-end"]) {
  family("border", [`border-${side}`, ...["color", "width", "style"].map((part) => `border-${side}-${part}`)].join(" "));
}
family("border", "border-top-left-radius border-top-right-radius border-bottom-left-radius border-bottom-right-radius border-start-start-radius border-start-end-radius border-end-start-radius border-end-end-radius");
for (const name of ["margin", "padding"]) {
  family(name, [name, ...["top", "right", "bottom", "left", "block", "inline", "block-start", "block-end", "inline-start", "inline-end"].map((side) => `${name}-${side}`)].join(" "));
}
family("inset", "inset top right bottom left inset-block inset-inline inset-block-start inset-block-end inset-inline-start inset-inline-end");
family("font", "font font-family font-size font-style font-weight font-stretch font-variant font-variant-numeric font-variant-caps font-variant-ligatures font-variant-east-asian font-variant-position font-kerning font-feature-settings font-variation-settings font-size-adjust line-height");
family("dimensions", "width height min-width min-height max-width max-height inline-size block-size min-inline-size min-block-size max-inline-size max-block-size");
family("overflow", "overflow overflow-x overflow-y overflow-block overflow-inline");
family("flex", "flex flex-grow flex-shrink flex-basis flex-flow flex-direction flex-wrap");
family("gap", "gap row-gap column-gap");
family("grid", "grid grid-template grid-template-columns grid-template-rows grid-template-areas grid-auto-columns grid-auto-rows grid-auto-flow grid-row grid-row-start grid-row-end grid-column grid-column-start grid-column-end grid-area");
family("alignment", "place-items align-items justify-items place-content align-content justify-content place-self align-self justify-self");
family("outline", "outline outline-color outline-width outline-style outline-offset");
family("decoration", "text-decoration text-decoration-color text-decoration-line text-decoration-style text-decoration-thickness text-underline-offset");
family("animation", "animation animation-name animation-duration animation-delay animation-timing-function animation-iteration-count animation-direction animation-fill-mode animation-play-state animation-timeline animation-range animation-range-start animation-range-end");
family("transition", "transition transition-property transition-duration transition-delay transition-timing-function transition-behavior");
for (const property of "all accent-color appearance box-shadow box-sizing color color-scheme content cursor direction display isolation opacity overflow-wrap position resize scroll-behavior text-align text-transform unicode-bidi vertical-align visibility white-space word-break z-index".split(" ")) {
  family(property, property);
}

function cascadeFamily(property) {
  if (/^--[\w-]+$/.test(property)) return `custom:${property}`;
  if (!families.has(property)) throw new Error(`Unsupported property: ${property}`);
  return families.get(property);
}

function inspect(source) {
  const root = postcss.parse(source);
  const records = [];
  const empty = [];
  function walk(node, context) {
    if (node.type === "comment") return;
    if (node.type === "decl") {
      if (!context.some(([type]) => type === "rule")) throw new Error("Declaration outside a rule");
      if (/\S/.test(node.raws.before || "")) throw new Error("Unsupported declaration prefix/hack");
      cascadeFamily(node.prop);
      records.push({ context, prop: node.prop, value: node.value, important: Boolean(node.important) });
      return;
    }
    let path = context;
    if (node.type === "rule") path = [...context, ["rule", node.selector]];
    else if (node.type === "atrule") {
      if (!["media", "supports", "container"].includes(node.name) || !node.nodes) {
        throw new Error(`Unsupported at-rule: @${node.name}`);
      }
      path = [...context, ["at", node.name, node.params]];
    } else if (node.type !== "root") throw new Error(`Unsupported node: ${node.type}`);
    const before = records.length;
    for (const child of node.nodes) walk(child, path);
    if (node.type !== "root" && records.length === before) empty.push(path);
  }
  walk(root, []);
  return { records, empty };
}

function grouped(records, key) {
  const result = new Map();
  for (const record of records) {
    const group = key(record);
    if (!result.has(group)) result.set(group, []);
    result.get(group).push(record);
  }
  return result;
}

function assertGroups(before, after, label) {
  if (before.size !== after.size) throw new Error(`${label}: group count changed`);
  for (const [key, records] of before) {
    if (JSON.stringify(records) !== JSON.stringify(after.get(key))) {
      throw new Error(`${label}: declaration sequence changed for ${key}`);
    }
  }
}

function overlapping(records) {
  const names = new Set(records.map(({ prop }) => cascadeFamily(prop)));
  const result = new Map();
  for (const name of names) {
    result.set(name, records.filter(({ prop }) => cascadeFamily(prop) === name ||
      (prop === "all" && !name.startsWith("custom:") && !["direction", "unicode-bidi"].includes(name))));
  }
  return result;
}

// A conservative migration contract, not a theorem about rendering: selector
// ancestry and at-rule text are exact; duplicates/order are never sorted away.
export function compareSources(before, after) {
  const oldTree = inspect(before);
  const newTree = inspect(after);
  if (JSON.stringify(oldTree.empty) !== JSON.stringify(newTree.empty)) throw new Error("Empty structure changed");
  assertGroups(grouped(oldTree.records, ({ context }) => JSON.stringify(context)),
    grouped(newTree.records, ({ context }) => JSON.stringify(context)), "Selector/at-rule context");
  assertGroups(grouped(oldTree.records, ({ prop }) => prop), grouped(newTree.records, ({ prop }) => prop), "Global property cascade");
  assertGroups(overlapping(oldTree.records), overlapping(newTree.records), "Overlapping property cascade");
}

export function compare(oldPath, newPath) {
  compareSources(readFileSync(oldPath, "utf8"), readFileSync(newPath, "utf8"));
}

// Provenance membership only: exact contexts/declarations and multiplicity, NOT
// ordering. Keep separate from compareSources; callers must disclose/order-review
// any old cross-concern movement rather than treating this as cascade equivalence.
export function assertAdditionProvenance(core, original, additions) {
  function inventory(source) {
    const { records, empty } = inspect(source);
    const counts = new Map();
    for (const item of [...records.map((record) => ["decl", record]), ...empty.map((path) => ["empty", path])]) {
      const key = JSON.stringify(item);
      counts.set(key, (counts.get(key) || 0) + 1);
    }
    return counts;
  }
  const expected = inventory(`${core}\n${additions}`);
  const observed = inventory(original);
  if (expected.size !== observed.size || [...expected].some(([key, count]) => observed.get(key) !== count)) {
    throw new Error("Migration snippets are not exactly the original source additions to the pinned core");
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  if (process.argv.length !== 4) {
    console.error("Usage: node scripts/css_structure.mjs OLD.css NEW.css");
    process.exitCode = 2;
  } else {
    try {
      compare(process.argv[2], process.argv[3]);
      console.log("CSS structural/cascade migration contract passed (not browser equivalence)");
    } catch (error) {
      console.error(error.message);
      process.exitCode = 1;
    }
  }
}
