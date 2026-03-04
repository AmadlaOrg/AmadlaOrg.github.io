# unravel

| Field | Value |
|-------|-------|
| **Purpose** | Debug and inspection tool — examines pipeline state and data flow between tools |
| **Module** | — |
| **Status** | Planned |
| **Repo** | [AmadlaOrg/unravel](https://github.com/AmadlaOrg/unravel) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `unravel inspect` | Planned | Inspect pipeline data at a given stage |
| `unravel settings` | Planned | Manage unravel configuration |

## Pipeline Position

unravel is **not part of the pipeline** — it is a **debugging tool** that can inspect the data flowing between any two stages.

## Intended Design

unravel will allow developers to examine what data is being passed between pipeline stages, helping diagnose issues with entity resolution, secret handling, template rendering, and audit results.

## Current Gaps

- Repository exists with a Makefile but minimal implementation
- No Go module definition confirmed
