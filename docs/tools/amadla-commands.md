# amadla Commands

Sequence diagrams for each `amadla` subcommand — the C4 dynamics level of the
[amadla architecture](amadla.md). Participants are the internal components
from the [architecture section](amadla.md#architecture): `cmd/` (Cobra
subcommands), `dag/` (topological sort and parallel tier grouping), and
`toolconfig/` (tools.hery parsing, PATH resolution, `<tool> info` cache) —
plus the externals they talk to: the filesystem
(`~/.config/amadla/tools.hery`, `~/.cache/amadla/tool-info.json`, the entity
directory) and the spawned tool CLIs (hery, raise, lay, enjoin, weaver,
waiter, judge, ...) fed over stdin.

## amadla run

Executes the pipeline: loads `tools.hery` (`--config` overrides the default
path), enriches tools missing `supports` via cached `<tool> info -o json`,
reads every `.hery` file in the target directory (non-recursive, current
directory by default), builds a DAG from `_requires`, and runs entities tier
by tier — entities within a tier run in parallel goroutines. Each entity is
marshaled to JSON and piped to its tool's stdin, also exported as the
`AMADLA_ENTITY` env var. `--dry-run` prints the numbered execution plan
instead. The entity's `_type` doubles as its DAG identity, so two files with
the same `_type` in one directory silently overwrite each other; entities
whose type has no registered tool are skipped with a warning, and a
`_requires` reference to an entity not present in the directory is silently
ignored. Cycles and tool failures exit 1.

![amadla run](../diagrams/out/seq-amadla-run.svg#only-light)
![amadla run](../diagrams/out/seq-amadla-run-dark.svg#only-dark)

## amadla init

Bootstraps `~/.config/amadla/tools.hery` by probing PATH for the 13
standard tool names (hery, doorman, weaver, lay, enjoin, waiter, raise,
unravel, judge, conduct, lighthouse, garbage, dryrun) and writing a minimal
config listing only the names found — entity-type routing is filled in
later by `<tool> info` enrichment. Refuses to overwrite an existing config
(exit 1); finding no tools prints guidance and exits 0 without writing.
Note that `init` ignores `--config` and always writes the default path.

![amadla init](../diagrams/out/seq-amadla-init.svg#only-light)
![amadla init](../diagrams/out/seq-amadla-init-dark.svg#only-dark)

## amadla list

Prints a table of every registered tool with its resolution status
(explicit `path` checked with stat, otherwise PATH lookup), resolved binary
path, and supported entity types after `<tool> info` enrichment. A missing
required tool is flagged `MISSING!` with an error line on stderr, but the
command still exits 0 — `list` is a report, `doctor` is the failing check.

![amadla list](../diagrams/out/seq-amadla-list.svg#only-light)
![amadla list](../diagrams/out/seq-amadla-list-dark.svg#only-dark)

## amadla doctor

Health-checks the registered tools: resolves each binary and runs
`<tool> --version`, printing `OK` lines with version and path, `SKIP` for
missing optional tools, and `FAIL` for missing required ones. Exits 1 with
`N required tool(s) missing` when any required tool is absent. A resolved
tool whose `--version` invocation fails is still reported `OK` with version
`unknown` — only PATH/stat resolution failures count as issues.

![amadla doctor](../diagrams/out/seq-amadla-doctor.svg#only-light)
![amadla doctor](../diagrams/out/seq-amadla-doctor-dark.svg#only-dark)
