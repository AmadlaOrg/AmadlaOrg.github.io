# Judge

| Field | Value |
|-------|-------|
| **Purpose** | Defines audit rules — what compliance checks to run and their expected outcomes |
| **Repo** | [AmadlaOrg/Entities/Judge](https://github.com/AmadlaOrg/Entities/Judge) |
| **Entity URI** | `amadla.org/entity/judge@v1.0.0` |

## Schema

Judge describes audit rule definitions:

- Audit check type
- Expected state
- Severity level
- Remediation hints

## Example

```yaml
_type: amadla.org/entity/judge@v1.0.0
_body:
  check: package-installed
  target: nginx
  expected: present
  severity: critical
```

## Consumers

| Tool | How It Uses Judge |
|------|-------------------------|
| judge | Reads audit rules and dispatches to appropriate judge plugins |
