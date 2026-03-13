# LibraryUtils

| Field | Value |
|-------|-------|
| **Purpose** | Foundation utility library — shared functionality across all Amadla projects |
| **Module** | `github.com/AmadlaOrg/LibraryUtils` |
| **Status** | Active |
| **Repo** | [AmadlaOrg/LibraryUtils](https://github.com/AmadlaOrg/LibraryUtils) |

## Package Structure

| Package | Purpose |
|---------|---------|
| `configuration/` | Config management via Viper |
| `database/sqlite3/` | SQLite3 with interface wrappers for all sql types |
| `database/ristretto/` | In-memory caching (Dgraph Ristretto) |
| `encryption/aes_gcm/` | AES-GCM encryption service |
| `file/` | File system operations |
| `git/` | Git operations via go-git (includes `remote/` and `config/` subpackages) |
| `interconnection/` | IPC with platform-specific implementations |
| `interconnection/client/` | IPC client (`unix/socket/`, `unix/dbus/`, `windows/named_pipe/`) |
| `interconnection/server/` | IPC server (matching platform-specific transports) |
| `location/` | XDG path utilities |
| `packaging/desktop/` | Desktop package generation |
| `packaging/document/` | Document package generation |

## Consumers

Every Go project in the ecosystem depends on LibraryUtils:

- hery, doorman, weaver (directly)
- LibraryFramework, LibraryDoormanFramework, LibraryJudgeFramework
- judge-application, doorman-keepassxc

## Development Notes

- **Phase 1** in the development plan — must be stabilized first
- Needs comprehensive test coverage audit
- Code duplicated in downstream projects should be consolidated here
- Git workflow: `develop` branch for features, `master` for stable releases

## Key Files

| Path | Purpose |
|------|---------|
| `git/git.go` | `Git` interface — Git operations |
| `file/file.go` | `File` interface — File system operations |
| `database/sqlite3/` | SQLite3 wrapper with full interface coverage |
| `encryption/aes_gcm/` | AES-GCM encryption service |
| `interconnection/` | Platform-specific IPC implementations |
| `.mockery.yaml` | Mock generation configuration |
| `.covignore` | Coverage exclusion patterns |
