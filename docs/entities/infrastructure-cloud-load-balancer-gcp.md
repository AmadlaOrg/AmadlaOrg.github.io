# Infrastructure/Cloud/LoadBalancer/GCP

| Field | Value |
|-------|-------|
| **Purpose** | GCP Cloud Load Balancing configuration — backend services, URL map, SSL certificates, health checks |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/LoadBalancer/GCP/CloudLoadBalancing](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/load-balancer/gcp@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/LoadBalancer](infrastructure-cloud-load-balancer.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Name of the load balancer |
| `load_balancing_scheme` | string | Traffic scope (`EXTERNAL`, `INTERNAL`, `EXTERNAL_MANAGED`, `INTERNAL_MANAGED`) |
| `backend_services` | array of objects | Backend service definitions (`name`, `protocol`, `port_name`, `backends[]`) |
| `backend_services[].protocol` | string | Backend protocol (`HTTP`, `HTTPS`, `TCP`) |
| `url_map` | object | URL map for routing (`default_service`, `path_matchers[]`) |
| `ssl_certificates` | array of strings | SSL certificate resource names |
| `health_checks` | array of objects | Health check configurations (`name`, `port`, `request_path`, `check_interval_sec`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/load-balancer/gcp@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/load-balancer@v1.0.0
_body:
  name: web-lb
  load_balancing_scheme: EXTERNAL_MANAGED
  backend_services:
    - name: web-backend
      protocol: HTTP
      port_name: http
      backends:
        - group: projects/.../instanceGroups/web-ig
          balancing_mode: RATE
          max_rate_per_instance: 100
  url_map:
    default_service: web-backend
  ssl_certificates:
    - web-cert
  health_checks:
    - name: web-hc
      port: 8080
      request_path: /health
      check_interval_sec: 10
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/LoadBalancer/GCP |
|------|--------------------------------------------------|
| [raise](../tools/raise.md) | Provisions GCP load balancers via raise-gcp plugin |
