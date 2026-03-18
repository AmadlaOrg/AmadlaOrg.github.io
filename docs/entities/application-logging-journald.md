# Application/Logging/Journald

| Field | Value |
|-------|-------|
| **Purpose** | Systemd-journald-specific configuration — binary structured logging, default on systemd distros |
| **Repo** | [AmadlaOrg/Entities/Application/Logging/Journald](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/logging/journald@v1.0.0` |
| **Parent type** | [Application/Logging](application-logging.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `storage` | string | Where to store journal data (`volatile`, `persistent`, `auto`, `none`) |
| `system_max_use` | string | Max disk usage for journal files (e.g., `500M`, `2G`) |
| `system_max_file_size` | string | Max size of individual journal files (e.g., `50M`) |
| `max_retention_sec` | string | Max retention time for journal entries (e.g., `1month`, `2week`) |
| `forward_to_syslog` | boolean | Forward journal messages to syslog |
| `forward_to_wall` | boolean | Forward emergency messages to wall |
| `rate_limit_interval_sec` | integer | Rate limiting interval in seconds |
| `rate_limit_burst` | integer | Maximum number of messages per rate limit interval |

## Example

```yaml
_type: amadla.org/entity/application/logging/journald@v1.0.0
_extends: amadla.org/entity/application/logging@v1.0.0
_body:
  compress: true
  storage: persistent
  system_max_use: "2G"
  system_max_file_size: "50M"
  max_retention_sec: "1month"
  forward_to_syslog: false
  forward_to_wall: true
  rate_limit_interval_sec: 30
  rate_limit_burst: 10000
```

## Consumers

| Tool | How It Uses Application/Logging/Journald |
|------|------------------------------------------|
| lay | Ensures `systemd-journald` is present (typically built-in) |
| weaver | Generates `/etc/systemd/journald.conf` |
| enjoin-service | Restarts `systemd-journald` to apply configuration |
