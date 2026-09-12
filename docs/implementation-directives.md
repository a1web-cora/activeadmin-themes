<!-- docs/implementation-directives.md -->

# V3 implementation directives

[Issue #13](https://github.com/scarver2/activeadmin-themes/issues/13) is the source register and detailed acceptance contract. The runtime target is ActiveAdmin 4 with Tailwind CSS 4. Tagged ActiveAdmin 3.5 supplies the visual reference. Record versions, URLs, viewports and states with every comparison; no historical screenshot or visual parity is implied by the registry foundation.

## Delivery sequence

Implement the explicit installer (#2) and synthetic test host (#11) before broad visual work. Establish measured tokens (#1), then chrome (#5), tables/scopes/pagination (#4), filters (#3), forms (#7), panels/status/flash (#6), login/dashboard (#9), and responsive/dark refinements (#8). Prove integration in the [Showcase](https://github.com/scarver2/activeadmin-react-showcase) before separately reviewed Rodeo adoption.

## Installation and assets

Validate the actual host version and stylesheet entrypoint, use its existing compiler, and report every application-owned path. Repeat installation must be predictable; modified files and unsafe destinations must stop installation. Resolve framework sources through Bundler and preserve native DOM hooks and JavaScript entrypoints.

Diagnose missing styles through generated output, resolver, release image, HTTP MIME type and computed styles. AA4 uses Tailwind compilation; Propshaft delivers compiled assets. Build locked dependencies and CSS in a clean release image before Rails asset precompilation. Verify admin/public CSS isolation and exactly one canonical JavaScript entrypoint.

## Evidence gates

Keep package, asset, request, browser and deployment results distinct. Test installation from the built gem, not only the checkout. Request coverage checks labels, asset references and DOM hooks; browser coverage checks executed interactions, console errors and served CSS/ESM. Include long labels, empty/error states, wide tables and realistic synthetic records. Use deliberate table scrolling rather than clipping overflow.

Capture index/show/new/edit/dashboard/login at proposed widths 1440, 1024, 768 and 390 CSS pixels, with deterministic fixtures and clocks. Inspect keyboard use, zoom, reduced motion, forced colors, focus, accessible names and dark mode. WCAG 2.2 AA is the acceptance target; screenshots alone do not establish conformance. Preserve failure diagnoses and exact tested heads.

Themes own presentation. Authorization, tenant policy, persistence and business workflows stay in the host. No private Rodeo data or deployment details belong in public fixtures.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
