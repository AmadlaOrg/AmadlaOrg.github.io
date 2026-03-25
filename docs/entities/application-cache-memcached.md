# Application/Cache/Memcached

| Field | Value |
|-------|-------|
| **Purpose** | Memcached-specific configuration — distributed memory object caching system |
| **Repo** | [AmadlaOrg/Entities/Application/Cache/Memcached](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/cache/memcached@v1.0.0` |
| **Parent type** | [Application/Cache](application-cache.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `max_connections` | integer | Maximum number of simultaneous connections |
| `threads` | integer | Number of worker threads |
| `chunk_size` | integer | Default slab chunk size in bytes |
| `growth_factor` | number | Slab growth factor |
| `unix_socket` | string | Listen on a UNIX socket instead of TCP |
| `verbose` | boolean | Enable verbose logging |

## Example

```yaml
_type: amadla.org/entity/application/cache/memcached@v1.0.0
_extends: amadla.org/entity/application/cache@v1.0.0
_body:
  listen_address: 127.0.0.1
  listen_port: 11211
  max_memory: 512mb
  persistence: false
  max_connections: 1024
  threads: 4
  chunk_size: 48
  growth_factor: 1.25
  verbose: false
```

## Consumers

| Tool | How It Uses Application/Cache/Memcached |
|------|----------------------------------------|
| [lay](../tools/lay.md) | Installs the `memcached` package |
| [weaver](../tools/weaver.md) | Generates `/etc/memcached.conf` |
| enjoin-service | Enables/starts `memcached` service |
