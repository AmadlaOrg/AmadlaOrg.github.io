# dryrun

| Field | Value |
|-------|-------|
| **Purpose** | Safely tests settings by applying them and auto-reverting if something goes wrong |
| **Repo** | [AmadlaOrg/dryrun](https://github.com/AmadlaOrg/dryrun) |
| **Language** | Python (may move to Go) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `dryrun run` | Planned | Apply settings temporarily and auto-revert on failure or timeout |
| `dryrun settings` | Planned | Manage dryrun configuration |

## Pipeline Position

dryrun is **not part of the main pipeline** — it is a **safety tool** that tests settings before committing to them.

## Intended Design

dryrun applies a setting or configuration change and then automatically reverts it if something goes wrong. The primary use case is preventing SSH lockout when modifying network or firewall settings remotely.

### Use Cases

- **SSH safety:** Apply network/firewall settings, verify SSH still works, revert if connection is lost
- **Temporary settings:** Try an OS setting temporarily to verify behavior before making it permanent

## Current Gaps

- Repository exists with a README but minimal implementation
- Currently Python, may move to Go
