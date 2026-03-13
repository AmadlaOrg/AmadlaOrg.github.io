# Plugin System

Amadla uses a plugin architecture to extend tools with external integrations. Plugins are **standalone CLI executables** that follow the UNIX philosophy: they communicate via stdin/stdout/stderr, use standard exit codes, and can be written in any language.

## Design Principles

1. **Plugins are standalone CLIs** — each plugin is a separate binary that works independently
2. **Protocol over API** — the contract is a data format (JSON/YAML), not a language-specific interface
3. **Any language** — plugins can be written in Go, Python, Bash, or anything that reads stdin and writes stdout
4. **PATH-based discovery** — tools find plugins by scanning `$PATH` for `<tool>-*` binaries
5. **Go frameworks are optional helpers** — they reduce boilerplate but are not required

## Plugin Categories

| Category | Host Tool | Naming | Purpose | Go Framework (optional) |
|----------|-----------|--------|---------|------------------------|
| **Doorman plugins** | doorman | `doorman-*` | Secret store integrations | LibraryDoormanFramework |
| **Judge plugins** | judge | `judge-*` | System/application validation | LibraryJudgeFramework |
| **Weaver plugins** | weaver | `weaver-*` | Template engine integrations | — |
| **Raise plugins** | raise | `raise-*` | Infrastructure providers | — |
| **Waiter plugins** | waiter | `waiter-*` | Deployment platform backends | — |
| **Lighthouse plugins** | lighthouse | `lighthouse-*` | Notification channels | — |
| **Lay plugins** | lay | `lay-*` | Installer backends | — |

## Architecture

<!-- Diagram placeholder: Plugin Architecture (c2-plugin-architecture) -->

### Plugin Discovery

Tools discover plugins by scanning `$PATH` for binaries matching the `<tool>-*` naming convention:

```
doorman-vault         # doorman discovers this as a secret source plugin
doorman-aws           # another doorman plugin
judge-application     # judge discovers this as a validation plugin
weaver-jinja          # weaver discovers this as a template engine plugin
raise-libvirt         # raise discovers this as an infrastructure plugin
```

This follows the same model as `git` (which discovers `git-*` subcommands on PATH).

Plugins are callable by **any tool or user** directly — tools don't gatekeep their plugins. For example, `unravel` can call `raise-libvirt status` to get server state without duplicating code. Each caller formats output its own way.

The **amadla** meta-CLI provides a two-tier discovery view:

1. `amadla` reads `~/.config/amadla/tools.hery` for tool names (no hardcoded list — all tools come from config). `amadla init` bootstraps this file by scanning PATH.
2. Each tool discovers its own plugins via `<tool>-*` PATH scan
3. `amadla` calls `<tool> info` on each tool and caches results at `~/.cache/amadla/tools.json` (mtime-based invalidation)

### Communication — The Plugin Protocol

Plugins communicate via **standard I/O streams**, not IPC:

| Channel | Purpose |
|---------|---------|
| **stdin** | Entity data input (YAML or JSON, auto-detected) |
| **stdout** | Result data output (format controlled by `-o` flag) |
| **stderr** | Diagnostics, progress messages, errors |
| **exit code** | `0` = success, `1` = failure, `2` = usage error |

#### Required Subcommands

Every plugin MUST implement:

```bash
# Return plugin metadata as JSON
<plugin> info
# Output: {"name": "<plugin>", "version": "1.0.0", "supports": ["amadla.org/entity/type@^v1.0.0"], "description": "..."}

# Execute the plugin's main function
<plugin> <verb> [flags]
# Reads entity data from stdin (or -f flag), writes result to stdout
```

#### Standard Flags

All plugins MUST support:

| Flag | Purpose |
|------|---------|
| `-o, --output <format>` | Output format: `table` (default), `json`, `yaml` |
| `-f, --file <path>` | Input file (`-` for stdin, which is also the default) |
| `-v, --version` | Print version |
| `-h, --help` | Print help |

#### Input Format

Plugins MUST accept both YAML and JSON input. Detection is automatic: if the first non-whitespace character is `{`, it's JSON; otherwise YAML.

### Plugin Lifecycle

1. Tool receives a request (entity data via stdin or hery query)
2. Tool scans `$PATH` for matching `<tool>-*` plugins
3. Tool calls `<plugin> info` to check entity support
4. Tool pipes entity data to the plugin's stdin
5. Plugin processes the data and writes result to stdout (diagnostics to stderr)
6. Tool aggregates results from all matching plugins
7. Tool outputs combined result to its own stdout

### Entity Routing

Each plugin declares which entity types it supports via the `info` subcommand. The host tool matches incoming entities to compatible plugins:

