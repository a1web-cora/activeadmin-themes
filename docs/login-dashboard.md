<!-- docs/login-dashboard.md -->

# V3 Login And Dashboard Composition

Issue [#9](https://github.com/scarver2/activeadmin-themes/issues/9) supplies
optional presentation hooks, not authentication or dashboard business logic.
An explicitly installed recipe styles `[data-theme-login]` only beneath
`body[data-activeadmin-theme="v3"]`. The login card uses a bounded fluid width,
clear title hierarchy, labelled-field spacing and a prominent submit control.
The host remains responsible for layout, labels, error announcements, links,
CSRF protection, authentication, and any Devise integration.

On native AA4 pages, `[data-theme-dashboard]` opts a host composition into an
auto-fitting grid with intrinsic minimum widths and long-content wrapping.
Panel and feedback presentation are separate surfaces (#6); this grid adds no
metrics, authorization decisions or model queries to the gem.

The synthetic host demonstrates the hooks with disposable products and a
deliberately fixture-only password. It is not a production authentication
template. Its three panels include operator navigation and long content; real
applications should provide their own useful, authorized content.

## Verification And Remaining Acceptance

Run `bin/build-host` then `bin/ci`. Request-level examples verify explicit login
opt-in, proper document title, a labelled password, rejected credentials,
dashboard navigation, and public-page isolation. These are not browser or
Devise end-to-end proofs. Login/error/dashboard screenshots, keyboard focus,
zoom, narrow and wide widths, dark contrast, and real-host authentication
acceptance remain part of #8/#11 review before completion is claimed.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
