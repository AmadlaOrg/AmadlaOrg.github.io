# EntityContainer

| Field | Value |
|-------|-------|
| **Purpose** | Defines container/image requirements — base images, build configurations, runtime settings |
| **Repo** | [AmadlaOrg/EntityContainer](https://github.com/AmadlaOrg/EntityContainer) |
| **Entity URI** | `github.com/AmadlaOrg/EntityContainer@v1.0.0` |

## Schema

EntityContainer describes container definitions:

- Base image
- Build configuration
- Runtime settings
- Port mappings
- Volume mounts

## Example

```yaml
_entity: github.com/AmadlaOrg/EntityContainer@v1.0.0
_body:
  image: nginx:1.24-alpine
  ports:
    - "80:80"
    - "443:443"
```

## Consumers

| Tool | How It Uses EntityContainer |
|------|------------------------------|
| raise | Provisions container infrastructure |
| weaver | Generates container configuration files |
