# Security/WAF

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all Web Application Firewall implementations |
| **Repo** | [AmadlaOrg/Entities/Security/WAF](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/security/waf@v1.0.0` |
| **Parent type** | [Security](security.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `mode` | string | Operating mode: `detection` (log only) or `prevention` (actively block) |
| `rule_sets` | array of strings | Rule sets to load (e.g., OWASP CRS) |
| `audit_log.enabled` | boolean | Whether audit logging is enabled |
| `audit_log.path` | string | Path to the audit log file |
| `audit_log.format` | string | Audit log format (`json`, `native`) |
| `excluded_paths` | array of strings | URL paths to skip WAF scanning |

These properties are common across all WAF implementations. Sub-types add engine-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [WAF/ModSecurity](security-waf-modsecurity.md) | ModSecurity — widely deployed WAF engine for Apache/Nginx |
| [WAF/Coraza](security-waf-coraza.md) | Coraza — Go-native WAF compatible with ModSecurity rules |

## Example

```yaml
_type: amadla.org/entity/security/waf@v1.0.0
_body:
  mode: prevention
  rule_sets:
    - owasp-crs-4.0
  audit_log:
    enabled: true
    path: /var/log/waf/audit.log
    format: json
  excluded_paths:
    - /health
    - /metrics
```

## Consumers

| Tool | How It Uses Security/WAF |
|------|--------------------------|
| [enjoin](../tools/enjoin.md) | Configures WAF engine and loads rule sets |
| [judge](../tools/judge.md) | Validates WAF rules and tests for bypasses |
