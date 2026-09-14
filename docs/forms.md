<!-- docs/forms.md -->

# V3 Forms

The opt-in recipe styles ActiveAdmin 4's native Formtastic output: fieldset hierarchy,
compact spacing, labels and required markers, text/select/date/file controls,
checkboxes, textareas, hints, textual validation errors, disabled fields, nested
has-many sections, and actions. It does not replace form builders or JavaScript.
Selectors are limited to `.formtastic` on native admin pages; filters and custom
login pages are deliberately outside this slice.

The synthetic host's new/edit Product forms provide the representative controls.
Fixture ID is intentionally disabled and not permitted for submission. Sample file
is a presentation probe only, not upload storage. Nested notes use ActiveAdmin's
existing submission and dynamic-add behavior.

`bin/build-host` compiles the recipe against the locked framework. `bin/ci` includes
control/label/required-marker/disabled-state checks, invalid submission with textual
errors and retained values, and successful record/nested-note update. These request
tests do not execute JavaScript or establish browser visual/accessibility acceptance.
Dynamic add/remove, keyboard focus, zoom, narrow layouts, dark mode, and screenshot
provenance remain part of [#8](https://github.com/scarver2/activeadmin-themes/issues/8)
and [#11](https://github.com/scarver2/activeadmin-themes/issues/11).
CSS does not create missing accessible error associations or native semantics.

## Concern Migration

The existing Formtastic declarations from PR #21 head
`c403cd9e8299256e98ff21d1e68eaa057eb023f6` now live in
`lib/active_admin/themes/recipes/v3/components/forms.css`; no declarations,
selectors, specificity, or behavior were refined during this move.

The fixed manifest places tables before forms, while that original head placed
forms before tables. Deputy reviewed this exception against the native AA4 host
contract: index tables are outside `.formtastic`, and new/edit forms contain no
`.data-table`. Request specs preserve those boundaries. This is not a claim that
arbitrary custom DOM nesting commutes, nor a reason to relax the generic
cascade-order comparator. The original full source and extracted form bytes are
pinned under `spec/fixtures/css_migrations/pr21.*`; metadata records the limited
review rationale separately from generic cross-concern equivalence.

Related: [#7](https://github.com/scarver2/activeadmin-themes/issues/7),
[synthetic host](test-host.md), [Rodeo adoption](https://github.com/a1web/rodeo/issues/235).

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
