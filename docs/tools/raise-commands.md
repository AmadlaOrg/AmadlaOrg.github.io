# raise Commands

Sequence diagrams for each `raise` subcommand — the C4 dynamics level of the
[raise architecture](raise.md). raise is a thin dispatcher: the internal
components are just `cmd/` (Cobra commands and output formatting), `entity/`
(provider sniffing from Infrastructure entity data), and `plugin/` (PATH
discovery and subprocess execution). Everything else happens in the externals:
the filesystem, stdin (multi-doc YAML piped from `hery compose --dir`), and
the `raise-*` plugin subprocesses (raise-libvirt, raise-virtualbox, ...) which
own the actual provisioning and keep per-plugin JSON state under
`~/.local/share/raise/<provider>/state.json`.

## raise up

Provisions infrastructure. `--provider` is optional: with `-f <file>` the
provider is sniffed from the first YAML document carrying `_body.provider`;
with `-f -` the whole stdin stream (e.g. `hery compose --dir . | raise up -f -`)
is buffered, sniffed the same way, then re-fed to the plugin so it sees the
full multi-doc stream. raise passes `up [name] -f <path>` through to
`raise-<provider>` and exits with the plugin's own exit code. With neither
`--provider` nor `-f`, it errors immediately.

![raise up](../diagrams/out/seq-raise-up.svg#only-light)
![raise up](../diagrams/out/seq-raise-up-dark.svg#only-dark)

## raise halt

Stops infrastructure without destroying it. `--provider` is required — there
is no state-based lookup in raise core, so it cannot infer which plugin owns
a name. Delegates `halt [name]` to `raise-<provider>` with stdio piped
through, and exits with the plugin's exit code.

![raise halt](../diagrams/out/seq-raise-halt.svg#only-light)
![raise halt](../diagrams/out/seq-raise-halt-dark.svg#only-dark)

## raise destroy

Removes infrastructure entirely. Identical dispatch shape to `halt`:
`--provider` required, `destroy [name]` delegated to `raise-<provider>`,
plugin exit code propagated. The plugin removes the VM and its disks and
drops the entry from its state file.

![raise destroy](../diagrams/out/seq-raise-destroy.svg#only-light)
![raise destroy](../diagrams/out/seq-raise-destroy-dark.svg#only-dark)

## raise ssh

Opens an interactive session by spawning `raise-<provider> ssh [name]` with
the terminal's stdin/stdout/stderr inherited. Despite the command's help text
("replacing the current process"), the code spawns a child process rather
than exec-replacing raise. Unlike `up`/`halt`/`destroy`, a non-zero ssh exit
is not propagated: raise reports a generic "exit status N" error and exits 1.

![raise ssh](../diagrams/out/seq-raise-ssh.svg#only-light)
![raise ssh](../diagrams/out/seq-raise-ssh-dark.svg#only-dark)

## raise status

With `--provider`, runs a single plugin's `status` and exits with its code.
Without it, discovers every executable `raise-*` binary on PATH and queries
each in turn, printing a `--- raise-<name> ---` header before each block.
Per-plugin failures go to stderr but the loop continues and the command
always exits 0 in the all-providers mode — check stderr, not the exit code.
No plugins on PATH is also exit 0.

![raise status](../diagrams/out/seq-raise-status.svg#only-light)
![raise status](../diagrams/out/seq-raise-status-dark.svg#only-dark)

## raise plugins

Discovers `raise-*` binaries on PATH, then calls each one's `info -o json`
and parses the result — a HERY envelope (`_type`/`_body`) is tried first,
flat JSON as fallback. Output is a plugin/engine/version/description table,
or JSON/YAML via `-o`, optionally HERY-wrapped with `--hery`. A plugin whose
info call fails still gets a row, with `?` fields and the error in the
description column; the command exits 0 regardless.

![raise plugins](../diagrams/out/seq-raise-plugins.svg#only-light)
![raise plugins](../diagrams/out/seq-raise-plugins-dark.svg#only-dark)

## raise info

Prints raise's own metadata (name, version, supported entity types,
description) as a table, JSON, or YAML (`-o`), optionally in a HERY envelope
(`--hery`). The supports list is a static constant —
`amadla.org/entity/infrastructure@^v1.0.0` only. Contrary to the
[architecture page](raise.md#entity-type-routing), plugin entity types are
not currently aggregated into this output: a `plugin.Service` is constructed
but never used by the output path.

![raise info](../diagrams/out/seq-raise-info.svg#only-light)
![raise info](../diagrams/out/seq-raise-info-dark.svg#only-dark)
