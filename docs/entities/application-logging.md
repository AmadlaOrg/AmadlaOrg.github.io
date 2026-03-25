# Application/Logging

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all logging systems |
| **Repo** | [AmadlaOrg/Entities/Application/Logging](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/logging@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `log_dir` | string | Primary log directory (e.g., `/var/log`) |
| `max_size` | string | Max log file size before rotation (e.g., `100M`, `1G`) |
| `retention_days` | integer | Number of days to keep logs before deletion |
| `compress` | boolean | Compress rotated log files (default: `true`) |
| `remote_target.host` | string | Remote syslog server hostname or IP |
| `remote_target.port` | integer | Remote syslog server port (default 514) |
| `remote_target.protocol` | string | Transport protocol for remote logging (`tcp`, `udp`, `relp`) |

These properties are common across all logging implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [Logging/Rsyslog](application-logging-rsyslog.md) | rsyslog — rocket-fast syslog processing |
| [Logging/SyslogNG](application-logging-syslog-ng.md) | syslog-ng — flexible log management |
| [Logging/Journald](application-logging-journald.md) | systemd-journald — binary structured logging |
| [Logging/Logrotate](application-logging-logrotate.md) | logrotate — log rotation utility |

## Example

```yaml
_type: amadla.org/entity/application/logging@v1.0.0
_body:
  log_dir: /var/log
  max_size: "100M"
  retention_days: 30
  compress: true
  remote_target:
    host: logserver.example.com
    port: 514
    protocol: tcp
```

## Consumers

| Tool | How It Uses Application/Logging |
|------|-------------------------------|
| [lay](../tools/lay.md) | Installs the logging application (rsyslog, syslog-ng, etc.) |
| enjoin-service | Enables/starts the logging service |
| [weaver](../tools/weaver.md) | Generates configuration files (rsyslog.conf, syslog-ng.conf) |