- **judge:** Routes entities to all plugins that support that entity type. If multiple plugins match, **all are called** (they may validate different aspects). Overall verdict = fail if ANY plugin fails.
- **doorman:** Routes to matching plugins. Each returns secrets in a universal entity format. Results are merged.
- **weaver:** Routing is **template-driven**, not plugin-driven (see below).
- **Other tools:** Route to matching plugins based on entity type.

#### Weaver Special Case — Template Entity

Weaver plugins are generic template engines (Jinja, Mustache, etc.) — they don't know about entity types. Instead, a **Template entity** drives the routing:

```yaml
_type: amadla.org/entity/template@v1.0.0
_body:
  engine: jinja                          # which weaver-* plugin to invoke
  path: ./templates/nginx.conf.j2        # relative path from entity location
  output: /etc/nginx/conf.d/myapp.conf   # where rendered file goes (absolute or relative)
  supports:                              # which entity types this template can render
    - amadla.org/entity/application@^v1.0.0
    - amadla.org/entity/infrastructure@^v1.0.0
```

Weaver queries hery for template entities, matches against the input entity type, resolves the template path relative to the entity's git location, and invokes the appropriate `weaver-*` plugin. Multiple template entities can match the same entity type — weaver renders all of them, each producing its own output file.

## Framework Hierarchy

```
LibraryPluginFramework          # Base: PATH scanning, info parsing, I/O piping
├── LibraryDoormanFramework       # Doorman plugins: secret fetching convenience
└── LibraryJudgeFramework       # Judge plugins: audit checks, compliance reporting
```

The Go frameworks are **convenience wrappers** that implement the plugin protocol. They reduce boilerplate for Go plugin authors but are not required. A plugin written in Python or Bash that follows the protocol works identically.

### LibraryPluginFramework

The base framework provides:

- PATH-based plugin discovery (`<tool>-*` scanning)
- `info` subcommand generation from Go struct metadata
- stdin/stdout/stderr I/O handling
- Output format switching (`-o table|json|yaml`)
- Standard flag registration

### LibraryDoormanFramework

Convenience wrapper for doorman plugin authors:

- Standard secret-fetching interface
- Secret entity output formatting
- Common authentication patterns

### LibraryJudgeFramework

Convenience wrapper for judge plugin authors:

- Standard audit check interface
- Pass/fail reporting with details
- Entity-to-audit-rule mapping

## Creating a Plugin

### In Go (using framework)

```go
package main

import (
    "github.com/AmadlaOrg/LibraryDoormanFramework"
)

func main() {
    plugin := LibraryDoormanFramework.New("doorman-vault", "1.0.0",
        []string{"amadla.org/entity/secret@^v1.0.0"},
        func(entityData []byte) ([]byte, error) {
            // Fetch secret from Vault — pure business logic
            // Return secret entity as JSON
        },
    )
    plugin.Run()
}
```

### In Bash (no framework needed)

```bash
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
    info)
        echo '{"name":"doorman-env","version":"1.0.0","supports":["amadla.org/entity/secret@^v1.0.0"],"description":"Secrets from environment variables"}'
        ;;
    get)
        # Read entity from stdin, extract key, return secret
        key=$(cat | python3 -c "import sys,json; print(json.load(sys.stdin)['_body']['key'])")
        value="${!key:-}"
        if [ -z "$value" ]; then
            echo "Error: env var $key not set" >&2
            exit 1
        fi
        echo "{\"_type\":\"amadla.org/entity/secret@v1.0.0\",\"_body\":{\"key\":\"$key\",\"value\":\"$value\"}}"
        ;;
    *)
        echo "Usage: doorman-env {info|get}" >&2
        exit 2
        ;;
esac
```

### In Python (no framework needed)

```python
#!/usr/bin/env python3
import sys, json, yaml

def main():
    if len(sys.argv) < 2:
        print("Usage: judge-security {info|validate}", file=sys.stderr)
        sys.exit(2)

    if sys.argv[1] == "info":
        json.dump({"name": "judge-security", "version": "1.0.0",
                    "supports": ["amadla.org/entity/application@^v1.0.0"],
                    "description": "Security checks for applications"}, sys.stdout)
    elif sys.argv[1] == "validate":
        entity = yaml.safe_load(sys.stdin)
        # ... validation logic ...
        json.dump({"status": "pass", "details": {}}, sys.stdout)
    else:
        print(f"Unknown command: {sys.argv[1]}", file=sys.stderr)
        sys.exit(2)

if __name__ == "__main__":
    main()
```

## Current Plugin Inventory

See the full plugin listings:

- [Doorman Plugins](../plugins/clerks.md) — 16 plugins (1 active, 15 stubs)
- [Judge Plugins](../plugins/auditors.md) — 3 plugins (1 active, 2 stubs)
- [Weaver Plugins](../plugins/weavers.md) — 4 plugins (all stubs)
