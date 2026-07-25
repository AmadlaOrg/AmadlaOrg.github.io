# amadla

| Field | Value |
|-------|-------|
| **Purpose** | Orchestrator — reads `.hery` entities, builds DAG from `_requires`, executes tools in dependency order |
| **Language** | Go |
| **Repo** | [AmadlaOrg/amadla](https://github.com/AmadlaOrg/amadla) |

## Overview

amadla is the top-level orchestrator for the Amadla tool pipeline. It reads `.hery` entity files from a directory, builds a dependency graph from `_requires` declarations, topologically sorts them, and shells out to the registered tool for each entity type. Independent entities within the same DAG tier run in parallel.

The amadla tool itself is **replaceable** — the entities and tools are the portable parts. Anyone can read `.hery` files, resolve the DAG, and orchestrate the tools their own way.

## Commands

| Command | Description |
|---------|-------------|
| `amadla run [entity-dir]` | Execute pipeline — resolve `_requires` DAG and run tools in order |
| `amadla run [entity-dir] --dry-run` | Print execution order without running tools |
| `amadla init` | Bootstrap `tools.hery` by scanning PATH for standard Amadla tools |
| `amadla list` | Show registered tools, their PATH status, and entity types |
| `amadla doctor` | Check that all tools are installed and compatible |
| `amadla --config ./tools.hery` | Use a custom config file location (default: `~/.config/amadla/tools.hery`) |

## How `run` Works

1. Loads `~/.config/amadla/tools.hery` (or `--config` path)
2. Enriches tools with cached `<tool> info` discovery (fills in missing entity types)
3. Builds `entity_type -> tool` lookup from config
4. Reads `.hery` files from the target directory, extracts `_type` and `_requires`
5. Builds a DAG and groups nodes into parallel execution tiers (Kahn's algorithm)
6. For each entity in order: marshals to JSON, pipes to tool's stdin, sets `AMADLA_ENTITY` env var
7. Entities within the same tier run concurrently via goroutines

With `--dry-run`, step 6 is replaced with printing the execution plan:

```
Execution order:
  1. amadla.org/entity/secret@v1.0.0
  2. [parallel] [amadla.org/entity/package@v1.0.0 amadla.org/entity/system/network@v1.0.0]
  3. amadla.org/entity/application@v1.0.0
  4. amadla.org/entity/template@v1.0.0
```

## Architecture

```
main.go          -> Root Cobra command with --config flag
cmd/
  run.go         -> Core pipeline: load config -> read .hery -> build DAG -> sort -> exec tools
  init.go        -> Bootstrap tools.hery by scanning PATH for standard Amadla tools
  list.go        -> Tabular display of registered tools and their status
  doctor.go      -> Verify tool installation and compatibility
dag/
  dag.go         -> Topological sort (DFS) + parallel tier grouping (Kahn's algorithm)
toolconfig/
  toolconfig.go  -> Parse tools.hery, resolve tool binaries via PATH, InfoCache
```

## Dependencies

| Library | Purpose |
|---------|---------|
| `github.com/spf13/cobra` | CLI framework |
| `github.com/goccy/go-yaml` | YAML parsing for .hery files |

## Tool Discovery

amadla discovers tools via a **config-driven** model (like xdg-open):

1. **`~/.config/amadla/tools.hery`** — lists tool names, optionally with explicit paths and entity types
2. **PATH resolution** — amadla looks up each tool name on PATH. Explicit path overrides are optional
3. **`<tool> info`** — for tools missing `entity_types` in config, amadla calls `<tool> info` to discover capabilities (entity types, version, description)
4. **Cache** — `<tool> info` results are cached at `~/.cache/amadla/tool-info.json`. Cache invalidation is mtime-based: if the tool binary's mtime changes, amadla re-runs `info`
5. **`amadla init`** — bootstraps a default `tools.hery` by scanning PATH for 13 standard Amadla tool names

### tools.hery Example

```yaml
_type: amadla.org/entity/tools@v1.0.0
_body:
  tools:
    - name: hery
      required: true
      entity_types:
        - amadla.org/entity/application@v1.0.0
    - name: doorman
    - name: weaver
    - name: lay
      path: /opt/custom/bin/lay
    - name: raise
    - name: my-custom-tool
      path: /home/user/bin/my-tool
```

Tools with explicit `entity_types` in the config skip the `<tool> info` call. Tools without `entity_types` are enriched automatically via cached discovery.

### Standard Tool Names

amadla recognizes 13 standard tool names for `init` scanning:

`hery`, `doorman`, `weaver`, `lay`, `enjoin`, `waiter`, `raise`, `unravel`, `judge`, `conduct`, `lighthouse`, `garbage`, `dryrun`

### Cross-Tool Plugin Sharing

Plugins are standalone CLIs — **any tool or user can call any plugin directly**. For example, `unravel` can call `raise-libvirt status` to get server state without duplicating code. Each caller formats output its own way. Tools don't gatekeep their plugins.

## Execution Ordering

amadla does **not** use hardcoded phases. Execution order is derived from `_requires` declarations in entities:

1. amadla reads all `.hery` files and collects `_requires` declarations
2. Builds a dependency graph (DAG) from `_requires` references
3. Topologically sorts the DAG to determine execution order
4. Independent branches are parallelized (goroutines within each tier)
5. True cycles are detected and reported as errors (like Go import cycles)

## Testing

62 tests across 3 packages:

| Package | Tests | Coverage |
|---------|-------|----------|
| `cmd/` | 27 | Integration tests for all commands (init, list, doctor, run with dry-run and actual execution) |
| `dag/` | 17 | Topological sort, cycle detection, parallel tier grouping, diamond/linear/independent patterns |
| `toolconfig/` | 18 | Config loading, PATH resolution, InfoCache with mtime invalidation, EnrichWithInfo |

## Future Work

- D2 diagram generation from DAG
- `settings` command for configuration management
- Parallel execution progress reporting
