# amadla

| Field | Value |
|-------|-------|
| **Purpose** | Meta-tool — executes Pipeline entities, generates D2 diagrams, manages tool inventory |
| **Language** | Go |
| **Repo** | [AmadlaOrg/amadla](https://github.com/AmadlaOrg/amadla) |

## Overview

amadla is the meta-tool for the ecosystem. It reads Pipeline entities (`.hery` files with `_type: amadla.org/entity/Pipeline@v1.0.0`) that describe multi-step tool workflows, executes them, and can generate D2 diagrams for visualization.

The amadla tool itself is written in Go, but it is **replaceable** — the Pipeline entities are the portable part. Anyone can read the Pipeline entity and orchestrate the tools their own way.

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `amadla init` | Planned | Bootstrap `tools.hery` by scanning PATH for standard Amadla tools |
| `amadla run <pipeline>` | Planned | Execute a Pipeline entity (order from `_requires` DAG) |
| `amadla diagram <pipeline> --format d2` | Planned | Generate D2 diagram text from a Pipeline entity |
| `amadla diagram <pipeline> --run-id latest --format d2` | Planned | Generate annotated diagram with pass/fail coloring |
| `amadla list` | Planned | Show installed tools and their plugins |
| `amadla doctor` | Planned | Check that all tools are installed and compatible |
| `amadla settings` | Planned | Manage amadla configuration |
| `amadla --config ./tools.hery` | Planned | Use a custom config file location |

## Pipeline Entity

Pipelines are defined as HERY entities — data, not executable code (like GitHub Actions YAML or podman-compose):

```yaml
# yaml-language-server: $schema=https://amadla.org/entity/hery/v1.0.0/schema.hery.json
---
_type: amadla.org/entity/Pipeline@v1.0.0
_meta:
  name: deploy-my-app
  description: Canary deployment pipeline
_body:
  steps:
    - id: query
      tool: hery
      args: ["query", "--type", "*/application@*"]
      outputs_to: resolve
    - id: resolve
      tool: doorman
      args: ["resolve"]
      outputs_to: render
    - id: render
      tool: weaver
      args: ["render", "--template", "quadlet"]
      outputs_to: deploy
    - id: deploy
      tool: waiter
      args: ["deploy", "--strategy", "canary"]
```

## D2 Diagram Generation

amadla generates D2 text (not images). The user runs the `d2` CLI tool to render:

```bash
amadla diagram deploy-my-app --format d2 > pipeline.d2
d2 pipeline.d2 pipeline.svg
```

After a pipeline run, amadla can generate an annotated diagram showing which steps passed or failed:

```bash
amadla run deploy-my-app
amadla diagram deploy-my-app --run-id latest --format d2 > result.d2
d2 result.d2 result.svg  # Failed steps shown in red
```

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |

## Tool Discovery

amadla discovers tools via a **config-driven** model (like xdg-open):

1. **`~/.config/amadla/tools.hery`** — lists tool names, optionally with explicit paths. This is the sole source of truth — **no hardcoded tool names**.
2. **PATH resolution** — amadla looks up each tool name on PATH (same logic across OSes). Explicit path overrides are optional.
3. **`<tool> info`** — amadla calls `info` on each discovered tool to learn capabilities (supported entity types, version, etc.)
4. **Cache** — results are cached at `~/.cache/amadla/tools.json`. Cache invalidation is mtime-based: if `tools.hery` is newer than the cache, amadla re-runs `info` on all tools.
5. **`amadla init`** — bootstraps a default `tools.hery` by scanning PATH for standard Amadla tool names.

### tools.hery Example

```yaml
_type: amadla.org/entity/tools@v1.0.0
_body:
  tools:
    - name: hery
    - name: doorman
    - name: weaver
    - name: lay
      path: /opt/custom/bin/lay
    - name: raise
    - name: my-custom-tool
      path: /home/user/bin/my-tool
```

### Cross-Tool Plugin Sharing

Plugins are standalone CLIs — **any tool or user can call any plugin directly**. For example, `unravel` can call `raise-libvirt status` to get server state without duplicating code. Each caller formats output its own way. Tools don't gatekeep their plugins.

## Execution Ordering

amadla does **not** use hardcoded phases. Execution order is derived from `_requires` declarations in entities:

1. amadla reads all `.hery` files and collects `_requires` declarations
2. Builds a dependency graph (DAG) from `_requires` references
3. Topologically sorts the DAG to determine execution order
4. Independent branches can be parallelized
5. True cycles are schema design errors — detected and reported (like Go import cycles)

## Current Gaps

- Concept stage — no repository or code yet
- Pipeline entity schema not yet defined
- Tools entity schema (`amadla.org/entity/tools@v1.0.0`) not yet defined
- D2 text generation not yet implemented
