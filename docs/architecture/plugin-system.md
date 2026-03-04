# Plugin System

Amadla uses a plugin architecture to extend tools with external integrations. Plugins are **separate executables** that communicate with their host tool via IPC (Inter-Process Communication).

## Plugin Categories

| Category | Host Tool | Purpose | Framework |
|----------|-----------|---------|-----------|
| **Clerks** | doorman | Secret store integrations | LibraryClerkFramework |
| **Auditors** | judge | System/application auditing | LibraryAuditFramework |
| **Weavers** | weaver | Template engine integrations | — |

## Architecture

<!-- Diagram placeholder -->

### Plugin Discovery

Plugins follow a naming convention that allows the host tool to discover them:

```
{host}-{plugin-name}    # e.g., clerk-vault, auditor-application, weaver-jinja
```

The host tool searches for plugin executables in standard locations and loads them on demand.

### Communication

Plugins communicate with their host via platform-specific IPC:

| Platform | Mechanism |
|----------|-----------|
| Linux | Unix domain sockets or D-Bus |
| Windows | Named pipes |

The IPC layer is provided by `LibraryUtils/interconnection/`.

### Plugin Lifecycle

1. Host tool receives a request that requires a plugin
2. Host discovers and starts the plugin executable
3. Host sends structured data to the plugin via IPC
4. Plugin processes the request and returns results
5. Host incorporates results into its pipeline output

## Framework Hierarchy

```
LibraryPluginFramework          # Base plugin loading and IPC
├── LibraryClerkFramework       # Clerk-specific: secret fetching, caching hooks
└── LibraryAuditFramework       # Auditor-specific: audit checks, compliance reporting
```

### LibraryPluginFramework

The base framework provides:

- Plugin executable discovery and loading
- IPC channel setup (Unix sockets / named pipes)
- Message serialization (JSON)
- Plugin health checking and lifecycle management

### LibraryClerkFramework

Extends the plugin framework for secret source plugins:

- Standard interface for fetching secrets by key/path
- Integration with doorman's encrypted cache
- Platform-specific secure memory handling

### LibraryAuditFramework

Extends the plugin framework for audit plugins:

- Standard interface for running audit checks
- Compliance reporting format
- Entity-to-audit-rule mapping

## Creating a Plugin

A clerk plugin follows this pattern:

```go
package main

import (
    "github.com/AmadlaOrg/LibraryClerkFramework"
)

type VaultClerk struct {
    // plugin state
}

func (c *VaultClerk) FetchSecret(path string) (string, error) {
    // fetch from Vault
}

func main() {
    clerk := &VaultClerk{}
    LibraryClerkFramework.Serve(clerk)
}
```

The framework handles IPC setup, message routing, and lifecycle — the plugin author only implements the domain logic.

## Current Plugin Inventory

See the full plugin listings:

- [Clerk Plugins](../plugins/clerks.md) — 16 plugins (1 active, 15 stubs)
- [Auditor Plugins](../plugins/auditors.md) — 3 plugins (1 active, 2 stubs)
- [Weaver Plugins](../plugins/weavers.md) — 4 plugins (all stubs)
