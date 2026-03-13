# garbage

| Field | Value |
|-------|-------|
| **Purpose** | Trash/uninstall tool — tracks and removes what's no longer needed |
| **Status** | Partial |
| **Repo** | [AmadlaOrg/garbage](https://github.com/AmadlaOrg/garbage) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `garbage rm` | Working | Remove/trash items |
| `garbage list` | Working | List trashed items |
| `garbage restore` | Working | Restore trashed items |
| `garbage empty` | Working | Permanently delete trashed items |
| `garbage info` | Working | Show information about trashed items |
| `garbage settings` | Working | Manage garbage configuration |
| `garbage binary` | Working | Manage binary cleanup |
| `garbage package` | Working | Manage package cleanup |

## Pipeline Position

garbage is **not part of the main pipeline** — it is a **cleanup tool** for removing resources that are no longer needed.

## Current State

86 unit tests passing, integration tests ready. All 8 commands are implemented and working.
