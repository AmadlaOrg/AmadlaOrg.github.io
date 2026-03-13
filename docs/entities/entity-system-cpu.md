# EntitySystem/CPU

| Field | Value |
|-------|-------|
| **Purpose** | Defines CPU resource constraints — inspired by Docker Compose CPU properties |
| **Repo** | [AmadlaOrg/Entities/System/CPU](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/system/cpu@v1.0.0` |
| **Parent type** | [EntitySystem](entity-system.md) |

## Schema

EntitySystem/CPU describes CPU resource requirements:

- `cpu_count` — number of CPUs available to the container/service
- `cpu_percent` — usable percentage of available CPUs
- `cpu_shares` — relative CPU weight (default 1024)
- `cpu_quota` / `cpu_period` — CFS quota and period
- `cpu_rt_period` / `cpu_rt_runtime` — real-time scheduling period and runtime
- `cpus` — number of CPUs (decimal, e.g., 1.5)
- `cpuset` — CPU affinity pinning (e.g., "0-3", "0,1")

## Example

```yaml
_type: amadla.org/entity/system/cpu@v1.0.0
_body:
  cpus: 2
  cpu_shares: 512
  cpuset: "0,1"
```

### Resource limits example

```yaml
_type: amadla.org/entity/system/cpu@v1.0.0
_body:
  cpu_count: 4
  cpu_percent: 80
  cpu_quota: 50000
  cpu_period: 100000
```

## Consumers

| Tool | How It Uses EntitySystem/CPU |
|------|------------------------------|
| lay | Configures cgroup CPU constraints |
| raise | Provisions VMs/instances with specified CPU resources |
| judge-system | Validates that CPU resources meet requirements |
