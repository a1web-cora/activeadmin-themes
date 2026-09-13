<!-- docs/recipe-architecture.md -->

# V3 Recipe Architecture

V3 is maintained as ordered CSS concerns inside the gem and explicitly installed as one application-owned stylesheet. Loading the gem does not install assets or restyle a host.

## Source Ownership and Cascade Order

`ActiveAdmin::Themes::Recipes::V3::PARTS` lists the full paths below in cascade order. Never replace it with glob or alphabetical discovery. Empty files are stable slots for independently developed surfaces.

| Concern under `lib/active_admin/themes/recipes/v3/` | Ownership |
| --- | --- |
| `foundation/tokens.css` | Semantic custom properties, including light/dark tokens |
| `foundation/base.css` | Opt-in shell, body defaults, generic links and focus |
| `components/navigation.css` | Header, drawer, menus, breadcrumbs and page chrome |
| `components/tables.css` | Tables, scopes, pagination, batch actions, blank states and selection |
| `components/filters.css` | Filter controls, predicates, applied state and actions |
| `components/forms.css` | Formtastic controls, validation presentation and nested forms |
| `components/panels.css` | Panels, attributes tables and reusable content framing |
| `components/feedback.css` | Flashes, status tags and error summaries |
| `surfaces/login.css` | Login-only composition |
| `surfaces/dashboard.css` | Dashboard-only composition |
| `hardening/responsive.css` | Breakpoints, overflow and layout-related pointer sizing |
| `hardening/preferences.css` | Reduced motion, forced colors and other user preferences |

## One Composer, One Host-Owned Recipe

`Recipes::V3.source` reads nonempty files in manifest order and joins them deterministically. The installer writes these bytes to `active_admin_v3.css` beside the explicitly selected Tailwind entrypoint. It does not add imports or replace modified files.

`bin/build-host` calls the same composer, writes its bytes to ignored `tmp/active_admin_v3.css`, and imports that file into the synthetic host's Tailwind build. The compiled host CSS also contains framework styles; the intermediate recipe source, not the entire compiled bundle, must equal the installed recipe byte for byte. There is no second host composer or direct monolithic recipe import.

Historical installations may report `modified` because the structural refactor changes formatting bytes. This is intentional protection: review the application-owned file and migrate manually; never weaken conflict detection or overwrite local changes automatically.

## Architecture Migration Regression Gate

The accepted pre-refactor recipe is pinned to master `2ce5e5ced17134ce9dc3ba967e7317ec1e630e60`, Git blob `1b8079448ecd5867564ddea24cbcc19393e2c991`. Migration tests compare CSS rule/declaration structure rather than historical formatting bytes. Selectors, declaration values, duplicates, relevant declaration order, and competing cascade order remain protected. Repeated composition, packaged installation, empty slots and host source equality have separate tests.

The hierarchy splits custom properties from body declarations and moves the existing narrow gutter media rule to responsive hardening. These are structural changes only: no declaration values or selector behavior change. Any actual cascade defect requires a separate reviewed behavior correction, not a silent migration fix.

This frozen baseline is the architecture migration acceptance gate. Later intentionally reviewed component additions must update the accepted regression baseline deliberately, with provenance, rather than disabling the comparison or treating the historical stylesheet as an eternal feature freeze. Keep subsequent changes in their owning concerns and retain deterministic composition and installer/host equality checks.

Browser evidence belongs to its exact source head. This architecture refactor does not complete integrated responsive, visual, release or adoption acceptance.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
