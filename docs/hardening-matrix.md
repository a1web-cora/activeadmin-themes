<!-- docs/hardening-matrix.md -->

# V3 Cross-Surface Hardening Matrix

This is the runnable review protocol for [#8](https://github.com/scarver2/activeadmin-themes/issues/8),
not completed evidence. Execute it on the integrated component heads after
tables, filters, forms, panels/feedback, and login/dashboard exist. Keep fixes
traceable to an observed case; do not use this gate for unrelated surface work.
[#11](https://github.com/scarver2/activeadmin-themes/issues/11) owns the final
artifact/provenance inventory and clean-container release-style proof.

The initial integration candidate is based on `64381bf90c9b549c71a38c153bf1e4b3dfca48f4`:
#20 `c202e1d`, #22 `99a8a0b`, #21 `053a6bf`, #19 `b17fc5e`, and #23 `5da1a43`.
It adds coarse-pointer action sizing, reduced-motion timing, and explicit
forced-colors selection/focus boundaries without replacing native interactions.
Expanded palette tests cover text/link on subtle/selected surfaces and focus
against page/surface/selection backgrounds. These static/build checks do not
replace the matrix. Checkbox/radio hit areas, semantic names and actual browser
preference handling still require observation and a recorded disposition.

Initial integrated local checks: `bin/build-host` passes; `bin/ci` passes with 107 examples,
100% library line/branch coverage, 48 lint-clean files, RBS validation, dependency
audit, and gem build. No matrix case is marked passed by those results.
The focused master-based draft independently passes 84 examples and 42 lint-clean
files with the same coverage, build, validation and audit gates. Its component
selectors do not establish acceptance before those component PRs are integrated.

## Prepare The Exact Candidate

1. Record the full integration SHA, each component PR/head, clean worktree
   status, locked framework/tool versions, browser version, and operating system.
   Rebuild and repeat affected cases after any source change; earlier images do
   not establish acceptance of a later SHA.
2. Run `bin/setup`, `mise exec -- npm ci`, `bin/build-host`, `bin/ci`, and
   `bin/host-assets`. Record exit codes and full test results. A precompiled
   manifest can otherwise keep serving stale CSS after a stylesheet edit.
3. Start a fresh `PORT=4319 bin/host` process. Use loopback only; this synthetic
   fixture uses public local-only credentials and is not a deployable Rails app.
4. Open `http://127.0.0.1:4319/login` and authenticate with `demo`. Record viewport
   in CSS pixels and browser zoom separately. Start at 100% zoom. Use the native
   theme toggle for both palettes and record actual theme state after navigation.
   Do not inject classes to simulate framework behavior.

## Route And State Inventory

Run every row at **390, 768, 1024, and 1440 CSS pixels**, in both **light and dark**
mode. Use a consistent viewport height, record it, and capture full pages plus
focused open-menu/validation details where relevant. These are 72 base cases;
login-error and interaction states add evidence, not replacements for rows.

| Case | Route / reproducible action | Required observation |
| --- | --- | --- |
| Index | `/admin/products` | Density, numeric alignment, sort state, local table overflow; scopes, batch actions and pagination remain reachable |
| Show | `/admin/products/45` | Attribute labels/values remain readable; action controls and status tags retain hierarchy |
| New | `/admin/products/new` | Labels, required markers, help, select/date/checkbox/file controls; no clipped field or focus ring |
| Edit | `/admin/products/45/edit` | Existing values, textarea, nested notes and action controls remain readable |
| Dashboard | `/admin` | Panels compose without page overflow; long identifier wraps; no dashboard-only token drift |
| Login | Native Sign out, then `/login` | Opt-in theme, readable form, keyboard submit; also record rejected password state |
| Validation | New form: clear Name, set Quantity to `-1`, submit | Summary/inline errors visible and distinguishable without color alone; entered values retained |
| Empty | `/admin/products?q[name_eq]=no-synthetic-match` | Empty message, applied query and Clear Filters remain visible; reset restores records |
| Long content | `/admin/products/45` and `/admin` | Existing synthetic description/identifier wraps; long applied filter values do not force page overflow |

## Interaction Pass

Perform at least once in each palette at 390 and 1440, then repeat any
breakpoint-specific failure at 768 and 1024. Use actual keyboard/pointer input.

- **Navigation:** Tab/Shift+Tab through header, drawer, user menu, breadcrumbs and
  actions. Open the narrow drawer, activate a destination, reopen and Escape.
  Confirm visible focus, operable dismissal and no obscured target. Verify logout
  reaches the login page through its native method-aware link.
- **Index:** Sort a column, select/clear a row and use Select All. Inspect batch
  menu without deleting records. Follow Ready scope and page 2. Confirm selected
  state is distinguishable without color alone, filters survive pagination, and
  horizontal scrolling is confined to the table rather than the whole document.
- **Filters:** Change Name operator to Equals using the native control, enter
  `Synthetic Product 01`, apply, and confirm one result plus accurate applied
  text. Clear. Apply Status `ready`, Quantity Greater than `290`, and both date
  bounds `2026-01-15`; confirm two results. Clear again. Record accessible names
  separately from successful pointer operation; native unlabeled operator/date
  controls are known gaps, not CSS passes.
- **Forms:** Enter invalid values, correct them, add a nested note, remove an
  unsaved nested note, and save a synthetic edit. Inspect disabled/required and
  file-input presentation where the fixture actually exposes them. Do not claim
  upload persistence: this fixture intentionally does not store files.
- **Zoom:** Repeat index, new form and dashboard at 200% browser zoom in a 1440px
  window. Record the resulting CSS viewport. Check reading order, local table
  scroll, focus visibility and no clipped action. Do not substitute an image
  scaled to 200% for browser zoom.
- **Touch:** At a real/emulated coarse pointer, measure action hit areas against
  a 44px target goal, including clear, pagination, menu and form actions. Report
  unsupported emulation as untested, not passed.
- **Reduced motion / forced colors:** Use genuine OS/browser preferences where
  available. Confirm no unnecessary animation and that selected/focus/status
  boundaries remain perceivable. Record unavailable preferences as gaps.

## Acceptance Record

For each case record `pending`, `pass`, `fail`, or `not tested`, with full SHA,
route, palette, viewport, zoom, browser, screenshot path, and concise observation.
Keep screenshot files and machine-readable provenance together under the #11
evidence inventory; conversation-only images are not durable baselines.

Record CSS URL/hash and successful `text/css` response, JavaScript/module
responses, console errors, and the public `/` page with no admin stylesheet.
Automated token contrast tests support the palette, but do not prove rendered
text/background contrast for every surface. Sample actual computed foreground
and background pairs for errors, selected rows, buttons and dark states.

Do not close #8 with unresolved representative layout/contrast failures or
missing durable evidence. Do not close #11/#13 on the strength of this protocol;
their package, isolation, clean-container and release-style gates remain separate.
Known framework accessibility gaps must retain an explicit owner and disposition.

Adoption tracker: [Rodeo #235](https://github.com/a1web/rodeo/issues/235).

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
