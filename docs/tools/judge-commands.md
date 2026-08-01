# judge Commands

Sequence diagrams for each `judge` subcommand — the C4 dynamics level of the
[judge architecture](judge.md). judge is deliberately thin: the participants
are just `cmd/` (Cobra commands) and `plugin/` (PATH discovery and subprocess
execution), plus the externals they talk to — the filesystem (PATH scanning
and binary lookup), the `judge-*` plugin subprocesses, and stdin/stdout.
Note that the shipped CLI currently exposes only `run` and `plugins`; the
`judge audit` and `judge settings` commands described on the architecture
page, along with the generic diff engine and entity-type routing, are not
yet implemented in code.

## judge run

Delegates validation to a single, explicitly named plugin: `--from network`
resolves `judge-network` on PATH and spawns `judge-network judge`, passing
`-f <file>` through untouched or wiring judge's stdin to the plugin when
`-f` is omitted. judge never opens the data file and never reformats the
result — plugin stdout and stderr stream straight through, so there is no
`-o` flag here. Any plugin failure (not found, or any non-zero exit,
including the protocol's exit 2 usage error) is wrapped as
`validation failed: ...` on stderr with exit 1 — plugin exit codes are not
propagated. There is no routing by entity type: one `--from`, one plugin,
per invocation.

![judge run](../diagrams/out/seq-judge-run.svg#only-light)
![judge run](../diagrams/out/seq-judge-run-dark.svg#only-dark)

## judge plugins

Scans every PATH directory for executable files named `judge-*`
(deduplicated, first-on-PATH wins; unreadable directories are skipped
silently), then calls each plugin's `info -o json` subcommand and accepts
either a HERY envelope or flat JSON. A plugin whose info call fails still
gets a row — with `?` fields and the error text — and the command still
exits 0. Output is table (default), JSON, or YAML via `-o`, optionally
wrapped in a `_type`/`_body` HERY envelope with `--hery`; an unknown `-o`
value silently falls back to table. Finding no plugins prints a notice on
stderr and exits 0.

![judge plugins](../diagrams/out/seq-judge-plugins.svg#only-light)
![judge plugins](../diagrams/out/seq-judge-plugins-dark.svg#only-dark)
