<!-- docs/clean-build.md -->

# Clean Host Artifact Verification

`bin/container-build [git-ref]` builds a **committed** source archive;
`bin/container-verify [git-ref]` runs its exact labelled image offline.
`bin/container-rebuild [git-ref]` removes only that SHA's transient Compose project
and rebuilds without cache; `bin/container-down [git-ref]` removes that project's
containers/resources but retains the evidence image. Repeated cleanup is safe.
The compatibility command `bin/verify-container` builds then verifies.

The root `Dockerfile` and root `compose.yaml` define one synthetic verification
service, with no published ports, mounts, persistent database, or credentials.
The wrappers extract `git archive` into a temporary directory and load Compose
from that directory with `--env-file /dev/null`. Both the Dockerfile and Compose
configuration therefore come from the selected commit, not workspace edits.
Compose requires an explicit commit-pure context; it never defaults to `build: .`.
The temporary context is removed on exit. The SHA-scoped Compose project avoids
touching unrelated resources; cleanup does not prune images or volumes globally.

The resulting workflow runs the
resulting synthetic verification image without network access. It never mounts the
checkout or passes credentials into the image. Ignored files, local compiled CSS,
node_modules, bundled gems, databases, and uncommitted edits cannot enter the build.
Commit the proposed tooling before running it; the selected ref must contain
root `Dockerfile` and `compose.yaml`. Docker with Compose must already be available
(OrbStack is the local default).

The build disables Docker layer reuse and installs locked Ruby/npm dependencies,
compiles CSS, runs the full CI/package proof, and precompiles production assets.
The final image check renders login and public pages through Rails' integration
session and verifies the precompiled manifest, CSS response MIME and theme bytes,
local importmap module delivery/MIME, and database-free boot. It does not execute
JavaScript, inspect browser console output, or establish visual acceptance.

The [official mise image](https://github.com/jdx/mise/pkgs/container/mise/) is pinned
by multi-platform digest. Ruby and Bundler match repository pins; Node follows the
existing CI major 24. Dependency locks constrain packages, but this is a clean-build
proof, not a bit-for-bit reproducible toolchain or deployment image. The fixture
secret/authentication must never be deployed. No ports are published by this command.
The local image is retained with its full source SHA tag and OCI revision label for
inspection; no image or gem is published.

Mise remains bounded bootstrap/build tooling because replacing the verified Ruby
installation and existing bin-script build dispatch would duplicate toolchain
setup. The final image establishes direct Ruby/Node PATH entries and runs Bundler
without `mise exec`; no runtime mise dispatcher is required. Node retains the
existing major-24 selection policy, so its resolved version is recorded per image.
Compose `network_mode: none` preserves the previous `--network none` runtime
boundary; verification pins the inspected image ID after checking its OCI label.

Record the command, source SHA, final image ID, architecture, date, and exit result
in the review packet. Re-run against the combined accepted component source before
closing [#11](https://github.com/scarver2/activeadmin-themes/issues/11). Browser
screenshots, full interaction matrix, AA3.5 reference provenance, Showcase proof,
and separately reviewed Rodeo adoption remain distinct
[#13](https://github.com/scarver2/activeadmin-themes/issues/13) gates.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
