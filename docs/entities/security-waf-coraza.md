# Security/WAF/Coraza

| Field | Value |
|-------|-------|
| **Purpose** | Coraza-specific configuration — Go-native WAF compatible with ModSecurity rules |
| **Repo** | [AmadlaOrg/Entities/Security/WAF/Coraza](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/security/waf/coraza@v1.0.0` |
| **Parent type** | [Security/WAF](security-waf.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `directives` | object | Key-value Coraza directives |
| `rules` | array of strings | Inline SecRule directives |
| `rules_files` | array of strings | Paths to rule files to include |
| `crs_enabled` | boolean | Whether to enable OWASP Core Rule Set |
| `crs_paranoia_level` | integer | OWASP CRS paranoia level (1 = low, 4 = high) |

## Example

```yaml
_type: amadla.org/entity/security/waf/coraza@v1.0.0
_extends: amadla.org/entity/security/waf@v1.0.0
_body:
  mode: prevention
  rule_sets:
    - owasp-crs-4.0
  directives:
    SecRequestBodyAccess: "On"
    SecResponseBodyAccess: "Off"
    SecRequestBodyLimit: "13107200"
  rules:
    - "SecRule REQUEST_URI \"@streq /admin\" \"id:1001,phase:1,deny,status:403\""
  rules_files:
    - /etc/coraza/custom-rules.conf
  crs_enabled: true
  crs_paranoia_level: 2
  audit_log:
    enabled: true
    path: /var/log/coraza/audit.log
    format: json
  excluded_paths:
    - /health
    - /metrics
```

## Consumers

| Tool | How It Uses Security/WAF/Coraza |
|------|----------------------------------|
| [enjoin](../tools/enjoin.md) | Configures Coraza WAF and loads rule sets |
| [weaver](../tools/weaver.md) | Generates Coraza configuration files |
| [judge](../tools/judge.md) | Validates Coraza rules and tests for bypasses |
