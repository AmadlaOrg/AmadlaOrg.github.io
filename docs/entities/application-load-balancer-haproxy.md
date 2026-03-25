# Application/LoadBalancer/HAProxy

| Field | Value |
|-------|-------|
| **Purpose** | HAProxy-specific configuration — high-performance TCP/HTTP load balancer |
| **Repo** | [AmadlaOrg/Entities/Application/LoadBalancer/HAProxy](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/load-balancer/haproxy@v1.0.0` |
| **Parent type** | [Application/LoadBalancer](application-load-balancer.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `global.maxconn` | integer | Maximum number of concurrent connections |
| `global.log` | string | Log destination (e.g., `/dev/log local0`) |
| `global.stats_socket` | string | Path to the stats UNIX socket |
| `defaults.mode` | string | Default operating mode (`http`, `tcp`) |
| `defaults.timeout_connect` | string | Timeout for establishing connections (e.g., `5s`) |
| `defaults.timeout_client` | string | Timeout for client inactivity (e.g., `50s`) |
| `defaults.timeout_server` | string | Timeout for server inactivity (e.g., `50s`) |
| `defaults.retries` | integer | Number of retries on connection failure |
| `frontends` | array of objects | Frontend definitions (`name`, `bind`, `default_backend`, `acls`, `use_backend_rules`) |
| `backends_config` | array of objects | Backend definitions (`name`, `balance`, `servers`) |
| `stats.enabled` | boolean | Whether the stats page is enabled |
| `stats.uri` | string | URI for the stats page (e.g., `/haproxy-stats`) |
| `stats.auth` | string | Basic auth credentials for stats (`user:password`) |

## Example

```yaml
_type: amadla.org/entity/application/load-balancer/haproxy@v1.0.0
_extends: amadla.org/entity/application/load-balancer@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 80
  algorithm: roundrobin
  health_check:
    enabled: true
    interval: 10s
    timeout: 5s
    path: /health
  global:
    maxconn: 4096
    log: /dev/log local0
    stats_socket: /run/haproxy/admin.sock mode 660
  defaults:
    mode: http
    timeout_connect: 5s
    timeout_client: 50s
    timeout_server: 50s
    retries: 3
  frontends:
    - name: http-in
      bind: "*:80"
      default_backend: webservers
  backends_config:
    - name: webservers
      balance: roundrobin
      servers:
        - name: web-1
          address: 10.0.1.10
          port: 8080
          options:
            - check
            - weight 10
        - name: web-2
          address: 10.0.1.11
          port: 8080
          options:
            - check
            - weight 10
  stats:
    enabled: true
    uri: /haproxy-stats
```

## Consumers

| Tool | How It Uses Application/LoadBalancer/HAProxy |
|------|----------------------------------------------|
| [lay](../tools/lay.md) | Installs the `haproxy` package |
| [weaver](../tools/weaver.md) | Generates `/etc/haproxy/haproxy.cfg` |
| enjoin-service | Enables/starts `haproxy` service |
