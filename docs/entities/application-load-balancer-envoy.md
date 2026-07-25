# Application/LoadBalancer/Envoy

| Field | Value |
|-------|-------|
| **Purpose** | Envoy-specific configuration — L7 proxy and communication bus for service mesh |
| **Repo** | [AmadlaOrg/Entities/Application/LoadBalancer/Envoy](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/load-balancer/envoy@v1.0.0` |
| **Parent type** | [Application/LoadBalancer](application-load-balancer.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `admin.address` | string | Admin interface listen address |
| `admin.port` | integer | Admin interface listen port |
| `listeners` | array of objects | Listener definitions (`name`, `address`, `port`, `filter_chains`) |
| `clusters` | array of objects | Cluster (upstream) definitions (`name`, `type`, `lb_policy`, `endpoints`) |
| `overload_manager` | object | Overload manager for resource monitoring and protection |

Cluster `type` can be `STRICT_DNS`, `LOGICAL_DNS`, `STATIC`, or `EDS`.

## Example

```yaml
_type: amadla.org/entity/application/load-balancer/envoy@v1.0.0
_extends: amadla.org/entity/application/load-balancer@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 10000
  algorithm: roundrobin
  health_check:
    enabled: true
    interval: 5s
    timeout: 3s
    path: /health
  admin:
    address: 127.0.0.1
    port: 9901
  listeners:
    - name: listener_0
      address: 0.0.0.0
      port: 10000
      filter_chains: []
  clusters:
    - name: web_service
      type: STRICT_DNS
      lb_policy: ROUND_ROBIN
      endpoints:
        - address: 10.0.1.10
          port: 8080
        - address: 10.0.1.11
          port: 8080
    - name: api_service
      type: STRICT_DNS
      lb_policy: LEAST_REQUEST
      endpoints:
        - address: 10.0.2.10
          port: 9090
```

## Consumers

| Tool | How It Uses Application/LoadBalancer/Envoy |
|------|---------------------------------------------|
| [lay](../tools/lay.md) | Installs the `envoy` binary |
| [weaver](../tools/weaver.md) | Generates `/etc/envoy/envoy.yaml` |
| enjoin-service | Enables/starts `envoy` service |
