<!-- docs/test-host.md -->

# Synthetic Test Host

The internal host tests the gem against ActiveAdmin 4.0.0.beta22, Rails
8.1.3.1, Ruby 4.0.5 and Tailwind CSS 4.3.3. It has no dependency on Rodeo
or ActiveAdmin React. It is local test infrastructure, not a deployable demo.

Run `bin/setup`, `mise exec -- npm ci`, `bin/build-host`, then `bin/host`.
Open http://127.0.0.1:4317/login and use the synthetic password `demo`.
The server binds loopback only. Never expose this fixture authentication to
the network. `PORT` optionally selects another loopback port.

SQLite is a deliberate test-only exception to the PostgreSQL application
standard: each process creates its own ignored database in `spec/host/tmp`.
The 45 products contain only deterministic synthetic content. Database files
remain available for debugging after exit; none are production data.

This is a synthetic gem fixture, not an example Rails application architecture.
`config/application.rb` defines the host; `config/environment.rb` only boots it.
The RSpec helper and Rack launcher explicitly call `ThemeHost::Database.prepare!`
before serving requests. That helper loads `db/schema.rb` and `db/seeds.rb` in a
transaction on first preparation. Repeated preparation preserves existing tables
and operator edits rather than recreating or duplicating records. Call preparation
before starting request threads. Asset precompilation does not prepare a database.
The publicly known secret key is fixture-only, just like the synthetic login.

`bin/build-host` resolves the installed ActiveAdmin gem through Bundler,
scans its templates and Ruby builders, and compiles the locked Tailwind plugin
into an ignored output. `bin/test` exercises real dashboard, filter, validation
and asset responses, as well as library and built-gem recipe tests. Run the full
suite for the normal 100% library coverage gate. Focused host-only runs do not
exercise the library and consequently do not satisfy its coverage threshold.

The public `/` page deliberately has no admin stylesheet. JavaScript uses the
single native AA importmap entrypoint; the host does not replace framework
menu, dark-mode, filter or batch-action behavior. The custom login layout opts
in with `data-activeadmin-theme="v3"`; it does not assume Devise.

Request tests are not browser, visual parity, production-build, or deployment
proof. Issue #11 tracks the remaining visual inventory separately. GitHub CI needs repository
owner approval before a first-time fork workflow can execute.

`bin/host-assets` rebuilds CSS and runs Propshaft precompilation with the
production Rails environment against this synthetic host. It produces an
ignored manifest containing CSS and native JavaScript modules. This proves
local production-mode precompilation, not a clean-container release build.
After changing styles, rerun it if the precompiled manifest is present.

The file input is a presentation probe only: uploads are not persisted. Nested
product notes are persisted only in the disposable process-local database.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
