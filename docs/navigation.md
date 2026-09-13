<!-- docs/navigation.md -->

# V3 Navigation And Page Chrome

This slice styles existing AA4 markup without replacing its drawer, user-menu,
dark-mode or logout behavior. It changes the site header, selected menu item,
page title/breadcrumb hierarchy, action buttons and responsive page gutter.
It adds no JavaScript, initializer, route or host business behavior.

Selectors target the AA4 beta22 `#main-menu`, `#user-menu`, drawer control and
page-header/content attributes. These are version-sensitive integration hooks;
inspect them when upgrading ActiveAdmin. The `:where` wrapper deliberately
keeps scope specificity low. The selected section has weight and a border in
addition to color. Focus in the dark site header uses a contrasting gold ring.

## Verification

Local preview combined navigation CSS commit `c46f1bc65f93c20bfab164c8edc630a622a70b4d`
with host PR #17 at `e98ffff6a35009b1c856926f537ac05bbd2272c3`.
AA4.0.0.beta22, Rails8.1.3.1, Tailwind4.3.3, loopback synthetic data.

- CSS compiled through the host's locked pipeline and Propshaft precompile.
- In-app browser: authenticated dashboard inspected at 1280px and 390px.
- At 390px, native drawer opens; Escape dismisses it.
- Native dark toggle changes the chrome palette.
- Native user menu exposes Synthetic Operator and Sign out; clicking Sign out
  executes method-aware logout and returns to the login page.
- Screenshots inspected in the development conversation, not committed as
  approved visual baselines. Full keyboard/zoom/viewport matrix remains in #11.

Panels, tables, filters, forms and dashboard composition are separate slices;
their native baseline appearance in these screenshots is not acceptance of
those theme surfaces. This change does not establish complete WCAG conformance.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
