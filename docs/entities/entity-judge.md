# EntityJudge

| Field | Value |
|-------|-------|
| **Purpose** | Defines audit rules — what compliance checks to run and their expected outcomes |
| **Repo** | [AmadlaOrg/EntityJudge](https://github.com/AmadlaOrg/EntityJudge) |
| **Entity URI** | `github.com/AmadlaOrg/EntityJudge@v1.0.0` |

## Schema

EntityJudge describes audit rule definitions:

- Audit check type
- Expected state
- Severity level
- Remediation hints

## Example

```yaml
_entity: github.com/AmadlaOrg/EntityJudge@v1.0.0
_body:
  check: package-installed
  target: nginx
  expected: present
  severity: critical
```

## Consumers

| Tool | How It Uses EntityJudge |
|------|-------------------------|
| judge | Reads audit rules and dispatches to appropriate auditor plugins |
