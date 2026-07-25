# Container

| Field | Value |
|-------|-------|
| **Purpose** | Defines container/image requirements — base images, build configurations, runtime settings |
| **Repo** | [AmadlaOrg/Entities/Container](https://github.com/AmadlaOrg/Entities/Container) |
| **Entity URI** | `amadla.org/entity/container@v1.0.0` |

## Schema

Container describes container definitions:

- Base image
- Build configuration
- Runtime settings
- Port mappings
- Volume mounts

## Example

```yaml
_type: amadla.org/entity/container@v1.0.0
_body:
  image: nginx:1.24-alpine
  ports:
    - "80:80"
    - "443:443"
```

## Consumers

| Tool | How It Uses Container |
|------|------------------------------|
| [raise](../tools/raise.md) | Provisions container infrastructure |
| [weaver](../tools/weaver.md) | Generates container configuration files |
