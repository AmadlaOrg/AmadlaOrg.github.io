# Infrastructure/Cloud/LoadBalancer/ALB

| Field | Value |
|-------|-------|
| **Purpose** | AWS Application Load Balancer configuration — target groups, listener rules, access logs |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/LoadBalancer/AWS/ALB](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/load-balancer/alb@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/LoadBalancer](infrastructure-cloud-load-balancer.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Name of the Application Load Balancer |
| `subnets` | array of strings | Subnet IDs where the ALB is deployed |
| `security_groups` | array of strings | Security group IDs attached to the ALB |
| `target_groups` | array of objects | Target group definitions (`name`, `port`, `protocol`, `target_type`, `health_check`) |
| `target_groups[].target_type` | string | Target type (`instance`, `ip`, `lambda`) |
| `listener_rules` | array of objects | Listener rules for advanced routing (`priority`, `conditions[]`, `action`) |
| `access_logs` | object | Access logging configuration (`enabled`, `bucket`, `prefix`) |
| `idle_timeout` | integer | Idle timeout in seconds |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/load-balancer/alb@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/load-balancer@v1.0.0
_body:
  name: web-alb
  subnets:
    - subnet-pub-a
    - subnet-pub-b
  security_groups:
    - sg-alb
  target_groups:
    - name: web-tg
      port: 8080
      protocol: HTTP
      target_type: instance
  listener_rules:
    - priority: 10
      conditions:
        - field: path-pattern
          values: ["/api/*"]
      action:
        type: forward
        target_group_arn: arn:aws:...api-tg
  access_logs:
    enabled: true
    bucket: alb-logs-bucket
    prefix: web-alb
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/LoadBalancer/ALB |
|------|--------------------------------------------------|
| [raise](../tools/raise.md) | Provisions ALBs via raise-aws plugin |
