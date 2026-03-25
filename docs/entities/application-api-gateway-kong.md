# Application/APIGateway/Kong

| Field | Value |
|-------|-------|
| **Purpose** | Kong-specific configuration — plugin-driven API gateway with DB or declarative mode |
| **Repo** | [AmadlaOrg/Entities/Application/APIGateway/Kong](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/api-gateway/kong@v1.0.0` |
| **Parent type** | [Application/APIGateway](application-api-gateway.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `database` | string | Database backend: `postgres`, `cassandra`, or `off` (DB-less declarative mode) |
| `database_config.host` | string | Database host |
| `database_config.port` | integer | Database port |
| `database_config.name` | string | Database name |
| `database_config.user` | string | Database user |
| `database_config.password_secret` | string | Doorman secret reference for database password |
| `declarative_config` | string | Path to declarative YAML config file (used in DB-less mode) |
| `plugins` | array of strings | Enabled plugins (e.g., `rate-limiting`, `key-auth`, `jwt`, `oauth2`) |
| `proxy_listen` | string | Proxy listener address and port (e.g., `0.0.0.0:8000`) |
| `admin_listen` | string | Admin API listener address and port (e.g., `127.0.0.1:8001`) |
| `status_listen` | string | Status API listener address and port (e.g., `0.0.0.0:8100`) |
| `nginx_worker_processes` | string | Number of Nginx worker processes (`auto` or a number) |

## Example

```yaml
_type: amadla.org/entity/application/api-gateway/kong@v1.0.0
_extends: amadla.org/entity/application/api-gateway@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 8000
  database: postgres
  database_config:
    host: db.internal
    port: 5432
    name: kong
    user: kong
    password_secret: doorman://vault/kong/db-password
  plugins:
    - rate-limiting
    - key-auth
    - cors
    - jwt
  proxy_listen: "0.0.0.0:8000"
  admin_listen: "127.0.0.1:8001"
  status_listen: "0.0.0.0:8100"
  nginx_worker_processes: auto
```

## Consumers

| Tool | How It Uses Application/APIGateway/Kong |
|------|------------------------------------------|
| [lay](../tools/lay.md) | Installs Kong gateway |
| [weaver](../tools/weaver.md) | Generates `kong.conf` and declarative config |
| enjoin-service | Enables/starts the `kong` service |
