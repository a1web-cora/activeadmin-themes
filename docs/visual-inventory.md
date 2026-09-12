<!-- docs/visual-inventory.md -->

# V3 Reference And Evidence Inventory

Historical source: [AA3.5.0 variables](https://github.com/activeadmin/activeadmin/blob/v3.5.0/app/assets/stylesheets/active_admin/mixins/_variables.scss),
inspected September 12, 2026. This is tagged-source evidence, not a historical
screenshot. No mutable online demo is labeled AA3.5 here.

| Role | Tagged AA3.5 source | V3 target decision |
| --- | --- | --- |
| Body text | `#323537` | Preserve in light mode |
| Link | `#38678b` | Preserve in light mode |
| Selected table | `#d9e4ec` | Reuse for selected controls/rows |
| Error | `#932419` | Preserve, pair with text and pale surface |
| Page gutter | 30px | 1.875rem desktop, reduced on narrow screens |
| Table padding | 5px 10px 3px 10px | Proposed symmetric compact padding, not a historical measurement |
| Sidebar width | 270px | Preserve AA4 responsive behavior; do not copy the AA3 layout |
| Text size / control height | Not established by this source | Proposed 14px / 36px, 44px for coarse pointers |
| Focus / dark mode | Not established by this source | New semantic palette and visible focus treatment |

The locked current host is AA4.0.0.beta22 / Rails8.1.3.1 / Tailwind4.3.3.
Its baseline uses the native AA4 plugin and server-rendered hooks. The target
is a compact, readable adaptation, not a pixel-identical port. Token values
remain proposals until visual review; color contrast and keyboard operation
must be evaluated separately from historical resemblance.

## Evidence Gates

- Unit/package: full RSpec suite, 100% library line/branch coverage; built gem
  extraction and explicit install/repeat proof.
- Request: dashboard/index/filter/validation/CSS/public-page isolation in the
  synthetic host. This does not establish JavaScript execution.
- Browser/visual: pending durable login/dashboard/index/show/new/edit, empty,
  validation and long-content states at 1440, 1024, 768 and 390px; native menu,
  filters, sorting, scopes, pagination, batch, nested forms and dark persistence.
- Accessibility: pending keyboard, zoom, reduced motion, forced colors and
  contrast checks; no WCAG conformance claim.
- Delivery: hosted CI owner approval and workflow credential scope blocked;
  Showcase demonstration and separately reviewed Rodeo adoption not complete.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
