# dryrun

| Field | Value |
|-------|-------|
| **Purpose** | Safely tests settings by applying them and auto-reverting if something goes wrong |
| **Repo** | [AmadlaOrg/dryrun](https://github.com/AmadlaOrg/dryrun) |
| **Language** | Python (may move to Go) |

## Overview

dryrun is a safety net for dangerous configuration changes. It applies a change, waits for confirmation (or a timeout), and automatically reverts if something goes wrong. The classic use case: you're SSH'd into a remote server and change a firewall rule that blocks your own connection — dryrun reverts the change before you're locked out.

Think of it like the "Keep this display setting?" dialog after changing your monitor resolution — if you don't confirm within a timeout, it reverts automatically.

## Commands

| Command | Description |
|---------|-------------|
| `dryrun run` | Apply settings temporarily and auto-revert on failure or timeout |
| `dryrun settings` | Manage dryrun configuration |

## Pipeline Position

dryrun is **not part of the main pipeline** — it is a **safety tool** that wraps other tools to test changes before committing.

```bash
# Safely test a firewall change via enjoin
dryrun run -- enjoin apply --from firewall -f new-rules.yaml

# Safely test network configuration
dryrun run --timeout 30s -- enjoin apply --from network -f network.yaml
```

## How It Works

1. **Snapshot** — capture current state before applying changes
2. **Apply** — execute the wrapped command
3. **Wait** — wait for user confirmation or timeout
4. **Confirm or revert** — if confirmed, keep the changes; if timeout or failure, revert to snapshot

## Use Cases

- **SSH safety:** Apply network/firewall settings, verify SSH still works, revert if connection is lost
- **Temporary settings:** Try an OS setting temporarily to verify behavior before making it permanent
- **Pipeline safety:** Wrap [enjoin](enjoin.md) or [weaver](weaver.md) commands during initial deployment testing

## Current Gaps

- Repository exists with a README but minimal implementation
- Currently Python, may move to Go
