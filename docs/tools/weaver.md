# weaver

| Field | Value |
|-------|-------|
| **Purpose** | Template generator — renders configuration files from YAML/JSON data using pluggable template engines |
| **Repo** | [AmadlaOrg/weaver](https://github.com/AmadlaOrg/weaver) |

## Commands

| Command | Description |
|---------|-------------|
| `weaver weave` | Render a template with Go's built-in `text/template` engine |
| `weaver render` | Render a template via a discovered weaver-* plugin |
| `weaver plugins` | List discovered weaver-* plugins |
| `weaver settings` | Show weaver configuration (currently a placeholder) |
| `weaver version` | Show version information |

Per-command sequence diagrams: [weaver Commands](weaver-commands.md).

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File helpers (`file.IsFile`) |
| spf13/cobra | CLI command framework |
| olekukonko/tablewriter | Table output for `plugins` and `settings` |
| gopkg.in/yaml.v3 | YAML parsing of input data |
| stretchr/testify | Test assertions and mocks (tests only) |

## Pipeline Position

weaver sits **near the end** of the pipeline, after infrastructure is provisioned and applications installed. It generates configuration files from templates filled with entity data.

```
hery → doorman → raise → lay → enjoin → [weaver] → waiter → judge
                                   │
                          ┌────────┴─────────┐
                          │ Weaver Plugins   │
                          │ (go, jinja,      │
                          │  mustache, qute, │
                          │  freemarker)     │
                          └──────────────────┘
```

## Input Data

weaver is entity-agnostic today: it does not query hery or inspect `_type`. Input is any YAML or JSON document that parses as a **list of maps** (a single top-level map is rejected); `weave` renders the template once per list item. Typical usage pipes `hery` output into weaver or passes an entity file directly. Which HERY entities the data came from (Application, Service, Infrastructure, …) is up to the caller.

## Architecture

### Package Structure

```
main.go                 # Root command, registers subcommands, version
cmd/
├── weave.go            # weave command — built-in Go text/template rendering
├── render.go           # render command — delegates to weaver-* plugins
├── plugins.go          # plugins command — discovery listing (table/json/yaml, --hery)
├── settings.go         # settings command — placeholder (logic commented out)
└── template.go         # Entirely commented out — no template command exists
plugin/                 # PATH discovery, `info -o json` parsing, subprocess render
weave/                  # Built-in engine: parse template, parse data list, execute
fs/                     # Dead code — file open/create helpers, unused by any command
template/               # Stub — empty ListTemplates/Weave scaffolding, never called
hery/                   # Stub — HeryFunc returns a hardcoded string, never called
entity/                 # Empty package declarations only
```

### Template Engines

weaver supports multiple template engines via plugins:

| Plugin | Engine | Language |
|--------|--------|----------|
| weaver-go | Go templates | Go |
| weaver-jinja2 | Jinja2 | Python |
| weaver-mustache | Mustache | Go |
| weaver-qute | Qute | Java |
| weaver-freemarker | FreeMarker | Java |

### Engine Routing

Routing is **extension/flag-driven via plugin discovery**, not entity-driven. `weaver render` picks the engine two ways:

- `--engine <name>` (`-e`) maps directly to the plugin binary `weaver-<name>` (e.g. `--engine mustache` → `weaver-mustache`).
- Otherwise weaver scans `PATH` for executable `weaver-*` binaries, runs `<plugin> info -o json` on each (flat JSON or HERY envelope), and matches the template file's extension against the plugin-reported `file_extensions` list — first match in PATH order wins, compared case-insensitively.

The chosen plugin is executed as `<plugin> render -t <template> [-f <data>] [-o <output>]` with stdout/stderr passed through; weaver's stdin is forwarded when `-f` is omitted. weaver itself never opens the template or data file for `render`. Note the flag asymmetry: `-e` means *engine* on `render` but *entity file* on `weave`.

## Planned: Template-Entity Routing

The design direction is for routing to become **template-driven**: a [Template](../entities/template.md) entity (`.hery` file alongside the template) would tell weaver which engine to use and what entity types the template supports. The proposed shape:

```yaml
_type: amadla.org/entity/template@v1.0.0
_body:
  engine: jinja2                          # which weaver-* plugin to invoke
  path: ./templates/nginx.conf.j2        # relative path from entity location
  output: /etc/nginx/conf.d/myapp.conf   # where rendered file goes (absolute or relative)
  supports:                              # which entity types this template can render
    - amadla.org/entity/application@^v1.0.0
    - amadla.org/entity/infrastructure@^v1.0.0
```

In this model weaver would query hery for Template entities, match against the input entity type, resolve the template path, and invoke the right `weaver-*` plugin — rendering every matching template, each to its own output file. The Template entity schema exists in the Entities repo; weaver's consumption of it is unbuilt (the `template/`, `hery/`, and `entity/` packages are stubs).

## Current Gaps

- `weave` is broken as written: its `-t`/`-e`/`-o` flags are registered inside the Run function, after Cobra has parsed argv, so any flag is rejected as "unknown flag" and the required-`--template` check never takes effect
- `weave` failures print an error but still exit 0 (Run, not RunE); `render` and `plugins` return proper exit codes
- Input to `weave` must be a YAML/JSON **list** of maps — a single map document is rejected
- No hery integration and no Template-entity routing — the `template/`, `hery/`, and `entity/` packages are dead stubs; `fs/` is unused
- `settings` is a placeholder printing one hardcoded row; its storage/env logic is commented out

## Key Files

| Path | Purpose |
|------|---------|
| `cmd/render.go` | Render command — plugin delegation |
| `cmd/weave.go` | Weave command — built-in engine (flag bug lives here) |
| `cmd/plugins.go` | Plugins listing command |
| `plugin/plugin.go` | Plugin discovery, info parsing, extension matching, subprocess render |
| `weave/weave.go` | Built-in `text/template` rendering loop |
