# doorman

| Field | Value |
|-------|-------|
| **Purpose** | Secrets management — discovers `doorman-*` plugins on PATH and provides a unified interface for retrieving secrets from any backend |
| **Repo** | [AmadlaOrg/doorman](https://github.com/AmadlaOrg/doorman) |

## Commands

| Command | Description |
|---------|-------------|
| `doorman get <key> --from <plugin>` | Retrieve a secret by key via the named plugin (runs `doorman-<plugin> get <key>`, streams its output verbatim) |
| `doorman plugins` | List discovered `doorman-*` plugins from PATH with name, engine, version, description (`-o table\|json\|yaml`, `--hery` envelope) |

Per-command sequence diagrams: [doorman Commands](doorman-commands.md).

## Dependencies

| Library | Purpose |
|---------|---------|
| spf13/cobra | CLI command framework |
| olekukonko/tablewriter | Table output for `plugins` |
| gopkg.in/yaml.v3 | YAML output format |
| stretchr/testify | Test assertions |

doorman deliberately has no Amadla library dependencies (no `replace` directives) — plugin discovery and subprocess delegation are implemented directly.

## Entity Types

| Entity | What doorman Does |
|--------|------------------|
| [Secret](../entities/secret.md) | Retrieves secret values from the backend that owns them, via plugins |

## Pipeline Position

doorman sits **between hery and raise** in the pipeline diagram, but today it operates out-of-band: any tool (or shell script) that needs a secret calls `doorman get`. In-stream resolution of secret references in entity data is planned (see below).

```
hery → [doorman] → raise → lay → enjoin → weaver → waiter → judge
         │
    ┌────┴────────┐
    │ Doorman     │
    │ Plugins     │
    │ (vault,     │
    │  aws, ...)  │
    └─────────────┘
```

## Architecture

![doorman Internal Components](../diagrams/out/c3-doorman-internals.svg#only-light)
![doorman Internal Components](../diagrams/out/c3-doorman-internals-dark.svg#only-dark)

### Core Flow

```
doorman get <key> --from <plugin>  →  doorman-<plugin> get <key>  →  secret value on stdout
doorman plugins                    →  PATH scan for doorman-*     →  <plugin> info -o json per plugin
```

doorman is a **wrapper tool**, not a daemon. It discovers `doorman-*` executables on PATH (manual directory scan with exec-bit check and dedup) and delegates to them as subprocesses. `get` pipes the plugin's stdout and stderr straight through, so the secret value reaches the caller exactly as the plugin emits it. `plugins` queries each discovered plugin with `info -o json` and accepts both HERY-envelope (`_type`/`_body`) and flat JSON responses.

### Package Structure

```
main.go            # CLI entry (Cobra root command, registers get + plugins)
cmd/
├── get.go         # get command (--from required)
└── plugins.go     # plugins command (-o table|json|yaml, --hery)
plugin/
├── plugin.go      # Service: Discover (PATH scan), GetInfo, Get (subprocess exec)
└── plugin_test.go # Plugin service tests
```

## Planned (design direction — not yet built)

The longer-term design has doorman resolving secret references **inside entity streams**: entity data flows in on stdin, doorman finds Secret references, routes each to the plugin that supports that backend (using the `supports` list from plugin `info`), and emits the entities with secrets injected — a `resolve`-style command matching the pipeline position above.

![Secret Resolution Sequence](../diagrams/out/seq-secret-resolution.svg#only-light)
![Secret Resolution Sequence](../diagrams/out/seq-secret-resolution-dark.svg#only-dark)

```
Entity with secret refs → doorman → doorman-* plugin (via stdin/stdout) → Secret entity (universal format) → stdout
```

## Current Gaps

- No `resolve`-style command yet — secret references in entity streams are not resolved; doorman is called per-secret
- `--from` is always required on `get` — no auto-detection of which plugin owns a key (plugin `supports` metadata is parsed but unused for routing)
- `get` streams the raw plugin output with no `--hery` envelope or format flag (only `plugins` has those)
- No caching — every `get` and every `plugins` invocation re-executes plugins
- Tests cover the `plugin` package only; `cmd/` has none

## Key Files

| Path | Purpose |
|------|---------|
| `main.go` | CLI entry point (Cobra) |
| `cmd/get.go` | `get` command |
| `cmd/plugins.go` | `plugins` command and output rendering |
| `plugin/plugin.go` | Plugin discovery, `info` querying, subprocess execution |
| `go.mod` | Dependencies |
