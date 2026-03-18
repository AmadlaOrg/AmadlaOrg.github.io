# Application/LoadBalancer

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all load balancer applications |
| **Repo** | [AmadlaOrg/Entities/Application/LoadBalancer](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/load-balancer@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the load balancer listens on |
| `listen_port` | integer | Port the load balancer listens on |
| `algorithm` | string | Load balancing algorithm (`roundrobin`, `leastconn`, `source`, `uri`, `random`) |
| `health_check.enabled` | boolean | Whether health checks are enabled |
| `health_check.interval` | string | Interval between health checks (e.g., `10s`) |
| `health_check.timeout` | string | Timeout for a health check response (e.g., `5s`) |
| `health_check.path` | string | HTTP path for health check requests (e.g., `/health`) |
| `backends` | array of objects | Backend servers (`name`, `address`, `port`, `weight`) |

These properties are common across all load balancer implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Use Case |
|----------|-------------|----------|
| [LoadBalancer/HAProxy](application-load-balancer-haproxy.md) | HAProxy — high-performance TCP/HTTP load balancer | Traditional L4/L7 load balancing |
| [LoadBalancer/Traefik](application-load-balancer-traefik.md) | Traefik — cloud-native reverse proxy | Auto-discovery, Let's Encrypt, Docker/K8s native |
| [LoadBalancer/Envoy](application-load-balancer-envoy.md) | Envoy — L7 proxy and communication bus | Service mesh, gRPC, advanced observability |

## Example

```yaml
_type: amadla.org/entity/application/load-balancer@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 80
  algorithm: roundrobin
  health_check:
    enabled: true
    interval: 10s
    timeout: 5s
    path: /health
  backends:
    - name: web-1
      address: 10.0.1.10
      port: 8080
      weight: 1
    - name: web-2
      address: 10.0.1.11
      port: 8080
      weight: 1
```

## Consumers

| Tool | How It Uses Application/LoadBalancer |
|------|--------------------------------------|
| lay | Installs the load balancer application (haproxy, traefik, envoy) |
| enjoin-service | Enables/starts the load balancer service |
| weaver | Generates configuration files (haproxy.cfg, traefik.yml, envoy.yaml) |
