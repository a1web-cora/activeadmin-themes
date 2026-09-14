<!-- docs/filters.md -->

# V3 Filters

The [filter slice (#3)](https://github.com/scarver2/activeadmin-themes/issues/3)
styles ActiveAdmin's existing filter form and applied-search summary. It uses
the V3 surface, text, border, focus, and spacing tokens in light and dark modes.
Apply is a filled primary action; Clear Filters remains an underlined native
link. Applied predicates have a leading rule and emphasized values, rather than
being distinguished by color alone. Operator/value and date-range pairs use
shrinkable columns and stack below 48rem; long applied values wrap.

The application must explicitly install/import the recipe. These selectors are
scoped to the native admin shell (`body:has(#main-menu)`); loading the gem adds
no CSS, Ruby behavior, JavaScript, or host mutation. Filter names, labels,
predicate switching, query submission, reset behavior, scopes, and pagination
remain ActiveAdmin/Ransack responsibilities. This slice does not replace them.

## Verification And Remaining Gates

The architecture-only migration places this slice, including its filter-specific
media rule, in `lib/active_admin/themes/recipes/v3/components/filters.css` without
changing the composer manifest. Migration fixtures pin the original PR head
`1f85dc9629c660ababd1a62ca8e9c7f7e2885c48` and full CSS Git blob. The strict
structural/cascade comparison checks the old complete source against the new
core-plus-filter composition; the immutable pre-concern core fixture is unchanged.
This is source-preservation evidence, not new visual acceptance.

`bin/build-host` compiles the recipe with the locked AA4/Tailwind host.
`bin/ci` runs request-level filter checks alongside the full library suite:
combined string/select submission, applied values, numeric predicates, date
bounds, an empty search and clear/reset, and filtered pagination. Existing
palette tests cover the token pairs used here, including the inverse link/surface
button pair. Request checks do not execute native predicate-switching JavaScript
or prove visual layout.

Browser verification with the table surface, keyboard interaction, zoom, touch
targets, long values, dark mode, and 390/768/1024/1440 viewport screenshots remains
part of [#8](https://github.com/scarver2/activeadmin-themes/issues/8) and
[#11](https://github.com/scarver2/activeadmin-themes/issues/11). In the pinned
ActiveAdmin 4.0.0.beta22 host, operator selects have no accessible name and date
range labels are not associated with each bound. CSS cannot repair those
semantics; this slice neither conceals the gap nor injects a behavior patch.

The host is a synthetic integration fixture, not example Rails application
architecture. See [test host](test-host.md) for launch and safety boundaries.
Adoption remains tracked in [Rodeo #235](https://github.com/a1web/rodeo/issues/235).

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
