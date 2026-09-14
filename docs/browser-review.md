<!-- docs/browser-review.md -->

# Combined Browser Review

Partial evidence, not completed visual or accessibility acceptance.

## Provenance

- Local combined source: `94dee5396700b4af42cb7c2db90c99893aa963e9`.
- Includes component PRs #19–#23, the corrected forms head `0504144`, and the
  integrated hardening candidate `e92691a`. Independent PR #24 has the same
  hardening code with additional draft/provenance documentation.
- Local macOS synthetic host, `bin/build-host`, then `PORT=4321 bin/host`.
- Codex in-app browser, September 12, 2026 (America/Chicago). Engine/version
  and OS-preference emulation were not recorded; no cross-browser claim.
- Only deterministic process-local fixture records; no production data.

## Observations

At viewport widths 390, 768, 1024 and 1440 (height 900), the following eight
routes were loaded in both native light and dark states: dashboard, index,
product 1 show, new, product 1 edit, feedback, empty filtered index, and login.
All 64 measurements had document scroll width equal to viewport width. This
proves absence of document-wide horizontal overflow in those states, not that
all content is visible or accessible. The narrow table uses local scrolling.

Native interactions exercised on the combined component host:

- Selecting product 45 enables Batch Actions and applies the selected-row color.
- Name filter submission yields Product 01 and the applied-filter summary.
- Has-many insertion adds a Body field; native Remove removes it.
- Blank product submission displays the server validation message.
- Invalid login retains the login form and explains the synthetic password.
- The narrow navigation drawer opens and Escape dismisses it.
- Dark-mode toggle persists across page navigation.

After the forms cascade correction, computed styles show enabled/disabled
fields using distinct surface/subtle backgrounds and text/muted foregrounds in
both palettes. Validation borders use the danger token in both palettes.
The public route has no stylesheet links, admin menu, or theme opt-in marker.
The browser's captured warning/error log was empty at the interaction check;
the development server separately logged an incidental favicon 404.

Combined `bin/ci` passed 107 examples with 100% library line/branch coverage,
48 lint-clean Ruby files, RBS validation, refreshed dependency audit, and gem build.

## Still Required

Selected screenshots were inspected during the session but were not archived as
a durable, complete matrix. Do not treat this report as screenshot evidence.
Complete the hardening matrix proposed in [PR #24](https://github.com/scarver2/activeadmin-themes/pull/24):
durable images with exact provenance, broader keyboard/focus checks, 200% zoom,
coarse-pointer/touch, reduced-motion and forced-colors observations, asset/MIME
evidence and final clean-container verification on the accepted combined source.
Native upstream semantic gaps remain explicitly separate from presentation fixes.

[#8](https://github.com/scarver2/activeadmin-themes/issues/8),
[#11](https://github.com/scarver2/activeadmin-themes/issues/11) and
[#13](https://github.com/scarver2/activeadmin-themes/issues/13) remain open.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
