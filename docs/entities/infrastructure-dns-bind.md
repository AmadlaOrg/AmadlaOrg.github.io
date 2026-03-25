# Infrastructure/DNS/BIND

| Field | Value |
|-------|-------|
| **Purpose** | BIND-specific configuration — the most widely deployed DNS server (named) |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/DNS/BIND](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/dns/bind@v1.0.0` |
| **Parent type** | [Infrastructure/DNS](infrastructure-dns.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `options.directory` | string | Working directory for zone files |
| `options.forwarders` | array of strings | Upstream DNS forwarders |
| `options.dnssec_validation` | string | DNSSEC validation mode: `auto`, `yes`, or `no` |
| `options.allow_query` | array of strings | Networks allowed to query this server |
| `options.max_cache_size` | string | Maximum cache size (e.g., `256m`) |
| `logging.channels` | array of objects | Logging channels (name, file, severity) |
| `logging.categories` | object | Log categories mapped to channels |
| `acls` | array of objects | Named access control lists |
| `acls[].name` | string | ACL name |
| `acls[].addresses` | array of strings | Addresses in this ACL |
| `views` | array of objects | BIND views for split-horizon DNS |
| `views[].name` | string | View name |
| `views[].match_clients` | array of strings | Client ACLs matched by this view |
| `views[].zones` | array of objects | Zones served in this view |

## Example

```yaml
_type: amadla.org/entity/infrastructure/dns/bind@v1.0.0
_extends: amadla.org/entity/infrastructure/dns@v1.0.0
_body:
  listen_port: 53
  zones:
    - name: example.com
      type: master
      file: /var/named/example.com.zone
  options:
    directory: /var/named
    forwarders:
      - 8.8.8.8
      - 8.8.4.4
    dnssec_validation: auto
    allow_query:
      - any
    max_cache_size: 256m
  logging:
    channels:
      - name: default_log
        file: /var/log/named/default.log
        severity: info
    categories:
      default:
        - default_log
  acls:
    - name: trusted
      addresses:
        - 10.0.0.0/8
        - 192.168.0.0/16
```

## Consumers

| Tool | How It Uses Infrastructure/DNS/BIND |
|------|-------------------------------------|
| [lay](../tools/lay.md) | Installs the `bind` / `named` package |
| [weaver](../tools/weaver.md) | Generates `named.conf` and zone files |
| enjoin-service | Enables/starts the `named` service |
