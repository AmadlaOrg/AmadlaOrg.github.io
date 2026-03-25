# Infrastructure/DNS/CoreDNS

| Field | Value |
|-------|-------|
| **Purpose** | CoreDNS-specific configuration — plugin-based DNS server, default in Kubernetes |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/DNS/CoreDNS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/dns/coredns@v1.0.0` |
| **Parent type** | [Infrastructure/DNS](infrastructure-dns.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `plugins` | array of objects | CoreDNS plugins to enable |
| `plugins[].name` | string | Plugin name |
| `plugins[].zone` | string | Zone this plugin applies to |
| `plugins[].config` | object | Plugin-specific configuration |
| `forward.from` | string | Zone to forward (e.g., `.` for all) |
| `forward.to` | array of strings | Upstream DNS servers to forward to |
| `forward.policy` | string | Load balancing policy: `random`, `round_robin`, or `sequential` |
| `prometheus_address` | string | Address for Prometheus metrics endpoint |
| `health_address` | string | Address for health check endpoint |
| `cache_ttl` | integer | Cache TTL in seconds |

## Example

```yaml
_type: amadla.org/entity/infrastructure/dns/coredns@v1.0.0
_extends: amadla.org/entity/infrastructure/dns@v1.0.0
_body:
  listen_port: 53
  plugins:
    - name: file
      zone: example.com
      config:
        file: /etc/coredns/zones/example.com.zone
    - name: log
  forward:
    from: .
    to:
      - 8.8.8.8
      - 8.8.4.4
    policy: round_robin
  prometheus_address: 0.0.0.0:9153
  health_address: 0.0.0.0:8080
  cache_ttl: 30
```

## Consumers

| Tool | How It Uses Infrastructure/DNS/CoreDNS |
|------|----------------------------------------|
| [lay](../tools/lay.md) | Installs the `coredns` binary |
| [weaver](../tools/weaver.md) | Generates `Corefile` and zone files |
| enjoin-service | Enables/starts the `coredns` service |
