# EntitySystem

| Field | Value |
|-------|-------|
| **Purpose** | Defines system-level requirements — OS, kernel, packages, system resources |
| **Repo** | [AmadlaOrg/EntitySystem](https://github.com/AmadlaOrg/EntitySystem) |
| **Entity URI** | `github.com/AmadlaOrg/EntitySystem@v1.0.0` |

## Schema

EntitySystem describes system-level requirements:

- Operating system and version
- Kernel version
- System packages
- Resource requirements (memory, disk, CPU)

## Example

```yaml
_type: amadla.org/entity/system@v1.0.0
_body:
  package: nginx
  version: ">=1.24"
```

## Consumers

| Tool | How It Uses EntitySystem |
|------|--------------------------|
| lay | Installs required system packages |
| judge-system | Checks whether system matches requirements |
