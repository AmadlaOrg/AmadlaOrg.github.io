# Application/SNMP

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all SNMP applications |
| **Repo** | [AmadlaOrg/Entities/Application/SNMP](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/snmp@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the SNMP agent listens on |
| `listen_port` | integer | Port the SNMP agent listens on (default: `161`) |
| `version` | string | SNMP protocol version (`v2c` or `v3`) |
| `system_location` | string | Physical location of the system (sysLocation OID) |
| `system_contact` | string | Contact information for the system administrator (sysContact OID) |

These properties are common across all SNMP implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [SNMP/Net-SNMP](application-snmp-net-snmp.md) | Net-SNMP (snmpd) -- full-featured SNMP agent and toolkit | Standard on most Linux |

## Example

```yaml
_type: amadla.org/entity/application/snmp@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 161
  version: v3
  system_location: Data Center Rack A3
  system_contact: ops@example.com
```

## Consumers

| Tool | How It Uses Application/SNMP |
|------|------------------------------|
| lay | Installs the SNMP agent package (net-snmp) |
| weaver | Generates configuration files (snmpd.conf) |
| enjoin-service | Enables/starts the SNMP agent service |
