# Application/Logging/Logrotate

| Field | Value |
|-------|-------|
| **Purpose** | Logrotate-specific configuration — ubiquitous log rotation utility |
| **Repo** | [AmadlaOrg/Entities/Application/Logging/Logrotate](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/logging/logrotate@v1.0.0` |
| **Parent type** | [Application/Logging](application-logging.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `frequency` | string | Global rotation frequency (`daily`, `weekly`, `monthly`) |
| `rotate` | integer | Number of rotated log files to keep |
| `configs` | array of objects | Per-path logrotate configurations |
| `configs[].path` | string | Log file path or glob pattern (e.g., `/var/log/nginx/*.log`) |
| `configs[].frequency` | string | Rotation frequency for this path (`daily`, `weekly`, `monthly`) |
| `configs[].rotate` | integer | Number of rotated files to keep for this path |
| `configs[].compress` | boolean | Compress rotated files |
| `configs[].missingok` | boolean | Do not error if the log file is missing |
| `configs[].notifempty` | boolean | Do not rotate if the log file is empty |
| `configs[].create.mode` | string | File permissions (e.g., `0640`) |
| `configs[].create.owner` | string | File owner |
| `configs[].create.group` | string | File group |
| `configs[].postrotate` | string | Script to run after rotation (e.g., `systemctl reload nginx`) |

## Example

```yaml
_type: amadla.org/entity/application/logging/logrotate@v1.0.0
_extends: amadla.org/entity/application/logging@v1.0.0
_body:
  compress: true
  frequency: weekly
  rotate: 4
  configs:
    - path: /var/log/nginx/*.log
      frequency: daily
      rotate: 14
      compress: true
      missingok: true
      notifempty: true
      create:
        mode: "0640"
        owner: www-data
        group: adm
      postrotate: "systemctl reload nginx"
    - path: /var/log/app/*.log
      frequency: daily
      rotate: 7
      compress: true
```

## Consumers

| Tool | How It Uses Application/Logging/Logrotate |
|------|-------------------------------------------|
| [lay](../tools/lay.md) | Installs the `logrotate` package |
| [weaver](../tools/weaver.md) | Generates `/etc/logrotate.conf` and `/etc/logrotate.d/*.conf` |
| enjoin-service | Ensures logrotate cron/timer is active |
