# Application/Proxy/Tinyproxy

| Field | Value |
|-------|-------|
| **Purpose** | Tinyproxy-specific configuration — lightweight HTTP/HTTPS proxy with minimal resource usage |
| **Repo** | [AmadlaOrg/Entities/Application/Proxy/Tinyproxy](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/proxy/tinyproxy@v1.0.0` |
| **Parent type** | [Application/Proxy](application-proxy.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `max_clients` | integer | Maximum number of simultaneous clients |
| `upstream` | string | Upstream proxy to forward requests to |
| `no_upstream` | array of strings | Domains to skip the upstream proxy for |
| `filter` | string | Path to URL filter file |
| `filter_default_deny` | boolean | Whether the filter defaults to deny (`true`) or allow (`false`) |
| `anonymous` | array of strings | Allowed headers in anonymous mode |

## Example

```yaml
_type: amadla.org/entity/application/proxy/tinyproxy@v1.0.0
_extends: amadla.org/entity/application/proxy@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 8888
  max_clients: 100
  upstream: proxy.corp.example.com:3128
  no_upstream:
    - .internal.example.com
    - 192.168.0.0/16
  filter: /etc/tinyproxy/filter
  filter_default_deny: false
  anonymous:
    - Host
    - Authorization
    - Cookie
```

## Consumers

| Tool | How It Uses Application/Proxy/Tinyproxy |
|------|----------------------------------------|
| [lay](../tools/lay.md) | Installs the `tinyproxy` package |
| [weaver](../tools/weaver.md) | Generates `/etc/tinyproxy/tinyproxy.conf` |
| enjoin-service | Enables/starts the `tinyproxy` service |
