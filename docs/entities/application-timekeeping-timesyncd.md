# Application/Timekeeping/Timesyncd

| Field | Value |
|-------|-------|
| **Purpose** | systemd-timesyncd specific configuration — lightweight SNTP client built into systemd |
| **Repo** | [AmadlaOrg/Entities/Application/Timekeeping/Timesyncd](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/timekeeping/timesyncd@v1.0.0` |
| **Parent type** | [Application/Timekeeping](application-timekeeping.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `root_distance_max_sec` | number | Maximum acceptable root distance in seconds (default: `5`) |
| `poll_interval_min_sec` | integer | Minimum poll interval in seconds (default: `32`) |
| `poll_interval_max_sec` | integer | Maximum poll interval in seconds (default: `2048`) |
| `connection_retry_sec` | integer | Seconds to wait before retrying a failed connection (default: `30`) |
| `save_interval_sec` | integer | Interval for saving clock state to disk |

## Example

```yaml
_type: amadla.org/entity/application/timekeeping/timesyncd@v1.0.0
_extends: amadla.org/entity/application/timekeeping@v1.0.0
_body:
  servers:
    - time.google.com
    - time.cloudflare.com
  fallback_servers:
    - 0.pool.ntp.org
    - 1.pool.ntp.org
  root_distance_max_sec: 5
  poll_interval_min_sec: 32
  poll_interval_max_sec: 2048
```

## When to Use

- Already running systemd and only need basic SNTP (no serving time to others)
- Default on Ubuntu, Debian, Arch, and most systemd-based distros
- No need for NTP server functionality — timesyncd is client-only
- Lower resource footprint than chrony or ntpd

## Consumers

| Tool | How It Uses Application/Timekeeping/Timesyncd |
|------|----------------------------------------|
| enjoin | Configures `/etc/systemd/timesyncd.conf` |
| enjoin-service | Enables/starts `systemd-timesyncd` service |
