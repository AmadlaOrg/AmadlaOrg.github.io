# garbage

| Field | Value |
|-------|-------|
| **Purpose** | Trash/uninstall tool — tracks and removes what's no longer needed |
| **Repo** | [AmadlaOrg/garbage](https://github.com/AmadlaOrg/garbage) |

## Overview

garbage is a safe-removal tool that works like a trash can for infrastructure resources. Instead of permanently deleting packages, binaries, or entities, garbage moves them to a recoverable trash area. Items can be inspected, restored, or permanently purged.

This follows the principle that infrastructure changes should be reversible — if you remove a package or binary and something breaks, you can restore it without reinstalling from scratch.

## Commands

| Command | Description |
|---------|-------------|
| `garbage rm` | Remove/trash items |
| `garbage list` | List trashed items |
| `garbage restore` | Restore trashed items |
| `garbage empty` | Permanently delete trashed items |
| `garbage info` | Show information about trashed items |
| `garbage settings` | Manage garbage configuration |

Per-command sequence diagrams: [garbage Commands](garbage-commands.md).

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |

## Entity Types

| Entity | What garbage Does |
|--------|------------------|
| [Package](../entities/package.md) | Tracks and removes packages no longer needed |

## Pipeline Position

garbage is **not part of the main pipeline** — it is a **cleanup tool** for removing resources that are no longer needed.

```bash
# Remove a package safely (moves to trash)
garbage rm my-old-package

# See what's in the trash
garbage list

# Changed your mind? Restore it
garbage restore my-old-package

# Permanently delete everything in trash
garbage empty
```

## Example Usage

```bash
# Remove an old binary
garbage rm /usr/local/bin/old-tool

# List trashed files only
garbage list --type file

# Restore a specific trashed item (full or partial ID, or name)
garbage restore abc123

# Show details about a trashed item
garbage info abc123
```

## Current State

86 unit tests passing, integration tests ready. All 6 commands (`rm`, `list`, `restore`, `empty`, `info`, `settings`) are implemented and working.
