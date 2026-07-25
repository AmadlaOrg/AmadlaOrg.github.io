# LibraryDoormanFramework

| Field | Value |
|-------|-------|
| **Purpose** | Doorman plugin framework — specialization for secret source plugins used by doorman |
| **Module** | `github.com/AmadlaOrg/LibraryDoormanFramework` |
| **Status** | Active |
| **Repo** | [AmadlaOrg/LibraryDoormanFramework](https://github.com/AmadlaOrg/LibraryDoormanFramework) |

## What It Provides

LibraryDoormanFramework extends LibraryPluginFramework for secret source plugins:

- Standard interface for fetching secrets by key/path
- Integration hooks for doorman's encrypted cache
- Platform-specific IPC (D-Bus on Linux, named pipes on Windows)

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | IPC, encryption, configuration |

## Consumers

- doorman-keepassxc
- doorman-vault (planned)
- doorman-aws (planned)
- All other doorman-* plugins

## Development Notes

- **Phase 2** in the development plan (specialization of plugin framework)
- Platform-specific IPC needs thorough testing on both Linux and Windows
