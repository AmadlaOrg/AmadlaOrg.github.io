# dryrun

| Field | Value |
|-------|-------|
| **Purpose** | Dry run tool — tests settings and configuration files, useful for testing network configurations |
| **Module** | — |
| **Status** | Planned |
| **Repo** | [AmadlaOrg/dryrun](https://github.com/AmadlaOrg/dryrun) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `dryrun run` | Planned | Execute a dry run against settings and configuration files |
| `dryrun settings` | Planned | Manage dryrun configuration |

## Pipeline Position

dryrun is **not part of the main pipeline** — it is a **validation tool** that tests settings and configuration files before they are applied, particularly useful for verifying network configurations.

## Intended Design

dryrun will allow operators to validate configuration files and settings without applying them to live systems. This is especially valuable for network configurations where mistakes can cause outages.

## Current Gaps

- Repository exists with a README but minimal implementation
- No Go module definition confirmed
