# Application/APIGateway/KrakenD

| Field | Value |
|-------|-------|
| **Purpose** | KrakenD-specific configuration — ultra-performant stateless API gateway |
| **Repo** | [AmadlaOrg/Entities/Application/APIGateway/KrakenD](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/api-gateway/krakend@v1.0.0` |
| **Parent type** | [Application/APIGateway](application-api-gateway.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `version` | integer | KrakenD config version (e.g., `3`) |
| `timeout` | string | Global backend timeout (e.g., `3000ms`, `2s`) |
| `cache_ttl` | string | Global response cache TTL (e.g., `300s`, `5m`) |
| `endpoints` | array of objects | API endpoint definitions (see below) |
| `extra_config` | object | Global plugin configuration (telemetry, security, auth) |
| `output_encoding` | string | Response encoding format (`json`, `negotiate`, `string`, `no-op`) |

**Endpoint object:**

| Property | Type | Description |
|----------|------|-------------|
| `endpoint` | string | Public endpoint path |
| `method` | string | HTTP method |
| `backend` | array of objects | Backend services (`url_pattern`, `host`, `method`) |
| `extra_config` | object | Per-endpoint plugin configuration |

## Example

```yaml
_type: amadla.org/entity/application/api-gateway/krakend@v1.0.0
_extends: amadla.org/entity/application/api-gateway@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 8080
  version: 3
  timeout: 3000ms
  cache_ttl: 300s
  output_encoding: json
  endpoints:
    - endpoint: /api/users
      method: GET
      backend:
        - url_pattern: /users
          host: http://users-service:8080
          method: GET
    - endpoint: /api/orders
      method: GET
      backend:
        - url_pattern: /orders
          host: http://orders-service:8080
          method: GET
  extra_config:
    telemetry/metrics:
      collection_time: 60s
```

## Consumers

| Tool | How It Uses Application/APIGateway/KrakenD |
|------|---------------------------------------------|
| lay | Installs KrakenD gateway |
| weaver | Generates `krakend.json` configuration |
| enjoin-service | Enables/starts the `krakend` service |
