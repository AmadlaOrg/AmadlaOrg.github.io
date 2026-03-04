# Auditor Plugins

Auditors are plugins for **judge** that check whether a system's actual state matches the requirements declared in HERY entities.

## Auditor Inventory

| Plugin | Audits | Entity | Status |
|--------|--------|--------|--------|
| `auditor-application` | Whether required apps/packages are installed | EntityApplication | Active (Go) |
| `auditor-system` | System-level requirements (OS, kernel, resources) | EntitySystem | Stub |
| `auditor-infrastructure` | Infrastructure requirements (networking, storage) | EntityInfrastructure | Stub |

## Framework

Auditor plugins use **LibraryAuditFramework**, which provides:

- Standard audit check interface
- Compliance reporting format (pass/fail per check)
- Entity-to-audit-rule mapping
- Table-formatted CLI output

## Reference Implementation

`auditor-application` is the reference auditor plugin:

- **Module:** `github.com/AmadlaOrg/auditor-application`
- **Go Version:** 1.23.3
- **Dependencies:** LibraryAuditFramework, LibraryUtils
- **Entity:** Reads `EntityApplication` to determine what should be installed, then checks the system

## Intended Workflow

```
Entity requirements → judge → auditor plugin → compliance report
```

Each auditor:

1. Receives entity requirements from judge
2. Checks the actual system state
3. Returns pass/fail results per requirement
4. judge aggregates results into a unified compliance report
