# Application/DNSResolver/Unbound

| Field | Value |
|-------|-------|
| **Purpose** | Unbound-specific configuration — validating, recursive, caching DNS resolver |
| **Repo** | [AmadlaOrg/Entities/Application/DNSResolver/Unbound](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/dns-resolver/unbound@v1.0.0` |
| **Parent type** | [Application/DNSResolver](application-dns-resolver.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `access_control` | array of objects | Access control rules for client queries |
| `access_control[].subnet` | string | Network subnet (e.g., `192.168.1.0/24`) |
| `access_control[].action` | string | Action for matching clients (`allow`, `deny`, `refuse`) |
| `local_zone` | array of objects | Local zone definitions |
| `local_zone[].name` | string | Zone name |
| `local_zone[].type` | string | Zone type (`static`, `transparent`, `redirect`) |
| `local_data` | array of objects | Local DNS data entries |
| `local_data[].name` | string | Record name |
| `local_data[].record` | string | DNS record value (e.g., `A 192.168.1.1`) |
| `forward_zones` | array of objects | Forward zone configurations |
| `forward_zones[].name` | string | Zone name to forward |
| `forward_zones[].forward_addr` | array of strings | Addresses to forward queries to |
| `prefetch` | boolean | Whether to prefetch almost-expired cache entries |
| `num_threads` | integer | Number of threads to use for serving |

## Example

```yaml
_type: amadla.org/entity/application/dns-resolver/unbound@v1.0.0
_extends: amadla.org/entity/application/dns-resolver@v1.0.0
_body:
  listen_address: "127.0.0.1"
  listen_port: 53
  cache_size: 50000
  prefetch: true
  num_threads: 2
  access_control:
    - subnet: 127.0.0.0/8
      action: allow
    - subnet: 192.168.0.0/16
      action: allow
  forward_zones:
    - name: "."
      forward_addr:
        - 1.1.1.1
        - 8.8.8.8
  local_zone:
    - name: example.local
      type: static
  local_data:
    - name: app.example.local
      record: "A 192.168.1.10"
```

## Consumers

| Tool | How It Uses Application/DNSResolver/Unbound |
|------|----------------------------------------------|
| [lay](../tools/lay.md) | Installs the `unbound` package |
| [weaver](../tools/weaver.md) | Generates `/etc/unbound/unbound.conf` |
| enjoin-service | Enables/starts `unbound` service |
