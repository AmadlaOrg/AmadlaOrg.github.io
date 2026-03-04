# LibraryClerkFramework

| Field | Value |
|-------|-------|
| **Purpose** | Clerk plugin framework — specialization for secret source plugins used by doorman |
| **Module** | `github.com/AmadlaOrg/LibraryClerkFramework` |
| **Status** | Active |
| **Repo** | [AmadlaOrg/LibraryClerkFramework](https://github.com/AmadlaOrg/LibraryClerkFramework) |
| **Go Version** | 1.24.0 |

## What It Provides

LibraryClerkFramework extends LibraryPluginFramework for secret source plugins:

- Standard interface for fetching secrets by key/path
- Integration hooks for doorman's encrypted cache
- Platform-specific IPC (D-Bus on Linux, named pipes on Windows)

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | IPC, encryption, configuration |

### External Dependencies

| Package | Purpose |
|---------|---------|
| `github.com/Microsoft/go-winio` | Windows named pipe support |
| `github.com/godbus/dbus/v5` | Linux D-Bus communication |
| `golang.org/x/sys` | Platform-specific system calls |

## Consumers

- clerk-keepassxc
- clerk-vault (planned)
- clerk-aws (planned)
- All other clerk-* plugins

## Development Notes

- **Phase 2** in the development plan (specialization of plugin framework)
- Platform-specific IPC needs thorough testing on both Linux and Windows
