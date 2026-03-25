# Application/Cache/Redis

| Field | Value |
|-------|-------|
| **Purpose** | Redis-specific configuration — in-memory data structure store with optional persistence |
| **Repo** | [AmadlaOrg/Entities/Application/Cache/Redis](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/cache/redis@v1.0.0` |
| **Parent type** | [Application/Cache](application-cache.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `databases` | integer | Number of databases (default: `16`) |
| `save_intervals` | array of objects | RDB snapshot intervals (`seconds`, `changes`) |
| `appendonly` | boolean | Enable AOF (Append Only File) persistence |
| `appendfsync` | string | AOF fsync policy (`always`, `everysec`, `no`) |
| `maxmemory_policy` | string | Eviction policy override (e.g., `allkeys-lru`, `volatile-ttl`) |
| `requirepass_secret` | string | Doorman secret reference for the Redis password |
| `cluster_enabled` | boolean | Enable Redis Cluster mode |
| `replica_of` | string | Master address for replication (`host:port`) |

## Example

```yaml
_type: amadla.org/entity/application/cache/redis@v1.0.0
_extends: amadla.org/entity/application/cache@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 6379
  max_memory: 1gb
  eviction_policy: allkeys-lru
  persistence: true
  databases: 16
  save_intervals:
    - seconds: 900
      changes: 1
    - seconds: 300
      changes: 10
    - seconds: 60
      changes: 10000
  appendonly: true
  appendfsync: everysec
  requirepass_secret: doorman://vault/redis/password
  cluster_enabled: false
```

## Consumers

| Tool | How It Uses Application/Cache/Redis |
|------|-------------------------------------|
| [lay](../tools/lay.md) | Installs the `redis` package |
| [weaver](../tools/weaver.md) | Generates `/etc/redis/redis.conf` |
| enjoin-service | Enables/starts `redis-server` service |
