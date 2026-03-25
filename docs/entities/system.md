# System

| Field | Value |
|-------|-------|
| **Purpose** | Defines system-level configuration — hostname, timezone, locale, swap, kernel parameters, resource limits |
| **Repo** | [AmadlaOrg/Entities/System](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/system@v1.0.0` |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `hostname` | string | System hostname |
| `timezone` | string | e.g., `UTC`, `America/New_York` |
| `locale` | string | e.g., `en_US.UTF-8` |
| `swap.size` | integer/string | Swap size (e.g., `2g`) |
| `swap.file` | string | Swap file path (e.g., `/swapfile`) |
| `sysctl` | object | Kernel parameters — key-value pairs applied via `sysctl` |
| `limits` | array | Resource limits (`/etc/security/limits.conf`) |
| `limits[].domain` | string | User, group, or wildcard (e.g., `*`, `@docker`) |
| `limits[].type` | string | `soft`, `hard`, or `-` (both) |
| `limits[].item` | string | Resource name (e.g., `nofile`, `nproc`, `memlock`) |
| `limits[].value` | integer/string | Limit value |

## Sub-types

| Entity | Purpose | Handled By |
|--------|---------|------------|
| [System/CPU](system-cpu.md) | CPU constraints (count, shares, quota, affinity) | enjoin, raise |
| [System/Memory](system-memory.md) | Memory constraints (limit, reservation, swappiness, OOM) | enjoin, raise |
| [System/Network](system-network.md) | Network connectivity (interfaces, DNS, ports, IPAM) | enjoin-network |
| [System/Filesystem](system-filesystem.md) | Volumes, mounts, tmpfs, fstab | enjoin-filesystem |

## Example

```yaml
_type: amadla.org/entity/system@v1.0.0
_body:
  hostname: web-01
  timezone: UTC
  locale: en_US.UTF-8
  swap:
    size: 2g
    file: /swapfile
  sysctl:
    net.ipv4.ip_forward: 1
    vm.swappiness: 10
    fs.file-max: 2097152
  limits:
    - domain: "*"
      type: soft
      item: nofile
      value: 65536
    - domain: "*"
      type: hard
      item: nofile
      value: 131072
    - domain: "@docker"
      type: "-"
      item: nproc
      value: 4096
```

## Consumers

| Tool | How It Uses System |
|------|-------------------|
| enjoin-sysctl | Applies kernel parameters from `sysctl` |
| [enjoin](../tools/enjoin.md) | Applies hostname, timezone, locale, swap, limits |
| [raise](../tools/raise.md) | Provisions VMs/instances with system-level settings |
| [judge-system](../plugins/judges.md) | Validates system state matches requirements |
