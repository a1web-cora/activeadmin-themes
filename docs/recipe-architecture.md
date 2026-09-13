# V3 Recipe Architecture

V3 is maintained as ordered CSS concerns inside the gem and installed as one application-owned stylesheet.

Source concerns live under `lib/active_admin/themes/recipes/v3/`:

- `tokens.css`
- `chrome.css`
- `tables.css`
- `filters.css`
- `forms.css`
- `feedback.css`
- `login.css`
- `dashboard.css`
- `hardening.css`

`ActiveAdmin::Themes::Recipes::V3::PARTS` is the explicit cascade order. Do not replace it with glob or alphabetical ordering. Empty concern files are intentional stable slots for independently developed surfaces.

The installer composes non-empty concerns in manifest order and still writes exactly one host-owned `active_admin_v3.css` beside the selected Tailwind entrypoint. Hosts therefore keep a simple import contract while contributors get concern-local source files and smaller review diffs.

The refactor must not change rendered output. A regression spec locks the composed bytes to the pre-refactor canonical Git blob until a deliberate visual change is accepted. After that point, component changes should modify only the owning concern whenever practical; cross-cutting preference behavior belongs in `hardening.css` and semantic primitives belong in `tokens.css`.

This organization is especially important while ActiveAdmin 4 remains prerelease: upstream selector or markup changes should be localized to the affected concern rather than forcing edits through a monolithic stylesheet.
