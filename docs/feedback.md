<!-- docs/feedback.md -->

# Panels And Feedback

The V3 recipe uses shared light/dark tokens for panel headings, attribute tables,
status tags and native flash messages. Status words remain visible. Arbitrary
domain statuses remain neutral; only ActiveAdmin's boolean `yes` gets the success
palette. The theme never decides whether a host-specific status is good or bad.
Native destructive links retain their confirmation and method behavior and gain
an underline as well as the danger color.

ActiveAdmin 4.0.0.beta22 exposes flash utility classes but no semantic CSS hooks.
The recipe limits those selectors to the native flash container immediately after
the page header. It does not recolor arbitrary host utility classes or assume all
ARIA alerts are errors. Recheck that structure on ActiveAdmin upgrades.

The synthetic `/admin/feedback` page supplies all three flash severities, native
boolean/unset/custom status tags, long content and a non-flash utility-class probe.
Request specs check native markup and retained actions; they do not prove rendered
contrast or visual parity. Combined browser and viewport acceptance stays in
[#8](https://github.com/scarver2/activeadmin-themes/issues/8) and
[#11](https://github.com/scarver2/activeadmin-themes/issues/11).

Related surface: [#6](https://github.com/scarver2/activeadmin-themes/issues/6).

—
Stan Carver II
Made in Texas 🤠
https://stancarver.com
