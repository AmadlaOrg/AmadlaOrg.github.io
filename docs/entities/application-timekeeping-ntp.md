# Application/Timekeeping/NTP

| Field | Value |
|-------|-------|
| **Purpose** | NTP daemon (ntpd) specific configuration |
| **Repo** | [AmadlaOrg/Entities/Application/Timekeeping/NTP](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/timekeeping/ntp@v1.0.0` |
| **Parent type** | [Application/Timekeeping](application-timekeeping.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `restrict` | array | Access control restrictions (ntp.conf `restrict` directives) |
| `restrict[].address` | string | IP address or `default` |
| `restrict[].mask` | string | Netmask |
| `restrict[].options` | array of strings | Flags: `nomodify`, `notrap`, `nopeer`, `noquery` |
| `driftfile` | string | Path to drift file (default: `/var/lib/ntp/drift`) |
| `statsdir` | string | Directory for statistics files |
| `leapfile` | string | Path to leap seconds file |
| `broadcast` | array of strings | Broadcast addresses for NTP broadcast mode |
| `disable_monitor` | boolean | Disable monlist to prevent amplification attacks (default: `true`) |

## Example

```yaml
_type: amadla.org/entity/application/timekeeping/ntp@v1.0.0
_extends: amadla.org/entity/application/timekeeping@v1.0.0
_body:
  servers:
    - 0.pool.ntp.org
    - 1.pool.ntp.org
  driftfile: /var/lib/ntp/drift
  disable_monitor: true
  restrict:
    - address: default
      options: [nomodify, notrap, nopeer, noquery]
    - address: 127.0.0.1
    - address: "::1"
  leapfile: /usr/share/zoneinfo/leap-seconds.list
```

## Consumers

| Tool | How It Uses Application/Timekeeping/NTP |
|------|----------------------------------|
| [lay](../tools/lay.md) | Installs the `ntp` package |
| [weaver](../tools/weaver.md) | Generates `/etc/ntp.conf` |
| enjoin-service | Enables/starts `ntpd` service |
