# hery Commands

Sequence diagrams for each `hery` subcommand — the C4 dynamics level of the
[hery architecture](hery.md). Participants are the internal components from
the [C3 diagram](hery.md#architecture), so each diagram zooms into the same
boxes: `cmd/`, `entity/cmd/`, `entity/get/`, `entity/resolve/`,
`entity/merge/`, `entity/compose/`, `entity/query/`, `entity/validation/`,
`entity/version/`, `entity/build/`, `cache/database/`, `storage/` — plus
`entity/` and `env/` where the code calls them directly, and the externals
they talk to (filesystem, Git remotes, SQLite).

## hery entity

Namespace command that groups the entity lifecycle subcommands: `init`,
`get`, `list`, and `valid`. Run bare it prints their help; an unknown
subcommand exits non-zero with usage on stderr.

![hery entity dispatch](../diagrams/out/seq-hery-entity.svg#only-light)
![hery entity dispatch](../diagrams/out/seq-hery-entity-dark.svg#only-dark)

## hery entity init

Scaffolds a new entity in the current directory: a starter JSON Schema
(`<name>.hery.json`, draft 2020-12, `$id` derived from the URI) and a stub
`default.hery` document carrying the `_type`. Existing files are
overwritten, so run it in a fresh directory.

![hery entity init](../diagrams/out/seq-hery-entity-init.svg#only-light)
![hery entity init](../diagrams/out/seq-hery-entity-init-dark.svg#only-dark)

## hery entity get

Fetches entities into the global cache (`HERY_STORAGE_PATH` or
`~/.cache/hery/entity`). Each URI is resolved to a concrete version from
the repository's Git tags — latest tag, an explicit `@version`, or a
generated pseudo-version when the repo has no tags — then the repo is
cloned and every `.hery` document it contains is read. References made
through `_extends` and `_type` are fetched recursively and deep-merged.
Success is silent; note that `get` populates the on-disk entity cache only,
not the SQLite database `hery query` reads.

![hery entity get](../diagrams/out/seq-hery-entity-get.svg#only-light)
![hery entity get](../diagrams/out/seq-hery-entity-get-dark.svg#only-dark)

## hery entity list

Scans the entity cache directory and prints a table of every downloaded
entity's origin, name, and version. A missing or empty cache prints a
message and exits zero — listing nothing is not an error.

![hery entity list](../diagrams/out/seq-hery-entity-list.svg#only-light)
![hery entity list](../diagrams/out/seq-hery-entity-list-dark.svg#only-dark)

## hery entity valid

Validates cached entity documents. `--all` walks the whole entity cache
and reports each document as valid or failed; `--rm <uri>` instead fetches
the named entities into a throwaway temp directory and prints its path.
Run bare it prints its help.

![hery entity valid](../diagrams/out/seq-hery-entity-validate.svg#only-light)
![hery entity valid](../diagrams/out/seq-hery-entity-validate-dark.svg#only-dark)

## hery query

The two-stage query model. Stage 1 selects entities — by default from the
SQLite cache (`~/.cache/hery/hery.db`), or from a YAML/JSON file or stdin
with `--from`, or from a resolved directory of `.hery` files with `--dir`
— filtering on `--type` (glob), `--meta`, and `--tag`. Stage 2 optionally
transforms each selected document with a `--jq` expression. Output is a
table, JSON, or YAML (`-o`), optionally wrapped in a HERY envelope with
`--hery`. Exit code 2 means the query ran but matched nothing, grep-style.

![hery query](../diagrams/out/seq-hery-query.svg#only-light)
![hery query](../diagrams/out/seq-hery-query-dark.svg#only-dark)

## hery compose

Flattens entities into their final form. With `--dir`, a local directory
of `.hery` files is resolved into ordered merge layers — `_requires`
ordering within a layer, local `_extends` deep-merged, non-local
references left as warnings — and emitted as a multi-document YAML stream
(`--layer N` picks one layer); this is the stream `raise up -f -`
consumes. With a positional entity URI, the cached entity's `_extends`
chain is deep-merged into a single document, printed by default or written
to `./composed.hery` with `--print=false`.

![hery compose](../diagrams/out/seq-hery-compose.svg#only-light)
![hery compose](../diagrams/out/seq-hery-compose-dark.svg#only-dark)

## hery settings

Prints a table of hery's resolved storage root (`HERY_STORAGE_PATH` or the
user cache dir) and the current values of hery's environment variables.

![hery settings](../diagrams/out/seq-hery-settings.svg#only-light)
![hery settings](../diagrams/out/seq-hery-settings-dark.svg#only-dark)
