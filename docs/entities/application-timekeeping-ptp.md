# Application/Timekeeping/PTP

| Field | Value |
|-------|-------|
| **Purpose** | Precision Time Protocol (linuxptp) configuration — sub-microsecond accuracy for data centers and financial systems |
| **Repo** | [AmadlaOrg/Entities/Application/Timekeeping/PTP](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/timekeeping/ptp@v1.0.0` |
| **Parent type** | [Application/Timekeeping](application-timekeeping.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `interface` | string | Network interface (must support hardware timestamping) |
| `domain` | integer | PTP domain number (default: `0`) |
| `transport` | string | Transport protocol: `UDPv4`, `UDPv6`, `L2` |
| `delay_mechanism` | string | Delay measurement: `E2E`, `P2P`, `Auto` |
| `slave_only` | boolean | Never become grandmaster (default: `true`) |
| `priority1` | integer | Clock priority for BMCA (0-255, lower wins) |
| `priority2` | integer | Secondary clock priority (0-255) |
| `phc2sys.enabled` | boolean | Sync PTP hardware clock to system clock (default: `true`) |
| `phc2sys.sync_rate` | integer | Sync frequency in Hz (default: `1`) |

## Example

```yaml
_type: amadla.org/entity/application/timekeeping/ptp@v1.0.0
_extends: amadla.org/entity/application/timekeeping@v1.0.0
_body:
  interface: eth0
  domain: 0
  transport: UDPv4
  delay_mechanism: E2E
  slave_only: true
  phc2sys:
    enabled: true
    sync_rate: 1
```

## When to Use

- Sub-microsecond accuracy required (financial trading, telecom, scientific instrumentation)
- Data center environments with PTP-capable switches
- Network interface must support hardware timestamping (`ethtool -T <iface>` to check)
- Often used alongside NTP as fallback (PTP for precision, NTP for coarse sync)

## Consumers

| Tool | How It Uses Application/Timekeeping/PTP |
|------|----------------------------------|
| [lay](../tools/lay.md) | Installs the `linuxptp` package |
| [weaver](../tools/weaver.md) | Generates `/etc/ptp4l.conf` and phc2sys config |
| enjoin-service | Enables/starts `ptp4l` and `phc2sys` services |
