# LibraryUtils

| Field | Value |
|-------|-------|
| **Purpose** | Foundation utility library — shared functionality across all Amadla projects |
| **Module** | `github.com/AmadlaOrg/LibraryUtils` |
| **Status** | Active |
| **Repo** | [AmadlaOrg/LibraryUtils](https://github.com/AmadlaOrg/LibraryUtils) |
| **Go Version** | 1.24.0 |

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

## Key Dependencies

| Package | Purpose |
|---------|---------|
| `github.com/go-git/go-git/v5` | Git operations |
| `github.com/mattn/go-sqlite3` | SQLite database |
| `github.com/dgraph-io/ristretto` | In-memory caching |
| `github.com/spf13/afero` | Filesystem abstraction |
| `github.com/spf13/viper` | Configuration management |
| `gopkg.in/yaml.v3` | YAML parsing |

## Consumers

Every Go project in the ecosystem depends on LibraryUtils:

- hery, doorman, weaver (directly)
- LibraryFramework, LibraryClerkFramework, LibraryAuditFramework
- auditor-application, clerk-keepassxc

## Development Notes

- **Phase 1** in the development plan — must be stabilized first
- Needs comprehensive test coverage audit
- Code duplicated in downstream projects should be consolidated here
- Git workflow: `develop` branch for features, `master` for stable releases

## Key Files

| Path | Purpose |
|------|---------|
| `git/git.go` | `IGit` / `SGit` — Git operations interface |
| `file/file.go` | `IFile` / `SFile` — File system operations |
| `database/sqlite3/` | SQLite3 wrapper with full interface coverage |
| `encryption/aes_gcm/` | AES-GCM encryption service |
| `interconnection/` | Platform-specific IPC implementations |
| `.mockery.yaml` | Mock generation configuration |
| `.covignore` | Coverage exclusion patterns |
