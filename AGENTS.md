<!-- AGENTS.md -->

# Repository Instructions

This repository follows Stan Carver II's machine-wide development policy. Keep changes focused on the `activeadmin-themes` RubyGem and preserve its explicit recipe boundary:

- loading the gem must never restyle or mutate a host application;
- installed recipe files become visible, application-owned source;
- themes own presentation, not ActiveAdmin behavior;
- `activeadmin-react` must not become a dependency;
- visual claims require host and screenshot evidence.

Use Ruby through mise, RSpec for tests, `master` as the default branch, focused pull requests, and Conventional Commits.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
