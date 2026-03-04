# doorman

| Field | Value |
|-------|-------|
| **Purpose** | Secrets management daemon — pulls secrets from Clerk plugins and stores them in an encrypted in-memory cache with TTL |
| **Module** | `github.com/AmadlaOrg/doorman` |
| **Status** | Early |
| **Repo** | [AmadlaOrg/doorman](https://github.com/AmadlaOrg/doorman) |
| **Go Version** | 1.24.0 |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `doorman settings` | Working | Manage doorman configuration |
| `doorman collection` | Stubbed | Collection management (commented out in code) |
| `doorman compose` | Stubbed | Entity composition (commented out in code) |
| `doorman start` | Planned | Start the secrets daemon |
| `doorman resolve` | Planned | Resolve secret references in entity data |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | IPC (Unix sockets / named pipes), encryption, configuration |
| LibraryFramework | CLI framework (Cobra wrapper) |

### External Dependencies

| Package | Purpose |
|---------|---------|
| `github.com/dgraph-io/ristretto` | High-performance in-memory cache with TTL |
| `github.com/spf13/cobra` | CLI framework |
| `golang.org/x/sys` | Platform-specific system calls |

## Pipeline Position

doorman sits **between hery and raise** in the pipeline. It receives entity data containing secret references and resolves them to actual values before passing data downstream.

```
hery → [doorman] → raise → lay → weaver → judge
         │
    ┌────┴────────┐
    │ Clerk       │
    │ Plugins     │
    │ (vault,     │
    │  aws, ...)  │
    └─────────────┘
```

## Architecture

<!-- Diagram placeholder -->

### Core Flow

```
Secret Source (Vault, AWS, KeePassXC, ...) → Clerk Plugin → Doorman Daemon → IPC → Client App
```

### Package Structure

```
main.go                 # CLI entry via LibraryFramework
internal/
├── cache/              # In-memory cache with platform-specific encryption
│   └── cache.go        # Ristretto cache + encryption wrapper
└── cmd/                # CLI subcommands
    └── settings.go     # Settings command implementation
```

### Cache Encryption

The in-memory cache encrypts secrets at rest using platform-specific mechanisms:

| Platform | Mechanism | Status |
|----------|-----------|--------|
| Linux | TPM-backed AES-GCM | Planned (currently XOR placeholder) |
| Windows | DPAPI | Planned |

<!-- Diagram placeholder -->

!!! warning "Security Note"
    Cache encryption currently uses XOR as a placeholder. Production use requires proper AES-GCM backed by TPM or platform keystore.

## Current Gaps

- Only `settings` command is functional; `collection` and `compose` are commented out
- No `start` (daemon) or `resolve` commands yet
- Cache encryption uses XOR placeholder — needs AES-GCM for production
- TPM integration is incomplete (TODO in cache.go)
- No Clerk plugin loading or IPC communication yet
- No tests beyond basic structure

## Key Files

| Path | Purpose |
|------|---------|
| `main.go` | CLI entry point |
| `internal/cache/cache.go` | Encrypted in-memory cache implementation |
| `internal/cmd/settings.go` | Settings command |
| `go.mod` | Dependencies and local replace directives |
