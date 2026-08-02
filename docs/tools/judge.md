# judge

| Field | Value |
|-------|-------|
| **Purpose** | Validation/audit — dispatches input data to `judge-*` plugins, streams their verdicts through |
| **Repo** | [AmadlaOrg/judge](https://github.com/AmadlaOrg/judge) |

## Overview

judge is a thin dispatcher for validation plugins. It discovers `judge-*` binaries on PATH and delegates validation to **one plugin per run**, explicitly named with the required `--from` flag. Input (JSON or YAML) is passed via `-f <file>` or stdin; the plugin's output and verdict pass straight through.

Each plugin understands the semantics of what it checks — e.g., `judge-network` knows how to test connectivity, DNS resolution, and HTTP endpoints. The core CLI does no comparison itself.

## Commands

| Command | Description |
|---------|-------------|
| `judge run` | Run validation via a single plugin: `--from <name>` (required) invokes `judge-<name> judge`, forwarding `-f <file>` or stdin |
| `judge plugins` | Discover `judge-*` binaries on PATH and list them with metadata from each plugin's `info` (`-o table\|json\|yaml`, `--hery` envelope) |

Per-command sequence diagrams: [judge Commands](judge-commands.md).

## Dependencies

| Library | Purpose |
|---------|---------|
| spf13/cobra | CLI commands and flags |
| olekukonko/tablewriter | Table output for `judge plugins` |
| gopkg.in/yaml.v3 | YAML output format |
| stretchr/testify | Tests |

The core CLI intentionally uses no Amadla libraries. LibraryJudgeFramework exists for **building** `judge-*` plugins in Go — it is not a dependency of judge itself.

## Pipeline Position

judge is typically the **final validation stage**, run independently of the main `raise` → `lay` → `enjoin` → `weaver` → `waiter` pipeline:

```bash
# Validate network checks from a file
judge run --from network -f checks.yaml

# Pipe check definitions in via stdin
cat apps.yaml | judge run --from application

# Pre-flight validation before a waiter deployment
judge run --from waiter -f deploy.yaml
```

## How It Works

```
judge run --from network -f checks.yaml
        │
        ├── looks up judge-network on PATH
        ├── executes: judge-network judge -f checks.yaml
        │   (stdin is forwarded when no -f is given)
        └── plugin stdout/stderr pass through unchanged
```

Plugin exit codes follow the UNIX plugin protocol: 0 = pass, 1 = fail, 2 = usage error. Note that the dispatcher flattens any plugin failure to its own exit 1, so callers cannot currently distinguish a validation failure from a usage error.

## Judge Plugins

| Plugin | Status | Validates |
|--------|--------|-----------|
| `judge-application` | Available | Applications/binaries installed at required versions ([Application](../entities/application.md), [Package](../entities/package.md)) |
| `judge-network` | Available | Connectivity, DNS resolution, HTTP endpoints ([System/Network](../entities/system-network.md)) |
| `judge-waiter` | Available | Pre-flight checks for waiter deployments (strategy, plugins, ports, image, state dir) |
| `judge-system` | Planned | System-level requirements (OS, kernel, resources) — [System](../entities/system.md) |
| `judge-infrastructure` | Planned | Infrastructure requirements (networking, storage, compute) — [Infrastructure](../entities/infrastructure.md) |

Plugins are discovered via PATH (`judge-*` naming convention) and describe themselves via their `info` subcommand. See [Judge Plugins](../plugins/judges.md).

## Planned

The longer-term design makes judge the drift detector for the ecosystem: compare "what SHOULD BE" (hery entities) against "what IS" (unravel output) and emit a **judge entity** — a diff in entity format:

```
hery query --type network        →  "what SHOULD BE" entity
unravel discover --type network  →  "what IS" entity
                                          │
                                    judge (deep diff)
                                          │
                                    judge entity (diff)
```

Example: you expect ports 80 and 443 open; unravel reports 80, 443, and 8080. judge would output:

```yaml
_type: amadla.org/entity/judge@v1.0.0
_body:
  status: fail
  entity_type: network
  differences:
    - path: "_body.ports"
      expected: [80, 443]
      actual: [80, 443, 8080]
      severity: warning
      message: "unexpected port 8080 open"
```

This judge entity could then pipe to lighthouse for alerting, enabling a reconciliation loop on a cron/systemd timer.

Also planned:

- **Generic deep-diff engine** — validate any entity type without a dedicated plugin.
- **Entity-type routing** — select plugins automatically from the input's `_type` using the `supports` list each plugin declares via `info`. If multiple plugins support the same entity type, all are called — they may validate different aspects. Overall verdict: fail if ANY plugin fails.
- The [Judge](../entities/judge.md) entity schema for the diff output format above.

## Current Gaps

- No generic deep-diff engine — `judge run` only delegates raw input to a plugin
- No entity-type routing or multi-plugin fan-out — exactly one plugin per run, named explicitly via `--from`
- Plugin exit code 2 (usage error) is flattened to exit 1 by the dispatcher
- Judge entity (diff) output schema not implemented in the core; plugin output passes through as-is
