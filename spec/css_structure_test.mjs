// spec/css_structure_test.mjs
import assert from "node:assert/strict";
import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
import test from "node:test";

import { compareSources } from "../scripts/css_structure.mjs";

const original = readFileSync(new URL("./fixtures/v3_pre_concerns.css", import.meta.url));
test("accepted fixture is exactly Git blob 1b8079448ecd5867564ddea24cbcc19393e2c991", () => {
  const hash = createHash("sha1").update(`blob ${original.length}\0`).update(original).digest("hex");
  assert.equal(hash, "1b8079448ecd5867564ddea24cbcc19393e2c991");
  compareSources(original.toString(), original.toString());
});

test("allows the approved token/body split and disjoint responsive gutter move", () => {
  compareSources(
    "body { --x: red; color: var(--x); } .dark { --x: blue; color-scheme: dark; } @media (max-width:48rem) {body {--gutter: 1rem;}} .table { padding: 1rem; }",
    "body { --x: red; } .dark { --x: blue; } body { color: var(--x); } .dark { color-scheme: dark; } .table { padding: 1rem; } @media (max-width:48rem) {body {--gutter: 1rem;}}"
  );
});

test("ignores comments and outer formatting only", () => {
  compareSources("a { color: red; }", "/* part */\na {\n  color: red;\n}");
});

const adversaries = [
  ["omitted declaration", "a { color:red; color:blue; }", "a { color:red; }"],
  ["duplicate declaration", "a { color:red; }", "a { color:red; color:red; }"],
  ["changed value", "a { color:red; }", "a { color:blue; }"],
  ["changed importance", "a { color:red!important; }", "a { color:red; }"],
  ["changed property", "a { color:red; }", "a { background:red; }"],
  ["selector changed", "a { color:red; }", "b { color:red; }"],
  ["selector list sorted", "b, a { color:red; }", "a, b { color:red; }"],
  ["at-rule context changed", "@media (width:1px) {a {color:red;}}", "@media (width:2px) {a {color:red;}}"],
  ["nested selector ancestry changed", "a { & b {color:red;} }", "b { & a {color:red;} }"],
  ["duplicate declarations reordered", "a {color:red;color:blue;}", "a {color:blue;color:red;}"],
  ["within-context declaration order changed", "a {color:red;padding:1rem;}", "a {padding:1rem;color:red;}"],
  ["competing selectors reordered", "a {color:red;} .x {color:blue;}", ".x {color:blue;} a {color:red;}"],
  ["different media contexts reordered", "@media (width:1px) {a {color:red;}} @media (height:1px) {a {color:blue;}}", "@media (height:1px) {a {color:blue;}} @media (width:1px) {a {color:red;}}"],
  ["shorthand within rule reordered", "a {background:red;background-color:blue;}", "a {background-color:blue;background:red;}"],
  ["shorthand across selectors reordered", "a {background:red;} .x {background-color:blue;}", ".x {background-color:blue;} a {background:red;}"],
  ["logical/physical shorthand reordered", "a {margin:1rem;} .x {margin-inline:2rem;}", ".x {margin-inline:2rem;} a {margin:1rem;}"],
  ["logical/physical longhand reordered", "a {padding-left:1rem;} .x {padding-inline-start:2rem;}", ".x {padding-inline-start:2rem;} a {padding-left:1rem;}"],
  ["font resets line-height", "a {font:12px serif;} .x {line-height:2;}", ".x {line-height:2;} a {font:12px serif;}"],
  ["all resets a different property", "a {all:initial;} .x {color:red;}", ".x {color:red;} a {all:initial;}"],
  ["important shorthand reordered", "a {border:0!important;} .x {border-color:red!important;}", ".x {border-color:red!important;} a {border:0!important;}"],
  ["empty selector omitted", "a {} b {color:red;}", "b {color:red;}"],
  ["unsupported at-rule", "@layer one {a {color:red;}}", "@layer one {a {color:red;}}"],
  ["unsupported property", "a {made-up:1;}", "a {made-up:1;}"],
  ["parser hides a star hack", "a {*color:red;}", "a {color:red;}"],
  ["standalone at-rule", "@import 'other.css';", "@import 'other.css';"],
  ["declaration outside a rule", "color:red;", "color:red;"],
  ["malformed CSS", "a {color:red;}", "a {color:red;"],
];
for (const [name, before, after] of adversaries) {
  test(`rejects ${name}`, () => assert.throws(() => compareSources(before, after)));
}
