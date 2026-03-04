# waiter

| Field | Value |
|-------|-------|
| **Purpose** | Pipeline orchestrator — sequences tool execution across the full Amadla pipeline |
| **Module** | — |
| **Status** | Planned |
| **Repo** | [AmadlaOrg/waiter](https://github.com/AmadlaOrg/waiter) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `waiter run` | Planned | Execute the full pipeline or a subset of stages |
| `waiter settings` | Planned | Manage waiter configuration |

## Pipeline Position

waiter is **not part of the pipeline** — it **orchestrates** the pipeline. It manages the execution sequence, handles errors, and coordinates retries.

```
              ┌──────────────────────────────────────────┐
              │              waiter                       │
              │ (orchestrates execution of all stages)    │
              └──────────────────────────────────────────┘
                │        │        │       │       │      │
              hery → doorman → raise → lay → weaver → judge
```

## Intended Design

waiter will provide a way to run the full pipeline (or subsets) with a single command, handling stage sequencing, error recovery, and partial re-runs.

## Current Gaps

- Repository exists as a stub only
- No Go code or module definition
