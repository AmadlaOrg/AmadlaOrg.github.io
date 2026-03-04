# Plugins Overview

Amadla uses plugins to extend core tools with external integrations. Each plugin is a **separate executable** that communicates with its host tool via IPC.

## Plugin Categories

| Category | Host Tool | Count | Active | Stubs |
|----------|-----------|-------|--------|-------|
| [Clerks](clerks.md) | doorman | 16 | 1 | 15 |
| [Auditors](auditors.md) | judge | 3 | 1 | 2 |
| [Weavers](weavers.md) | weaver | 4 | 0 | 4 |
| **Total** | | **23** | **2** | **21** |

## Naming Convention

Plugins follow the pattern `{host}-{name}`:

- `clerk-vault` — Clerk plugin for HashiCorp Vault
- `auditor-application` — Auditor plugin for application checks
- `weaver-jinja` — Weaver plugin for Jinja2 templates

## Plugin Frameworks

Each plugin category has a dedicated framework library:

| Framework | For | Base |
|-----------|-----|------|
| LibraryClerkFramework | Clerk plugins | LibraryPluginFramework |
| LibraryAuditFramework | Auditor plugins | LibraryPluginFramework |
| — | Weaver plugins | Direct (no framework yet) |

See [Plugin System Architecture](../architecture/plugin-system.md) for technical details.

## Development Status

Most plugins are currently stubs (README-only repositories). The two active plugins serve as reference implementations:

- **clerk-keepassxc** — Reference Clerk plugin (Go, D-Bus integration)
- **auditor-application** — Reference Auditor plugin (Go, LibraryAuditFramework)
