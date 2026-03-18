# Application/Logging/Rsyslog

| Field | Value |
|-------|-------|
| **Purpose** | Rsyslog-specific configuration — rocket-fast system logging, default on Debian/Ubuntu |
| **Repo** | [AmadlaOrg/Entities/Application/Logging/Rsyslog](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/logging/rsyslog@v1.0.0` |
| **Parent type** | [Application/Logging](application-logging.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `modules` | array of strings | Rsyslog modules to load (e.g., `imuxsock`, `imjournal`, `imtcp`, `imudp`, `imfile`) |
| `rules` | array of objects | Facility.severity to destination routing rules |
| `rules[].selector` | string | Syslog selector (e.g., `auth,authpriv.*`, `*.info;mail.none`) |
| `rules[].destination` | string | Log destination (e.g., `/var/log/auth.log`, `@@remote:514`) |
| `templates` | array of objects | Custom rsyslog log format templates |
| `templates[].name` | string | Template name |
| `templates[].format` | string | Template format string |
| `work_directory` | string | Spool/work directory for rsyslog (e.g., `/var/spool/rsyslog`) |

## Example

```yaml
_type: amadla.org/entity/application/logging/rsyslog@v1.0.0
_extends: amadla.org/entity/application/logging@v1.0.0
_body:
  log_dir: /var/log
  retention_days: 30
  compress: true
  modules:
    - imuxsock
    - imjournal
    - imtcp
  rules:
    - selector: "auth,authpriv.*"
      destination: /var/log/auth.log
    - selector: "*.info;mail.none;authpriv.none"
      destination: /var/log/messages
  work_directory: /var/spool/rsyslog
  remote_target:
    host: logserver.example.com
    port: 514
    protocol: tcp
```

## Consumers

| Tool | How It Uses Application/Logging/Rsyslog |
|------|----------------------------------------|
| lay | Installs the `rsyslog` package |
| weaver | Generates `/etc/rsyslog.conf` and `/etc/rsyslog.d/*.conf` |
| enjoin-service | Enables/starts `rsyslog` service |
