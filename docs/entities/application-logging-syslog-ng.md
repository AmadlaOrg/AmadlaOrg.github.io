# Application/Logging/SyslogNG

| Field | Value |
|-------|-------|
| **Purpose** | Syslog-ng-specific configuration — flexible log management with advanced routing |
| **Repo** | [AmadlaOrg/Entities/Application/Logging/SyslogNG](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/logging/syslog-ng@v1.0.0` |
| **Parent type** | [Application/Logging](application-logging.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `sources` | array of objects | Syslog-ng source definitions |
| `sources[].name` | string | Source name identifier |
| `sources[].driver` | string | Source driver type (`system`, `network`, `file`) |
| `sources[].options` | object | Driver-specific options |
| `destinations` | array of objects | Syslog-ng destination definitions |
| `destinations[].name` | string | Destination name identifier |
| `destinations[].driver` | string | Destination driver type (`file`, `network`, `program`) |
| `destinations[].path` | string | File path for file driver |
| `destinations[].host` | string | Remote host for network driver |
| `filters` | array of objects | Syslog-ng filter definitions |
| `filters[].name` | string | Filter name identifier |
| `filters[].expression` | string | Filter expression (e.g., `facility(auth)`, `level(err..emerg)`) |
| `log_paths` | array of objects | Log paths connecting source to filter to destination |
| `log_paths[].source` | string | Source name reference |
| `log_paths[].filter` | string | Filter name reference |
| `log_paths[].destination` | string | Destination name reference |

## Example

```yaml
_type: amadla.org/entity/application/logging/syslog-ng@v1.0.0
_extends: amadla.org/entity/application/logging@v1.0.0
_body:
  log_dir: /var/log
  retention_days: 30
  sources:
    - name: s_local
      driver: system
    - name: s_network
      driver: network
      options:
        transport: tcp
        port: 514
  filters:
    - name: f_auth
      expression: "facility(auth)"
    - name: f_error
      expression: "level(err..emerg)"
  destinations:
    - name: d_auth
      driver: file
      path: /var/log/auth.log
    - name: d_remote
      driver: network
      host: logserver.example.com
  log_paths:
    - source: s_local
      filter: f_auth
      destination: d_auth
```

## Consumers

| Tool | How It Uses Application/Logging/SyslogNG |
|------|------------------------------------------|
| [lay](../tools/lay.md) | Installs the `syslog-ng` package |
| [weaver](../tools/weaver.md) | Generates `/etc/syslog-ng/syslog-ng.conf` |
| enjoin-service | Enables/starts `syslog-ng` service |
