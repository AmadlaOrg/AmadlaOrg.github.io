# Infrastructure

| Field | Value |
|-------|-------|
| **Purpose** | Defines infrastructure requirements — servers, networks, storage, cloud resources |
| **Repo** | [AmadlaOrg/Entities/Infrastructure](https://github.com/AmadlaOrg/Entities/Infrastructure) |
| **Entity URI** | `amadla.org/entity/infrastructure@v1.0.0` |

## Schema

Infrastructure describes what infrastructure an application needs:

- Cloud provider and region
- Server/VM specifications (size, type)
- Networking requirements
- Storage requirements

## Example

```yaml
_type: amadla.org/entity/infrastructure@v1.0.0
_body:
  provider: digitalocean
  type: droplet
  size: s-1vcpu-1gb
  region: nyc1
```

## Consumers

| Tool | How It Uses Infrastructure |
|------|----------------------------------|
| raise | Provisions the declared infrastructure resources |
| judge-infrastructure | Checks whether infrastructure matches requirements |
