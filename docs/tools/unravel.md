# unravel

| Field | Value |
|-------|-------|
| **Purpose** | Discovery — discovers existing system state and outputs it as entities. Wraps osquery + custom plugins |
| **Repo** | [AmadlaOrg/unravel](https://github.com/AmadlaOrg/unravel) |

## Overview

unravel discovers the actual state of a system and outputs it as [HERY](../architecture/hery-concepts.md) entities. It wraps [osquery](https://osquery.io/) for system-level discovery (ports, processes, packages, etc.) and supports custom plugins for things osquery doesn't cover (application-specific state, container topology, etc.).

unravel is **stateless and on-demand** — it discovers and outputs, following the UNIX philosophy. If the user wants to cache the output, they pipe it to a file. No daemon mode.

## Commands

| Command | Description |
|---------|-------------|
| `unravel discover` | Discover system state and output as entities |
| `unravel discover --type <entity-type>` | Discover specific entity type (e.g., network) |
| `unravel settings` | Manage unravel configuration |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |
| LibraryPluginFramework | Plugin loading and IPC |

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

unravel can discover and output entities for these types:

| Entity Type | Source | Examples |
|------------|--------|----------|
| [System/Network](../entities/system-network.md) | osquery | Interfaces, routes, DNS |
| [System/Filesystem](../entities/system-filesystem.md) | osquery | Mounts, disk usage |
| [Package](../entities/package.md) | osquery | Installed packages |
| [Service](../entities/service.md) | osquery | Running services |
| [Security/Firewall](../entities/security-firewall.md) | osquery | Firewall rules, open ports |
| [User](../entities/user.md) | osquery | System users and groups |
| [Application](../entities/application.md) | Plugins | Application-specific state |
| [Container](../entities/container.md) | Plugins | Container topology |

## How It Works

unravel uses osquery (via `osqueryi`, on-demand) as a backend for system-level queries, wrapped with entity output format:

```
osquery (ports, processes, packages, etc.)
    │
unravel (adds entity wrapper + custom plugins)
    │
"what IS" entities (standard HERY format)
```

### Use Cases

- **Drift detection:** Combined with judge — compare "what IS" (unravel) vs "what SHOULD BE" (hery entities)
- **Entity generation:** Run unravel on an existing system to generate HERY entities from current configuration
- **System debugging:** Discover what's actually configured across multiple sources
- **Resource analysis:** What Java version does a JAR require? What ports are open? What packages are installed?

### Plugin System

Plugins extend unravel with custom discovery backends for things osquery doesn't cover:

- Application-specific state
- Container topology (Podman/Docker)
- Cloud provider metadata
- Custom configuration files

### Output Format

unravel outputs entities in standard HERY format, making output directly usable by judge, hery, weaver, or any other tool:

```bash
# Cache output if needed (UNIX philosophy)
unravel discover --type network > /tmp/network-state.json

# Pipe directly to judge
unravel discover --type network | judge audit
```

## Current Gaps

- Repository exists with a Makefile but minimal implementation
- osquery integration not yet started
- Plugin framework integration not yet designed
