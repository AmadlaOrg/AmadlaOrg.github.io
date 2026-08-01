# weaver Commands

Sequence diagrams for each `weaver` subcommand — the C4 dynamics level of
the [weaver architecture](weaver.md). Participants are weaver's internal
packages: `cmd/` (Cobra commands), `weave/` (built-in Go `text/template`
engine), and `plugin/` (PATH discovery and subprocess delegation) — plus
the externals they talk to: the filesystem, stdin, and `weaver-*` plugin
subprocesses (e.g. `weaver-jinja`). The `fs/`, `template/`, `hery/`, and
`entity/` packages exist in the repo but are dead code — no command calls
them. `weaver version` simply prints the version string and is not
diagrammed.

## weaver weave

Renders a template with Go's `text/template` against entity data — stdin
by default, or a file via `-e`; output to stdout or a file via `-o`
(existing files are truncated without the overwrite prompt the code
comments promise). Input must parse as a JSON array or YAML sequence of
maps; a single map document is rejected. As written the command is
broken: its flags are registered inside the Run function, after Cobra has
already parsed argv, so any `-t`/`-e`/`-o` flag is rejected as unknown
and the `--template` required-flag check never takes effect. Failures in
the weave itself are printed but still exit 0 (Run, not RunE).

![weaver weave](../diagrams/out/seq-weaver-weave.svg#only-light)
![weaver weave](../diagrams/out/seq-weaver-weave-dark.svg#only-dark)

## weaver render

Delegates rendering to a `weaver-*` plugin. The engine comes from
`--engine` (`-e`, giving plugin `weaver-<engine>`) or is auto-detected by
matching the template file's extension against each discovered plugin's
`info -o json` output — first match in PATH order wins, extensions
compared case-insensitively including the dot. The plugin is then run as
`<plugin> render -t <template> [-f <data>] [-o <output>]` with its
stdout/stderr passed through; weaver's stdin is wired to the plugin only
when `-f` is omitted. weaver itself never opens the template or data
file. Missing extension, no matching plugin, or a non-zero plugin exit
all error on stderr with exit 1.

![weaver render](../diagrams/out/seq-weaver-render.svg#only-light)
![weaver render](../diagrams/out/seq-weaver-render-dark.svg#only-dark)

## weaver plugins

Scans every PATH directory for executable `weaver-*` binaries and runs
`<plugin> info -o json` on each (accepting flat JSON or a HERY
envelope). Prints a table by default, or JSON/YAML via `-o`; `--hery`
wraps the rows in an `amadla.org/entity/tools/plugins@v1.0.0` envelope.
A plugin whose `info` call fails still gets a row, with `?` fields and
the error in the description. No plugins found prints a notice on stderr
and exits 0 — an empty list is not an error. Note `-o` here selects the
output *format*, while on `weave`/`render` it is an output *path*.

![weaver plugins](../diagrams/out/seq-weaver-plugins.svg#only-light)
![weaver plugins](../diagrams/out/seq-weaver-plugins-dark.svg#only-dark)

## weaver settings

A placeholder. The storage-path and environment-variable listing logic is
commented out; the command prints a two-column table containing a single
hardcoded row (`Collections path` = `...`) and exits 0.

![weaver settings](../diagrams/out/seq-weaver-settings.svg#only-light)
![weaver settings](../diagrams/out/seq-weaver-settings-dark.svg#only-dark)
