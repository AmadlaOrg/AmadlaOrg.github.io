# judge

| Field | Value |
|-------|-------|
| **Purpose** | Validation — compares "what IS" (unravel) vs "what SHOULD BE" (hery), outputs judge entity (diff) |
| **Module** | — |
| **Status** | Early |
| **Repo** | [AmadlaOrg/judge](https://github.com/AmadlaOrg/judge) |

## Overview

judge takes two inputs: the expected state (from hery entities) and the actual state (from unravel). It compares them and outputs an judge entity — a diff in entity format that communicates whether the environment matches expectations and which parts are wrong.

judge supports both **generic deep diff** (works with any entity type) and **type-aware plugins** (auditors that understand the semantics of specific entity types, e.g., a network auditor that knows port equivalences).

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `judge audit` | Early | Compare expected vs actual state, output judge entity |
| `judge settings` | Planned | Manage judge configuration |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |
| LibraryJudgeFramework | Judge plugin loading and communication |

## Pipeline Position

judge is typically the **final validation stage**. Combined with unravel for drift detection:

```bash
# Drift detection: compare expected vs actual
unravel discover --type network | judge audit

# Reconciliation loop (on cron/systemd timer)
unravel discover | judge audit
```

## How It Works

```
hery query --type network        →  "what SHOULD BE" entity
unravel discover --type network  →  "what IS" entity
                                          │
                                    judge audit
                                          │
                                    judge entity (diff)
```

Example: you expect ports 80 and 443 open. unravel reports ports 80, 443, and 8080 are open. judge outputs:

```yaml
_type: amadla.org/entity/Auditor@v1.0.0
_body:
  status: fail
  entity_type: network
  differences:
    - path: "_body.ports"
      expected: [80, 443]
      actual: [80, 443, 8080]
      severity: warning
      message: "unexpected port 8080 open"
```

This judge entity can then pipe to lighthouse for alerting:

```bash
unravel discover | judge audit | lighthouse notify
```

## Judge Plugins

Each judge plugin understands the semantics of a specific entity type:

| Plugin | Audits | Status |
|--------|--------|--------|
| `judge-application` | Whether required apps/packages are installed | Active (Go) |
| `judge-system` | System-level requirements (OS, kernel, resources) | Stub |
| `judge-infrastructure` | Infrastructure requirements (networking, storage) | Stub |

Plugins are discovered via PATH (`judge-*` naming convention). Each plugin declares supported entity types via its `info` subcommand. If multiple plugins support the same entity type, **all are called** — they may validate different aspects. Overall verdict: fail if ANY plugin fails.

## Current Gaps

- Repository exists in early development
- Auditor entity schema not yet finalized
- Generic diff engine not yet implemented
- Type-aware plugin integration not yet started
