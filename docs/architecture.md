<!-- docs/architecture.md -->

# Architecture

Loading the gem exposes metadata and tooling; it never mutates ActiveAdmin configuration or injects assets. The explicit registry records each theme's key, name, description, ActiveAdmin requirement, and recipe version.

Future installation copies recipes into visible application-owned files, reports changes, and stops before overwriting local modifications. Themes own presentation only. ActiveAdmin owns behavior, and `activeadmin-react` remains outside the dependency graph.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
