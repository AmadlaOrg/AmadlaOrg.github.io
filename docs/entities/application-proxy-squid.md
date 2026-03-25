# Application/Proxy/Squid

| Field | Value |
|-------|-------|
| **Purpose** | Squid-specific configuration — full-featured caching forward proxy |
| **Repo** | [AmadlaOrg/Entities/Application/Proxy/Squid](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/proxy/squid@v1.0.0` |
| **Parent type** | [Application/Proxy](application-proxy.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `cache_dir.type` | string | Cache storage type: `ufs`, `aufs`, `diskd`, or `rock` |
| `cache_dir.path` | string | Cache directory path |
| `cache_dir.size_mb` | integer | Cache size in megabytes |
| `cache_dir.l1_dirs` | integer | Number of first-level subdirectories |
| `cache_dir.l2_dirs` | integer | Number of second-level subdirectories |
| `cache_mem` | string | In-memory cache size (e.g., `256 MB`) |
| `maximum_object_size` | string | Maximum cacheable object size (e.g., `4 MB`) |
| `http_access_rules` | array of objects | HTTP access rules |
| `http_access_rules[].action` | string | Access action: `allow` or `deny` (required) |
| `http_access_rules[].acl` | string | ACL name to match (required) |
| `visible_hostname` | string | Hostname shown in error messages and Via headers |
| `coredump_dir` | string | Directory for core dumps |
| `ssl_bump.enabled` | boolean | Whether SSL bumping is enabled |
| `ssl_bump.cert` | string | Path to CA certificate for SSL bumping |
| `ssl_bump.key` | string | Path to CA private key for SSL bumping |

## Example

```yaml
_type: amadla.org/entity/application/proxy/squid@v1.0.0
_extends: amadla.org/entity/application/proxy@v1.0.0
_body:
  listen_port: 3128
  acl:
    - name: localnet
      type: src
      values:
        - 192.168.0.0/16
  cache_dir:
    type: ufs
    path: /var/spool/squid
    size_mb: 1024
    l1_dirs: 16
    l2_dirs: 256
  cache_mem: 256 MB
  maximum_object_size: 4 MB
  http_access_rules:
    - action: allow
      acl: localnet
    - action: deny
      acl: all
  visible_hostname: proxy.example.com
  coredump_dir: /var/spool/squid
```

## Consumers

| Tool | How It Uses Application/Proxy/Squid |
|------|-------------------------------------|
| [lay](../tools/lay.md) | Installs the `squid` package |
| [weaver](../tools/weaver.md) | Generates `/etc/squid/squid.conf` |
| enjoin-service | Enables/starts the `squid` service |
