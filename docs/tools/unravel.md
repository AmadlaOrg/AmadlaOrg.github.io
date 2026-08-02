# unravel

| Field | Value |
|-------|-------|
| **Purpose** | Discovery — discovers existing system state and outputs it as HERY entities, fully delegated to `unravel-*` plugins |
| **Repo** | [AmadlaOrg/unravel](https://github.com/AmadlaOrg/unravel) |

## Overview

unravel discovers the actual state of a system and outputs it as [HERY](../architecture/hery-concepts.md) entities. The core does no discovery itself — it scans `PATH` for `unravel-*` plugin binaries and delegates entirely to them, streaming each plugin's stdout verbatim. Any backend (osquery, `/proc`, container APIs, cloud metadata) is a plugin's own implementation detail.

unravel is **stateless and on-demand** — it discovers and outputs, following the UNIX philosophy. If the user wants to cache the output, they pipe it to a file. No daemon mode.

## Commands

| Command | Description |
|---------|-------------|
| `unravel discover` | Run every discovered `unravel-*` plugin's `discover` subcommand and stream the output |
| `unravel discover --from <plugin>` | Run a single plugin (e.g., `--from system` runs `unravel-system`) |
| `unravel discover --type <entity-type>` | Pass a type filter through to the plugin(s) as `discover --type <entity-type>` |
| `unravel discover -f <file>` | Feed a file (or `-` for stdin) to the plugin's stdin |
| `unravel plugins` | List discovered `unravel-*` plugins (`-o table\|json\|yaml`, `--hery` envelope) |

Per-command sequence diagrams: [unravel Commands](unravel-commands.md).

## Dependencies

unravel deliberately depends on no Amadla libraries — plugin discovery and subprocess delegation are small enough to live in-repo:

| Library | Purpose |
|---------|---------|
| spf13/cobra | CLI framework |
| olekukonko/tablewriter | Table output for `plugins` |
| gopkg.in/yaml.v3 | YAML output for `plugins -o yaml` |
| stretchr/testify | Tests |

**Package structure:** `main.go` (Cobra entry point), `cmd/` (`discover`, `plugins`), `plugin/` (PATH scanning, `info` metadata, subprocess execution).

## Pipeline Position

unravel is a **discovery tool** — it feeds into judge for drift detection:

```bash
# Discover current network state
unravel discover --type network

# Drift detection pipeline
unravel discover | judge audit

# Reconciliation loop (on cron/systemd timer)
unravel discover | judge audit | lighthouse notify
```

## Entity Types Discovered

What unravel can discover depends entirely on which plugins are installed. Intended coverage:

| Entity Type | Source | Examples |
|------------|--------|----------|
| [System/Network](../entities/system-network.md) | Plugins | Interfaces, routes, DNS |
| [System/Filesystem](../entities/system-filesystem.md) | Plugins | Mounts, disk usage |
| [Package](../entities/package.md) | Plugins | Installed packages |
| [Service](../entities/service.md) | Plugins | Running services |
| [Security/Firewall](../entities/security-firewall.md) | Plugins | Firewall rules, open ports |
| [User](../entities/user.md) | Plugins | System users and groups |
| [Application](../entities/application.md) | Plugins | Application-specific state |
| [Container](../entities/container.md) | Plugins | Container topology |

## How It Works

unravel scans `PATH` for executables named `unravel-*` and fans out to them. Each plugin wraps its own discovery backend:

```
unravel-* plugins (each wraps its own backend: proc, package DB, APIs, ...)
    │  discover → entities (JSON) on stdout
unravel (PATH discovery + fan-out, streams plugin output verbatim)
    │
"what IS" entities
```

### Plugin Protocol

Plugins follow the standard UNIX plugin protocol:

- `info` subcommand → JSON metadata (`name`, `version`, `backend`, `description`, `supports`), HERY-wrapped or flat
- `discover` subcommand → entities as JSON on stdout
- `discover --type <entity-type>` → filtered discovery (filtering is the plugin's job)
- Exit codes: 0 success, 1 failure, 2 usage error
- Data to stdout, diagnostics to stderr

### Use Cases

- **Drift detection:** Combined with judge — compare "what IS" (unravel) vs "what SHOULD BE" (hery entities)
- **Entity generation:** Run unravel on an existing system to generate HERY entities from current configuration
- **System debugging:** Discover what's actually configured across multiple sources
- **Resource analysis:** What Java version does a JAR require? What ports are open? What packages are installed?

### Output Format

Plugins are expected to emit entities in standard HERY format, making output directly usable by judge, hery, weaver, or any other tool. The core streams plugin stdout as-is:

```bash
# Cache output if needed (UNIX philosophy)
unravel discover --type network > /tmp/network-state.json

# Pipe directly to judge
unravel discover --type network | judge audit
```

## Planned

- **osquery-backed plugin:** an `unravel-*` plugin wrapping [osquery](https://osquery.io/) (via `osqueryi`, on-demand) for system-level queries — ports, processes, packages. The core will never invoke osquery directly; it stays a plugin backend.
- **First-party plugins:** no `unravel-*` plugin repos have been published yet, so `discover` currently finds nothing unless you provide your own plugin.

## Current Gaps

- No `unravel-*` plugins published yet — with none on `PATH`, `discover` prints a note to stderr and exits 0
- `-o/--output` on `discover` is accepted but is a no-op — output format is whatever the plugin emits
- In fan-out mode (no `--from`), a plugin failure is only a stderr warning; the exit code stays 0
- Core-side `--type` filtering exists in code but is unwired — `--type` relies entirely on plugin support
- In fan-out mode, `-f`/stdin input is shared across plugins, so only the first plugin can consume it
