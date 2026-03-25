# Security/WAF/ModSecurity

| Field | Value |
|-------|-------|
| **Purpose** | ModSecurity-specific configuration — widely deployed WAF engine for Apache/Nginx |
| **Repo** | [AmadlaOrg/Entities/Security/WAF/ModSecurity](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/security/waf/modsecurity@v1.0.0` |
| **Parent type** | [Security/WAF](security-waf.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `sec_rule_engine` | string | SecRuleEngine directive (`On`, `Off`, `DetectionOnly`) |
| `sec_request_body_access` | boolean | Whether to inspect request bodies |
| `sec_response_body_access` | boolean | Whether to inspect response bodies |
| `sec_request_body_limit` | integer | Maximum request body size in bytes |
| `sec_audit_log_parts` | string | Audit log parts to include (e.g., `ABCFHZ`) |
| `sec_pcre_match_limit` | integer | PCRE match limit to prevent ReDoS |
| `sec_pcre_match_limit_recursion` | integer | PCRE match limit recursion to prevent ReDoS |
| `crs_paranoia_level` | integer | OWASP CRS paranoia level (1 = low, 4 = high) |
| `crs_exclusions` | array of strings | Application-specific CRS exclusion profiles (e.g., `wordpress`, `drupal`, `nextcloud`) |

## Example

```yaml
_type: amadla.org/entity/security/waf/modsecurity@v1.0.0
_extends: amadla.org/entity/security/waf@v1.0.0
_body:
  mode: prevention
  rule_sets:
    - owasp-crs-4.0
  sec_rule_engine: "On"
  sec_request_body_access: true
  sec_response_body_access: false
  sec_request_body_limit: 13107200
  sec_audit_log_parts: ABCFHZ
  sec_pcre_match_limit: 500000
  sec_pcre_match_limit_recursion: 500000
  crs_paranoia_level: 2
  crs_exclusions:
    - wordpress
  audit_log:
    enabled: true
    path: /var/log/modsec/audit.log
    format: json
  excluded_paths:
    - /health
```

## Consumers

| Tool | How It Uses Security/WAF/ModSecurity |
|------|---------------------------------------|
| [enjoin](../tools/enjoin.md) | Configures ModSecurity module and loads CRS rules |
| [weaver](../tools/weaver.md) | Generates `modsecurity.conf` and CRS configuration |
| [judge](../tools/judge.md) | Validates ModSecurity rules and tests for bypasses |
