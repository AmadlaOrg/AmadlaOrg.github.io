# hery Command Sequence Diagrams (C4 level) — Design

Date: 2026-07-26
Repo: AmadlaOrg.github.io
Status: approved design, pending implementation

## Goal

Complete the C4 model for the hery tool on the docs site. C1 (ecosystem
context), C2 (pipeline/plugins/libraries), and C3 (hery internals) exist.
This adds the code-dynamics level: one PlantUML sequence diagram per hery
subcommand, embedded on a new "hery Commands" page with prose explanations
in the page body (not baked into the images). hery only for now; other
tools follow the same pattern later if this works well.

## Notation and conventions

Plain PlantUML sequence diagrams — the same style as the existing
`seq-secret-resolution.puml` and `seq-pipeline-flow.puml`:

- `@startuml seq-hery-<name>` header naming (output SVG name comes from it)
- `title` line, `skinparam sequenceArrowThickness 1.5`,
  `skinparam sequenceParticipantBorderColor #444`
- `== phase ==` separators, 2–3 phases per diagram
- One error lane where genuinely informative (mirrors the "plugin missing"
  lane in seq-secret-resolution)
- No C4-PlantUML macros and no smetana pragma (those are for the C1–C3
  component diagrams only); no `cloud` elements
- Light + dark pairs come from `docs/diagrams/render.sh` (`make diagrams`);
  nothing extra to do per diagram

Participants are the C3 components from `c3-hery-internals.puml`
(`cmd/`, `entity/cmd/`, `entity/build/`, `entity/get/`, `entity/resolve/`,
`entity/merge/`, `entity/compose/`, `entity/query/`, `entity/validation/`,
`entity/schema/`, `entity/version/`, `cache/`, `storage/`) plus externals:
the user/caller, Git remotes, SQLite file, filesystem. C4 therefore zooms
into C3 with consistent names. Only the participants a command actually
touches appear in its diagram.

## Files

New diagram sources in `docs/diagrams/src/` (8):

| File | Command | Sketch |
|------|---------|--------|
| `seq-hery-entity.puml` | `hery entity` | Parent dispatch: flag parsing in `cmd/`, delegation to `entity/cmd/` subcommands; unknown subcommand → usage on stderr, exit non-zero |
| `seq-hery-entity-init.puml` | `hery entity init` | Scaffold a new entity: storage writes, schema stub |
| `seq-hery-entity-get.puml` | `hery entity get` | Fetch from Git remote via `entity/get/` + `entity/version/` (tag resolution), build via `entity/build/` → `resolve/` → `merge/`, cache into SQLite |
| `seq-hery-entity-list.puml` | `hery entity list` | List known entities from `cache/`; cold-cache lane hits `storage/` |
| `seq-hery-entity-validate.puml` | `hery entity validate` | `entity/validation/` + `entity/schema/` against JSON Schema; invalid-document error lane |
| `seq-hery-query.puml` | `hery query` | Two-stage model: selection flags pick entities (`--from` file/dir/cache), then `--jq` projection; output to stdout |
| `seq-hery-compose.puml` | `hery compose` | `--dir`/`--layer` layering: `resolve/` + `merge/` flatten `_extends`, multi-doc/single-doc output to stdout (the `raise up -f -` pipe input) |
| `seq-hery-settings.puml` | `hery settings` | Paths and env lookup; no cache involvement |

Rendered outputs land in `docs/diagrams/out/` as `<name>.svg` +
`<name>-dark.svg` (16 files) via `make diagrams`.

Each diagram's message flow is verified against the hery source
(`hery/cmd/`, `hery/entity/...`) as it is written — the table above is a
sketch, the code is the truth. Where the sketch and code disagree, follow
the code and note the difference in the PR description.

## Page

New `docs/tools/hery-commands.md`, nav entry under Tools directly after
`hery`:

```
- hery: tools/hery.md
- hery Commands: tools/hery-commands.md
```

Structure: short intro paragraph (what this page is, link back to
`tools/hery.md` for the C3 architecture), then one `##` section per
command in the table order above. Each section:

1. 2–4 sentences of prose: what the command does, when you use it, what it
   reads/writes, notable flags (`--from`, `--dir`, `--layer`, `--hery`,
   `-o`). Prose lives in the page, never in the image.
2. The image pair:
   `![...](../diagrams/out/seq-hery-<name>.svg#only-light)` +
   `#only-dark` twin.

`docs/tools/hery.md` Commands section gets one line linking to the new
page.

`mkdocs.yml` `exclude_docs` gains a `superpowers/` line so this spec
directory never enters the site build.

## Verification

- `make diagrams` renders all sources with zero PlantUML errors
- `mkdocs build` in strict mode passes
- Visual check of at least one light/dark pair
- Participant names cross-checked against `c3-hery-internals.puml`

## Workflow

Branch `docs/hery-command-diagrams`, PR to master (repo's established
flow). Human-only authorship, no AI trailers. Commits scoped: spec,
diagrams+page, nav/link tweaks can land as one or few commits but nothing
unrelated.

## Out of scope

Other tools' command diagrams, changes to the C1–C3 diagrams, hery CLI
changes, `version`/`completion`/`help` subcommands (trivial, no diagram
value).
