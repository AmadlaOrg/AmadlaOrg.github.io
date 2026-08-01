# enjoin Commands

Sequence diagrams for each `enjoin` subcommand — the C4 dynamics level of the
[enjoin architecture](enjoin.md). enjoin is a thin dispatcher: the internal
components are just `cmd/` (the Cobra commands) and `plugin/` (PATH discovery
and subprocess execution), and the real work happens in the externals — the
`enjoin-*` plugin binaries it spawns, the filesystem it scans for them, and
stdin when entity data is piped in.

## enjoin apply

Applies system state by delegating to one plugin: `--from user` resolves to
the `enjoin-user` binary on PATH and runs `enjoin-user apply`. With `-f` the
file *path* is forwarded and the plugin opens it itself — enjoin never reads
the data; without `-f` the plugin inherits enjoin's stdin, which is what makes
`hery compose ... | enjoin apply --from user` work. Plugin stdout and stderr
pass straight through. Any plugin failure surfaces as `apply failed: ...` with
exit 1 — the plugin protocol's usage-error code 2 is not propagated by the
dispatcher.

![enjoin apply](../diagrams/out/seq-enjoin-apply.svg#only-light)
![enjoin apply](../diagrams/out/seq-enjoin-apply-dark.svg#only-dark)

## enjoin validate

Identical wiring to `apply`, but runs the plugin's `validate` subcommand: a
dry run that reports what would change without touching the system. Whether
anything is actually mutated is entirely the plugin's contract — enjoin itself
only picks the subcommand. Same `--from` (required) and `-f`/stdin behavior;
failures surface as `validation failed: ...` on stderr with exit 1.

![enjoin validate](../diagrams/out/seq-enjoin-validate.svg#only-light)
![enjoin validate](../diagrams/out/seq-enjoin-validate-dark.svg#only-dark)

## enjoin plugins

Scans every `$PATH` directory for executable files named `enjoin-*`
(duplicates deduplicated, first PATH hit wins), then calls each one's
`info -o json` and renders a table — or JSON/YAML via `-o`, optionally
wrapped in a HERY `_type`/`_body` envelope with `--hery`. Info responses in
either HERY envelope or flat JSON form are accepted. Finding no plugins is
not an error: a notice goes to stderr and the exit code is 0; a plugin whose
`info` call fails still gets a row, with `?` placeholders and the error text
as its description.

![enjoin plugins](../diagrams/out/seq-enjoin-plugins.svg#only-light)
![enjoin plugins](../diagrams/out/seq-enjoin-plugins-dark.svg#only-dark)
