# Application/Cache/Varnish

| Field | Value |
|-------|-------|
| **Purpose** | Varnish-specific configuration — HTTP accelerator and reverse proxy cache |
| **Repo** | [AmadlaOrg/Entities/Application/Cache/Varnish](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/cache/varnish@v1.0.0` |
| **Parent type** | [Application/Cache](application-cache.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `storage_backend` | string | Storage backend type (`malloc`, `file`, `persistent`) |
| `storage_size` | string | Storage size (e.g., `1G`) |
| `vcl_file` | string | Path to VCL configuration file |
| `admin_listen` | string | Admin interface address:port |
| `default_ttl` | string | Default TTL for cached objects |
| `thread_pool_min` | integer | Minimum number of threads per pool |
| `thread_pool_max` | integer | Maximum number of threads per pool |

## Example

```yaml
_type: amadla.org/entity/application/cache/varnish@v1.0.0
_extends: amadla.org/entity/application/cache@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 80
  max_memory: 1gb
  persistence: false
  storage_backend: malloc
  storage_size: 1G
  vcl_file: /etc/varnish/default.vcl
  admin_listen: 127.0.0.1:6082
  default_ttl: 120s
  thread_pool_min: 5
  thread_pool_max: 500
```

## Consumers

| Tool | How It Uses Application/Cache/Varnish |
|------|---------------------------------------|
| [lay](../tools/lay.md) | Installs the `varnish` package |
| [weaver](../tools/weaver.md) | Generates `/etc/varnish/default.vcl` and `/etc/default/varnish` |
| enjoin-service | Enables/starts `varnish` service |
