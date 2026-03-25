# Infrastructure/Cloud/LoadBalancer

| Field | Value |
|-------|-------|
| **Purpose** | Common cloud load balancer properties — type (L4/L7), scheme, listeners, health check |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/LoadBalancer](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/load-balancer@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `type` | string | Load balancer type: L7 (`application`) vs L4 (`network`) |
| `scheme` | string | Accessibility (`internet-facing`, `internal`) |
| `listeners` | array of objects | Listener configurations (`port`, `protocol`, `target_port`, `certificate`) |
| `listeners[].protocol` | string | Listener protocol (`HTTP`, `HTTPS`, `TCP`, `UDP`) |
| `health_check` | object | Health check configuration (`path`, `port`, `protocol`, `interval`, `threshold`) |

## Sub-types

| Sub-type | Provider |
|----------|----------|
| [LoadBalancer/ALB](infrastructure-cloud-load-balancer-alb.md) | AWS Application Load Balancer |
| [LoadBalancer/GCP](infrastructure-cloud-load-balancer-gcp.md) | GCP Cloud Load Balancing |
| [LoadBalancer/Azure](infrastructure-cloud-load-balancer-azure.md) | Azure Load Balancer |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/load-balancer@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  type: application
  scheme: internet-facing
  listeners:
    - port: 443
      protocol: HTTPS
      target_port: 8080
      certificate: arn:aws:acm:us-east-1:123456789012:certificate/abc-123
  health_check:
    path: /health
    port: 8080
    protocol: HTTP
    interval: 30
    threshold: 3
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/LoadBalancer |
|------|----------------------------------------------|
| [raise](../tools/raise.md) | Provisions load balancers via provider-specific plugins |
