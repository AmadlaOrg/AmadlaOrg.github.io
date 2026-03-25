# System/Memory

| Field | Value |
|-------|-------|
| **Purpose** | Defines memory resource constraints — inspired by Docker Compose memory properties |
| **Repo** | [AmadlaOrg/Entities/System/Memory](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/system/memory@v1.0.0` |
| **Parent type** | [System](system.md) |

## Schema

System/Memory describes memory resource requirements:

- `mem_limit` — hard memory limit (e.g., "512m", "1g")
- `mem_reservation` — soft memory limit
- `mem_swappiness` — kernel swappiness (0-100)
- `memswap_limit` — swap limit (-1 for unlimited)
- `oom_kill_disable` — disable OOM killer
- `oom_score_adj` — OOM score adjustment (-1000 to 1000)
- `shm_size` — size of /dev/shm

## Example

```yaml
_type: amadla.org/entity/system/memory@v1.0.0
_body:
  mem_limit: 1g
  mem_reservation: 512m
  mem_swappiness: 60
  shm_size: 256m
```

### Strict limits example

```yaml
_type: amadla.org/entity/system/memory@v1.0.0
_body:
  mem_limit: 2g
  memswap_limit: 2g
  oom_kill_disable: false
  oom_score_adj: 500
```

## Consumers

| Tool | How It Uses System/Memory |
|------|----------------------------------|
| [enjoin](../tools/enjoin.md) | Configures cgroup memory constraints |
| [raise](../tools/raise.md) | Provisions VMs/instances with specified memory |
| [judge-system](../plugins/judges.md) | Validates that memory resources meet requirements |
