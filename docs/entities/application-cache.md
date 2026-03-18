# Application/Cache

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all caching applications |
| **Repo** | [AmadlaOrg/Entities/Application/Cache](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/cache@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Bind address for the cache service |
| `listen_port` | integer | Port the cache service listens on |
| `max_memory` | string | Maximum memory usage (e.g., `256mb`, `1gb`) |
| `eviction_policy` | string | Policy when memory is full (e.g., `noeviction`, `allkeys-lru`, `volatile-lru`) |
| `persistence` | boolean | Whether to persist cached data to disk |

These properties are common across all cache implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Use Case |
|----------|-------------|----------|
| [Cache/Redis](application-cache-redis.md) | Redis — in-memory data structure store | General-purpose caching, sessions, pub/sub |
| [Cache/Memcached](application-cache-memcached.md) | Memcached — distributed memory caching | Simple key-value caching at scale |
| [Cache/Varnish](application-cache-varnish.md) | Varnish — HTTP accelerator | HTTP reverse proxy caching |

## Example

```yaml
_type: amadla.org/entity/application/cache@v1.0.0
_body:
  listen_address: 127.0.0.1
  listen_port: 6379
  max_memory: 256mb
  eviction_policy: allkeys-lru
  persistence: false
```

## Consumers

| Tool | How It Uses Application/Cache |
|------|-------------------------------|
| lay | Installs the cache application (redis, memcached, varnish) |
| enjoin-service | Enables/starts the cache service |
| weaver | Generates configuration files (redis.conf, memcached.conf, default.vcl) |
