# Application/SNMP/Net-SNMP

| Field | Value |
|-------|-------|
| **Purpose** | Net-SNMP-specific configuration -- full-featured SNMP agent, toolkit, and extensible monitoring |
| **Repo** | [AmadlaOrg/Entities/Application/SNMP/NetSNMP](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/snmp/net-snmp@v1.0.0` |
| **Parent type** | [Application/SNMP](application-snmp.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `community` | string | SNMPv2c community string (e.g., `public`) |
| `community_secret` | string | Doorman secret reference for the community string |
| `views` | array of objects | SNMP view definitions for access control |
| `views[].name` | string | View name |
| `views[].type` | string | Whether the OID subtree is `included` or `excluded` |
| `views[].oid` | string | OID subtree (e.g., `.1.3.6.1.2.1`) |
| `groups` | array of objects | SNMP group definitions mapping security models to views |
| `groups[].name` | string | Group name |
| `groups[].version` | string | Security model version (e.g., `v2c`, `usm`) |
| `groups[].access` | string | Access level (`readonly` or `readwrite`) |
| `users` | array of objects | SNMPv3 user definitions |
| `users[].name` | string | Username |
| `users[].auth_protocol` | string | Authentication protocol (`MD5`, `SHA`, `SHA256`) |
| `users[].auth_pass_secret` | string | Doorman secret reference for the authentication passphrase |
| `users[].priv_protocol` | string | Privacy (encryption) protocol (`DES`, `AES`, `AES256`) |
| `users[].priv_pass_secret` | string | Doorman secret reference for the privacy passphrase |
| `disk_monitors` | array of objects | Disk space monitoring definitions |
| `disk_monitors[].path` | string | Filesystem path to monitor |
| `disk_monitors[].min_space` | string | Minimum free space threshold (e.g., `10%`, `100MB`) |
| `process_monitors` | array of objects | Process monitoring definitions |
| `process_monitors[].name` | string | Process name to monitor |
| `process_monitors[].min` | integer | Minimum number of expected instances |
| `process_monitors[].max` | integer | Maximum number of expected instances |
| `extend_scripts` | array of objects | Custom extend scripts for additional monitoring |
| `extend_scripts[].name` | string | Script name (used as OID label) |
| `extend_scripts[].command` | string | Command to execute |

## Example

```yaml
_type: amadla.org/entity/application/snmp/net-snmp@v1.0.0
_extends: amadla.org/entity/application/snmp@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 161
  version: v3
  system_location: Data Center Rack A3
  system_contact: ops@example.com
  community_secret: doorman://vault/snmp/community
  views:
    - name: systemview
      type: included
      oid: .1.3.6.1.2.1
  groups:
    - name: readgroup
      version: usm
      access: readonly
  users:
    - name: monitor
      auth_protocol: SHA256
      auth_pass_secret: doorman://vault/snmp/monitor-auth
      priv_protocol: AES256
      priv_pass_secret: doorman://vault/snmp/monitor-priv
  disk_monitors:
    - path: /
      min_space: 10%
    - path: /var
      min_space: 5%
  process_monitors:
    - name: sshd
      min: 1
      max: 1
    - name: nginx
      min: 1
      max: 10
  extend_scripts:
    - name: check_disk_io
      command: /usr/local/bin/check_disk_io.sh
```

## Consumers

| Tool | How It Uses Application/SNMP/Net-SNMP |
|------|---------------------------------------|
| [lay](../tools/lay.md) | Installs the `net-snmp` package |
| [weaver](../tools/weaver.md) | Generates `/etc/snmp/snmpd.conf` |
| enjoin-service | Enables/starts `snmpd` service |
