<!-- docs/evidence-inventory.md -->

# Durable Browser Evidence

Issue [#11](https://github.com/scarver2/activeadmin-themes/issues/11) requires
archived observations, not conversation-only screenshots. Keep one JSON manifest
beside each run's PNG images. Store the bundle in a durable review attachment or
artifact store and link it in the exact-head PR packet. Never put credentials or
non-synthetic data in this bundle. Existing historical images are not acceptance
of a new head.

Run `bin/evidence-check /absolute/path/manifest.json FULL_SOURCE_SHA`. The command
is read-only and validates provenance consistency, unique case IDs, required
observation metadata, PNG signatures and SHA256 hashes. It does **not** decode or
review images, authenticate the supplied observations, measure accessibility,
or assert that the complete matrix passed. A valid pending inventory exits zero;
the output reports status counts and explicitly disclaims visual acceptance.

Manifest schema version 1:

```json
{
  "schema_version": 1,
  "source_sha": "FULL_40_CHARACTER_COMMIT_SHA",
  "browser": "Engine and exact browser version",
  "operating_system": "OS and version",
  "captured_at": "ISO8601 UTC capture timestamp",
  "build_command": "Exact build command and linked build-log artifact",
  "cases": [{
    "id": "390-light-index",
    "surface": "index",
    "route": "/admin/products",
    "palette": "light",
    "viewport": {"width": 390, "height": 900},
    "zoom_percent": 100,
    "status": "pending",
    "observation": "Not yet captured or visually reviewed"
  }]
}
```

For `pass` or `fail`, add `screenshot` with relative `path` and the file's
lowercase SHA256 `sha256`. Paths cannot escape the manifest directory, including
through symlinks. `pending` and `not-tested` deliberately need no image; state the
missing capability or next action in `observation`. Keep actual browser zoom
separate from CSS viewport size. Never derive a pass from image existence alone.

Use the [hardening matrix](hardening-matrix.md) for required cases, interactions,
preferences and zoom. Record resource responses, production artifact hashes and
clean-container proof separately, with their own exact source SHA. Cite the
canonical AA3.5.2 tagged source for visual-reference decisions; historical
AA3.5.0 notes are not a substitute. Multi-browser, physical-device, Showcase and
visual-reference dispositions remain explicit reviewer gates. This infrastructure
alone does not close #8, #11 or #13 and authorizes no release or adoption.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
