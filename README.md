<!-- README.md -->

# ActiveAdmin Themes

Explicit, inspectable visual theme recipes for ActiveAdmin 4.

## Status

Early foundation work. Requiring `activeadmin-themes` does **not** restyle a Rails application. Recipe installation and assets are reserved for focused follow-up changes.

The first registered theme is `:v3`: ActiveAdmin 3.5-inspired hierarchy, density, and polish implemented on ActiveAdmin 4's Tailwind-era foundation—not copied legacy CSS.

```ruby
require "active_admin/themes"

theme = ActiveAdmin::Themes.registry.fetch(:v3)
theme.supports?(ActiveAdmin::VERSION)
```

## Development

```bash
bin/setup
bin/test
bin/ci
```

See the [documentation index](docs/README.md). [Rodeo issue #235](https://github.com/a1web/rodeo/issues/235) tracks eventual application adoption.

## License

[MIT](LICENSE) © 2026 Stan Carver II.

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
