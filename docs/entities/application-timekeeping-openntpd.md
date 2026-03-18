# Application/Timekeeping/OpenNTPD

| Field | Value |
|-------|-------|
| **Purpose** | OpenNTPD specific configuration — BSD-origin NTP implementation, simpler than ntpd |
| **Repo** | [AmadlaOrg/Entities/Application/Timekeeping/OpenNTPD](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/timekeeping/openntpd@v1.0.0` |
| **Parent type** | [Application/Timekeeping](application-timekeeping.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_on` | array of strings | Addresses to listen on for NTP queries (e.g., `*`, `127.0.0.1`) |
| `constraints_from` | array of strings | HTTPS URLs used to constrain NTP responses (MITM protection) |
| `sensor` | array of strings | Hardware time sensors (e.g., `/dev/gps0`) |

## Example

```yaml
_type: amadla.org/entity/application/timekeeping/openntpd@v1.0.0
_extends: amadla.org/entity/application/timekeeping@v1.0.0
_body:
  servers:
    - time.google.com
  pools:
    - pool.ntp.org
  listen_on:
    - 127.0.0.1
    - "::1"
  constraints_from:
    - "https://www.google.com"
```

## When to Use

- BSD systems (OpenBSD, FreeBSD) where OpenNTPD is the native choice
- Simplicity is preferred over ntpd's feature set
- `constraints_from` provides HTTPS-based MITM protection — unique to OpenNTPD

## Consumers

| Tool | How It Uses Application/Timekeeping/OpenNTPD |
|------|---------------------------------------|
| lay | Installs the `openntpd` package |
| weaver | Generates `/etc/ntpd.conf` |
| enjoin-service | Enables/starts `ntpd` (OpenNTPD) service |
