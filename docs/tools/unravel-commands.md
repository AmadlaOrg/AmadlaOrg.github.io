# unravel Commands

Sequence diagrams for each `unravel` subcommand — the C4 dynamics level of
the [unravel architecture](unravel.md). Participants are unravel's internal
components — `cmd/` (Cobra commands) and `plugin/` (PATH scanning,
subprocess execution) — plus the externals they talk to: the `unravel-*`
plugin subprocesses, the filesystem (`$PATH` directory scans, `-f` input
files), and stdin/stdout. The CLI currently ships exactly these two
subcommands; the `unravel settings` command listed elsewhere in the docs
does not exist in the code, and the core contains no osquery integration —
all discovery is delegated to plugins.

## unravel discover

Runs the `discover` subcommand of `unravel-*` plugins and streams their
JSON HERY entities straight to stdout — unravel never parses or reformats
them, so the `-o` flag, although accepted, has no effect. `--from <name>`
targets a single plugin: a missing binary or non-zero plugin exit is fatal
(stderr, exit 1). Without `--from`, every plugin found on `$PATH` runs in
sequence and individual failures are downgraded to stderr warnings with an
overall exit 0. `--type` is passed through to the plugin verbatim — the
internal `filterByType` fallback is dead code, so filtering only works if
the plugin implements it. In fan-out mode the `-f`/stdin reader is shared
across all plugins, so only the first one actually receives the input.
Finding no plugins at all prints a note on stderr and exits 0.

![unravel discover](../diagrams/out/seq-unravel-discover.svg#only-light)
![unravel discover](../diagrams/out/seq-unravel-discover-dark.svg#only-dark)

## unravel plugins

Scans `$PATH` for executable `unravel-*` binaries, calls each one's
`info -o json`, and accepts either a HERY-enveloped (`_type` + `_body`) or
flat JSON metadata document. The result renders as a name / backend /
version / description table by default, or JSON / YAML via `-o`. A plugin
whose info call fails still gets a row — `?` fields with the error in the
description — and the command exits 0 regardless. `--hery` wraps the rows
in a `_type: amadla.org/entity/tools/plugins@v1.0.0` envelope, but only
for JSON and YAML output; with the default table format it is silently
ignored. An empty `$PATH` scan prints a note on stderr and exits 0.

![unravel plugins](../diagrams/out/seq-unravel-plugins.svg#only-light)
![unravel plugins](../diagrams/out/seq-unravel-plugins-dark.svg#only-dark)
