<!-- docs/tables.md -->

# V3 Tables, Scopes, And Pagination

Issue [#4](https://github.com/scarver2/activeadmin-themes/issues/4) adds compact
index presentation to the explicitly installed recipe. Loading the gem still
does not load CSS or alter ActiveAdmin behavior.

Rows use smaller padding, alternating surfaces, hover feedback and checked-row
highlighting. ID and quantity columns use end-aligned tabular numerals; a host
can apply the `numeric` class to additional numeric columns. Text can wrap and
the native index scroll container retains horizontal overflow. No columns are
hidden. Scope selection and the current page gain weight and an inset underline
as well as color. Batch-action controls keep native hooks and disabled behavior.

The pinned AA4 beta22 paginator exposes its selected page as `bg-blue-500`, not
`aria-current`. This compatibility selector is intentionally limited to the
paginator and covered by a rendered-host contract test. CSS cannot supply the
missing semantic current-page state or accessible checkbox names; those remain
acceptance concerns, not claims that this recipe repairs upstream markup.

## Verification

Run `bin/build-host` and `bin/ci`. Request-level tests cover numeric sorting,
selection inputs, selected scope/page hooks, pagination counts, and empty
results. They do not execute native JavaScript or prove visual layout.

Browser acceptance remains required: selected and hovered rows; batch menu and
selection behavior; keyboard focus; long content and horizontal scroll; numeric
alignment; dark mode; scope/page navigation. Cross-surface viewport, zoom and
assistive-technology hardening belong to #8 and #11. No complete visual or
accessibility certification is asserted by these request-level tests.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
