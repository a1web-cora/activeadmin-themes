<!-- docs/installer.md -->

# Installer preflight

## Explicit commands

Add `require "active_admin/themes/tasks"` to the host Rakefile, then run from the host root:

```bash
bundle exec rake activeadmin_themes:list
bundle exec rake 'activeadmin_themes:install[v3,app/assets/stylesheets/active_admin.css]'
bundle exec rake 'activeadmin_themes:status[v3,app/assets/stylesheets/active_admin.css]'
```

Supply the actual existing Tailwind input (not generated build output). Installation creates `active_admin_v3.css` beside it and prints an explicit import to add to that input. The host owns this one-line integration and its existing compiler. Rebuild before checking the browser. Installation never edits the original entrypoint or overwrites a recipe file: identical copies are skipped, customizations raise a conflict. Compare a future canonical recipe manually before upgrading.

The current stylesheet is a focus-indicator proof, not the completed V3 design. Writes use exclusive file creation. Work in a trusted, quiescent host checkout: this is not a filesystem sandbox against another process swapping parent directories. An I/O failure may leave a partial new recipe; inspect and remove that new file before retrying. Existing files are preserved.

The first slice of [installer issue #2](https://github.com/scarver2/activeadmin-themes/issues/2) provides a read-only installation plan. It does not install a theme or alter a styling entrypoint.

```ruby
require "active_admin/themes"
require "active_admin/themes/installation_plan"

plan = ActiveAdmin::Themes::InstallationPlan.new(
  root: Rails.root.to_s,
  theme: ActiveAdmin::Themes.registry.fetch(:v3),
  active_admin_version: ActiveAdmin::VERSION,
  files: { "app/assets/stylesheets/themes/v3.css" => recipe_content }
)
plan.status # relative path => :missing, :identical, or :modified
plan.installable? # false if any file differs from the recipe
```

The caller supplies the actual loaded ActiveAdmin version and canonical recipe contents. The root must exist. Paths must be normalized relative paths; symlinks and existing non-file destinations are rejected. Every status call rechecks disk contents. Files are compared byte for byte, and local changes are preserved.

An installable plan is a compatibility/content preflight result, not a guarantee of filesystem permissions or concurrency safety. A future writer must revalidate immediately before writes and handle failures and concurrent edits safely. Entrypoint discovery, canonical stylesheet assets, list/install/status commands, write transactions and packaged-gem host verification remain open in #2 and #11.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
