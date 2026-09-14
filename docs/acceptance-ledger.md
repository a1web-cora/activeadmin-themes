<!-- docs/acceptance-ledger.md -->

# V3 Acceptance Ledger

This reconciles [#13](https://github.com/scarver2/activeadmin-themes/issues/13),
not a declaration that [#8](https://github.com/scarver2/activeadmin-themes/issues/8)
or [#11](https://github.com/scarver2/activeadmin-themes/issues/11) is complete.
Source inspected: master `b87f37b2eac9b0d6e5cbbaf1cf767a6e054dd8ae`, September 14,
2026. [PR #25](https://github.com/scarver2/activeadmin-themes/pull/25) is merged
there; its reviewed source head was `5d73880a0bceda577a6f4578e960eaca93833e2e`.
Tests listed below exist at the inspected source; listing them does not claim a
fresh execution. A merge or unchanged CSS does not transfer browser acceptance.

## Acceptance Categories

| #13 requirement | Source or retained evidence | Disposition |
| --- | --- | --- |
| Registry, version metadata and unknown keys | `spec/active_admin/themes/{registry,version,theme}_spec.rb` | Implemented; require full-suite result on the final candidate |
| Side-effect-free gem loading | Explicit recipe boundary in `AGENTS.md` and [architecture](architecture.md) | Dedicated process-level no-filesystem/asset-side-effect regression was not located in the inspected specs; require proof or an explicit test before checking this requirement complete |
| Explicit list/install/status, repeat runs, modified-file refusal, safe destinations and version checks | `spec/active_admin/themes/{recipe,installation_plan,tasks}_spec.rb`; [installer contract](installer.md) | Implemented; no automatic runtime theming authorized |
| RSpec, coverage, lint, RBS, audit, build and contributor commands | `bin/ci`, `.simplecov`, `Guardfile`, `bin/setup`, `bin/test` | Implemented; report actual final-head counts, coverage and audit database separately |
| Built-gem installation and complete ordered concerns | `spec/package_spec.rb`, `spec/active_admin/themes/recipes/v3_spec.rb`, `spec/host_recipe_spec.rb`, CSS structure/migration specs | Implemented; package test executes extracted gem source outside checkout; does not establish rendering |
| Clean production-like build, assets and database-free boot | Root `Dockerfile`, `compose.yaml`, `bin/container-*`, `scripts/verify_host_assets.rb`; [clean-build contract](clean-build.md) | Satisfied elsewhere for PR #25 source head only; fresh candidate provenance required for any later run |
| Labels, entrypoints and native hooks in rendered requests | `spec/host_spec.rb`, `spec/forms_spec.rb`, `spec/filters_spec.rb`, `spec/feedback_host_spec.rb`, `spec/login_dashboard_spec.rb` | Request-level implementation exists; native semantic gaps need explicit disposition, not decorative CSS fixes |
| Executed login/navigation/filter/scope/sort/page/batch/validation/nested-form/dark/focus interactions | [Historical browser review](browser-review.md), [hardening protocol](hardening-matrix.md) | Still outstanding as a complete accepted-head browser record; request assertions do not execute JavaScript |
| Index/show/new/edit/dashboard/login plus error/empty/long-content visual baselines | [Reference inventory](visual-inventory.md), hardening protocol | Still outstanding: durable images, inspected observations, fixed fixture/clock state and full provenance |
| CSS/ESM response MIME, admin/public isolation and production asset bytes | PR #25 verifier and exact-head [review packet](https://github.com/scarver2/activeadmin-themes/pull/25#issuecomment-5671292014) | Satisfied elsewhere at `5d73880a0bceda577a6f4578e960eaca93833e2e` for request/artifact checks only; browser network/console/duplicate-initialization checks remain separate |
| Showcase with exact gem/AA/Rails/Tailwind versions and screenshot provenance | [Showcase tracker #29](https://github.com/scarver2/activeadmin-react-showcase/issues/29) | Still outstanding in this ledger; documentation completion is not a demonstration or verified deployment |
| Preserve failure diagnoses, exact heads and exclusions | Review packets, historical browser review, this ledger | Required for every new packet; never bulk-accept missing evidence or silently transfer old results |
| Rodeo adoption after Showcase | [Rodeo #235](https://github.com/a1web/rodeo/issues/235) | Not applicable to current implementation lane; separately reviewed and not authorized here |

PR #25's retained packet is historical evidence, not a newly rerun container test
for master. Its production verifier checks composer/input byte equality, theme
presence in compiled CSS, MIME, local importmap module delivery, public isolation
and database-free boot. It is not a pixel comparison, complete CSS-output equality
proof, JavaScript execution test or proof of every production route.

## Historical Design Contract

The canonical reference is [AA3.5.2 stylesheet source](https://github.com/activeadmin/activeadmin/tree/v3.5.2/app/assets/stylesheets/active_admin).
GitHub's annotated tag `9e9d2e40c992cc5b599ed6c94c89550ab058c8a2` resolves to
commit [`d604c9462d7df789c62c461bcb88da861fcb73eb`](https://github.com/activeadmin/activeadmin/tree/d604c9462d7df789c62c461bcb88da861fcb73eb/app/assets/stylesheets/active_admin)
(verified through the tag API September 14, 2026). Issue #13's original 3.5.0
source-register entry is historical, not the currently approved design target.
Historical measurements must be rechecked against 3.5.2; changing a version label
alone does not validate existing numeric claims.

AA4 retains DOM/runtime authority. The inspected host locks AA4.0.0.beta22,
Rails8.1.3.1 and Tailwind4.3.3. Each parity PR must record exact upstream source
files, actual AA4 hooks, before/after images, light/dark and viewport observations,
and deviations as **historical reference → AA4 constraint → V3 adaptation**.
No pixel-perfect historical reproduction, WCAG conformance, physical-device or
multi-browser claim follows from source inspection or token contrast tests.

## Remaining Final Gate

- Run the final integrated source and retain full SHA, commands, results, image
  ID/revision/platform, artifact hashes and source/lock provenance.
- Complete and inspect the route/state matrix at 390/768/1024/1440 CSS pixels in
  both palettes; identify browser/version, OS, zoom, fixture state and image path.
- Record genuine 200% browser zoom, keyboard/focus, interactions, preference
  probes, computed contrast and console/network checks. Unsupported observations
  remain untested, with owner/disposition; they are not passes.
- Record the required multi-browser/physical-device scope and its reviewed
  disposition explicitly; this ledger neither invents a matrix nor waives one.
- Obtain AA3.5.2 visual-reference and Showcase dispositions with durable evidence.
- Send the final exact-head packet for SHA-guarded review before deciding issue
  closure. Keep #8/#11/#13 open until their respective requirements are accepted.

No release, publication, deployment or Rodeo adoption is authorized by this
ledger. Host business policy, authorization, tenant behavior and private data stay
outside the recipe; `activeadmin-react` remains an independent optional library.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
