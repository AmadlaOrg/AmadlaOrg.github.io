# Judge Plugins

Judge plugins validate whether a system's actual state matches the requirements declared in [HERY](../architecture/hery-concepts.md) entities. Each plugin specializes in a specific entity type.

## Plugin Inventory

| Plugin | Validates | Entity |
|--------|-----------|--------|
| `judge-application` | Whether required apps/packages are installed | Application |
| `judge-system` | System-level requirements (OS, kernel, resources) | System |
| `judge-infrastructure` | Infrastructure requirements (networking, storage) | Infrastructure |

## Protocol

Judge plugins follow the standard [Plugin Protocol](../architecture/plugin-system.md):

```bash
# Plugin metadata — declares which entity types are supported
judge-application info
# {"name": "judge-application", "version": "1.0.0", "supports": ["amadla.org/entity/application@^v1.0.0"], ...}

# Validate an entity (stdin -> stdout)
cat application.yaml | judge-application validate
# {"status": "pass", "details": {...}}
# Exit code: 0 = pass, 1 = fail
```

### Multi-Plugin Routing

When judge receives an entity, it discovers all `judge-*` plugins on PATH that support that entity type. If multiple plugins match, **all are called** — they may validate different aspects (e.g., `judge-application` checks packages, `judge-security` checks vulnerabilities). The overall verdict is **fail if ANY plugin fails**.

## Go Framework (Optional)

**LibraryJudgeFramework** provides convenience wrappers for Go plugin authors:

- Standard audit check interface
- Pass/fail reporting with details
- Entity-to-audit-rule mapping
- Table-formatted CLI output

Plugins can also be written in any other language — just implement the protocol.

## Reference Implementation

`judge-application` is the reference judge plugin:

- **Dependencies:** LibraryJudgeFramework, LibraryUtils
- **Entity:** Reads `Application` to determine what should be installed, then checks the system

## Workflow

```
Entity requirements -> judge -> judge-* plugin (via stdin/stdout) -> pass/fail + details -> aggregated result
```

Each plugin:

1. Receives entity data on stdin
2. Checks the actual system state against the entity requirements
3. Outputs pass/fail results with details to stdout
4. Returns exit code 0 (pass) or 1 (fail)
5. judge aggregates results from all matching plugins
