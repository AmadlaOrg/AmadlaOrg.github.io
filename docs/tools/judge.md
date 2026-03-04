# judge

| Field | Value |
|-------|-------|
| **Purpose** | Auditing orchestrator — runs auditor plugins to verify system state matches entity requirements |
| **Module** | — |
| **Status** | Planned |
| **Repo** | [AmadlaOrg/judge](https://github.com/AmadlaOrg/judge) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `judge audit` | Planned | Run auditors against entity requirements |
| `judge settings` | Planned | Manage judge configuration |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |
| LibraryAuditFramework | Auditor plugin loading and communication |

## Pipeline Position

judge is the **final stage** in the pipeline. It checks whether the actual system state matches what was declared in the entities.

```
hery → doorman → raise → lay → weaver → [judge]
                                            │
                                   ┌────────┴─────────┐
                                   │ Auditor Plugins  │
                                   │ (application,    │
                                   │  system,         │
                                   │  infrastructure) │
                                   └──────────────────┘
```

## Intended Design

judge will orchestrate **auditor plugins** that each check a specific domain:

- `auditor-application` — Checks whether required apps/packages are installed
- `auditor-system` — Checks system-level requirements (OS, kernel, resources)
- `auditor-infrastructure` — Checks infrastructure requirements (networking, storage)

Output will be a compliance report: pass/fail per requirement, with details on failures.

## Current Gaps

- Repository exists as a stub only
- No Go code or module definition
- EntityJudge schema exists but no tool to consume it
