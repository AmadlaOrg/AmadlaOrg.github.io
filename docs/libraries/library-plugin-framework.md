# LibraryPluginFramework

| Field | Value |
|-------|-------|
| **Purpose** | Base plugin system framework — plugin discovery, loading, and IPC communication |
| **Module** | `github.com/AmadlaOrg/LibraryPluginFramework` |
| **Status** | Active |
| **Repo** | [AmadlaOrg/LibraryPluginFramework](https://github.com/AmadlaOrg/LibraryPluginFramework) |

## What It Provides

LibraryPluginFramework is the base for all Amadla plugin types. It provides:

- Plugin executable discovery by naming convention
- Plugin lifecycle management (start, stop, health check)
- IPC channel setup
- Message serialization (JSON)

## Consumers

- LibraryDoormanFramework (specializes for secret source plugins)
- LibraryJudgeFramework (specializes for audit plugins)

## Development Notes

- **Phase 2** in the development plan
- Needs solidification alongside LibraryFramework
- The specialization pattern (Doorman, Judge) should be clearly documented
