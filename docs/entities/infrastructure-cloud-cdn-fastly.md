# Infrastructure/Cloud/CDN/Fastly

| Field | Value |
|-------|-------|
| **Purpose** | Fastly CDN service configuration — backends, domains, VCL snippets, health checks |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/CDN/Fastly/FastlyCDN](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/cdn/fastly@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/CDN](infrastructure-cloud-cdn.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `service_id` | string | Fastly service identifier |
| `api_key_secret` | string | Secret reference for the Fastly API key |
| `backends` | array of objects | Backend server configurations (`name`, `address`, `port`, `ssl`, `weight`) |
| `domains` | array of strings | Domains served by this Fastly service |
| `vcl_snippets` | array of objects | VCL snippets for custom edge logic (`name`, `type`, `content`) |
| `vcl_snippets[].type` | string | Snippet type (`init`, `recv`, `pass`, `fetch`, `deliver`) |
| `healthcheck` | object | Health check configuration (`name`, `host`, `path`, `check_interval`, `threshold`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/cdn/fastly@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/cdn@v1.0.0
_body:
  service_id: svc-abc123
  api_key_secret: doorman://fastly/api-key
  backends:
    - name: origin-1
      address: origin.example.com
      port: 443
      ssl: true
      weight: 100
  domains:
    - cdn.example.com
    - www.example.com
  healthcheck:
    name: origin-check
    host: origin.example.com
    path: /health
    check_interval: 15
    threshold: 3
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/CDN/Fastly |
|------|---------------------------------------------|
| raise | Provisions Fastly CDN services via raise-fastly plugin |
