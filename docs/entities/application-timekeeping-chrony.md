# Application/Timekeeping/Chrony

| Field | Value |
|-------|-------|
| **Purpose** | Chrony-specific configuration — modern NTP replacement, default on RHEL/Fedora/CentOS |
| **Repo** | [AmadlaOrg/Entities/Application/Timekeeping/Chrony](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/timekeeping/chrony@v1.0.0` |
| **Parent type** | [Application/Timekeeping](application-timekeeping.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `makestep.threshold` | number | Seconds threshold for a step adjustment (e.g., `1.0`) |
| `makestep.limit` | integer | Max step adjustments after start (`3` is common, `-1` for unlimited) |
| `rtcsync` | boolean | Sync system clock to hardware clock (default: `true`) |
| `driftfile` | string | Path to drift file (default: `/var/lib/chrony/drift`) |
| `keyfile` | string | Path to key file for NTP authentication |
| `logdir` | string | Log directory (default: `/var/log/chrony`) |
| `allow` | array of strings | Networks allowed to use this machine as NTP server |
| `deny` | array of strings | Networks denied from using this machine as NTP server |
| `local_stratum` | integer | Serve time locally even when not synchronized (stratum value) |
| `leapsectz` | string | Timezone database for leap second handling (e.g., `right/UTC`) |

## Example

```yaml
_type: amadla.org/entity/application/timekeeping/chrony@v1.0.0
_extends: amadla.org/entity/application/timekeeping@v1.0.0
_body:
  pools:
    - 0.pool.ntp.org
    - 1.pool.ntp.org
  servers:
    - time.google.com
  preferred: time.google.com
  makestep:
    threshold: 1.0
    limit: 3
  rtcsync: true
  driftfile: /var/lib/chrony/drift
  logdir: /var/log/chrony
  allow:
    - 192.168.0.0/16
  leapsectz: right/UTC
```

## Why Chrony Over NTP

- Faster initial synchronization
- Better performance on intermittent connections (laptops, VMs)
- Lower memory and CPU usage
- Handles large clock offsets gracefully (`makestep`)
- Default on RHEL 7+, Fedora, CentOS, Amazon Linux 2

## Consumers

| Tool | How It Uses Application/Timekeeping/Chrony |
|------|-------------------------------------|
| lay | Installs the `chrony` package |
| weaver | Generates `/etc/chrony.conf` |
| enjoin-service | Enables/starts `chronyd` service |
