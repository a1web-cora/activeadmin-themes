<!-- docs/clean-build.md -->

# Clean Host Artifact Verification

`bin/verify-container [git-ref]` builds a **committed** source archive and runs the
resulting synthetic verification image without network access. It never mounts the
checkout or passes credentials into the image. Ignored files, local compiled CSS,
node_modules, bundled gems, databases, and uncommitted edits cannot enter the build.
Commit the proposed tooling before running it; the selected ref must contain
`Dockerfile.host`. Docker must already be available (OrbStack is the local default).

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
