# Application/Timekeeping

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all time synchronization applications |
| **Repo** | [AmadlaOrg/Entities/Application/Timekeeping](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/timekeeping@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `servers` | array of strings | Time server addresses (e.g., `time.google.com`) |
| `pools` | array of strings | Pool addresses resolved to multiple servers (e.g., `pool.ntp.org`) |
| `fallback_servers` | array of strings | Fallback servers when primary are unreachable |
| `enabled` | boolean | Whether time synchronization is active (default: `true`) |
| `preferred` | string | Preferred server (marked with `prefer` option) |

These properties are common across all time sync implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [Time/NTP](application-timekeeping-ntp.md) | ntpd — classic NTP daemon |
| [Time/Chrony](application-timekeeping-chrony.md) | chrony — modern NTP replacement |
| [Time/Timesyncd](application-timekeeping-timesyncd.md) | systemd-timesyncd — lightweight SNTP client |
| [Time/OpenNTPD](application-timekeeping-openntpd.md) | OpenNTPD — BSD-origin, simpler than ntpd |
| [Time/PTP](application-timekeeping-ptp.md) | linuxptp — Precision Time Protocol, sub-microsecond |

## Example

```yaml
_type: amadla.org/entity/application/timekeeping@v1.0.0
_body:
  enabled: true
  pools:
    - 0.pool.ntp.org
    - 1.pool.ntp.org
  servers:
    - time.google.com
    - time.cloudflare.com
  fallback_servers:
    - time.nist.gov
  preferred: time.google.com
```

## Relationship to System Entity

The [System](system.md) entity declares the **timezone** (e.g., `UTC`, `America/New_York`) — a global system setting. Application/Timekeeping declares **how the clock stays synchronized** — which is an application concern (installing and configuring ntpd, chrony, etc.).

## Consumers

| Tool | How It Uses Application/Timekeeping |
|------|------------------------------|
| [lay](../tools/lay.md) | Installs the time sync application (ntpd, chrony, etc.) |
| enjoin-service | Enables/starts the time sync service |
| [weaver](../tools/weaver.md) | Generates configuration files (ntp.conf, chrony.conf) |
