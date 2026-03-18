# Application/APIGateway

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all API gateway applications |
| **Repo** | [AmadlaOrg/Entities/Application/APIGateway](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/api-gateway@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the gateway listens on for proxy traffic |
| `listen_port` | integer | Port the gateway listens on for proxy traffic |
| `admin_listen` | string | Address the admin API listens on |
| `admin_port` | integer | Port the admin API listens on |
| `rate_limiting.enabled` | boolean | Whether rate limiting is active |
| `rate_limiting.requests_per_second` | integer | Maximum requests per second |
| `rate_limiting.burst` | integer | Maximum burst size above the rate limit |
| `cors.enabled` | boolean | Whether CORS is active |
| `cors.origins` | array of strings | Allowed origins |
| `cors.methods` | array of strings | Allowed HTTP methods |

These properties are common across all API gateway implementations. Sub-types add gateway-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [APIGateway/Kong](application-api-gateway-kong.md) | Kong — plugin-driven API gateway with DB or declarative mode | Most common |
| [APIGateway/Tyk](application-api-gateway-tyk.md) | Tyk — open source API gateway with dashboard and analytics | Feature-rich |
| [APIGateway/KrakenD](application-api-gateway-krakend.md) | KrakenD — ultra-performant stateless API gateway | High performance |

## Example

```yaml
_type: amadla.org/entity/application/api-gateway@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 8000
  admin_listen: 127.0.0.1
  admin_port: 8001
  rate_limiting:
    enabled: true
    requests_per_second: 100
    burst: 50
  cors:
    enabled: true
    origins:
      - https://app.example.com
    methods:
      - GET
      - POST
      - PUT
      - DELETE
```

## Consumers

| Tool | How It Uses Application/APIGateway |
|------|-------------------------------------|
| lay | Installs the API gateway application |
| weaver | Generates gateway configuration files |
| enjoin-service | Enables/starts the gateway service |
