# Infrastructure/Cloud/DNS/Route53

| Field | Value |
|-------|-------|
| **Purpose** | AWS Route 53-specific DNS properties — hosted zone, routing policies, health checks, alias records |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/DNS/AWS/Route53](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/dns/route53@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/DNS](infrastructure-cloud-dns.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `hosted_zone_id` | string | Route 53 hosted zone ID |
| `routing_policy` | string | DNS routing policy (`simple`, `weighted`, `latency`, `failover`, `geolocation`, `multivalue`) |
| `health_checks` | array of objects | Health check configurations (`protocol`, `fqdn`, `port`, `path`, `interval`, `failure_threshold`) |
| `alias_records` | array of objects | Alias record definitions (`name`, `target_hosted_zone_id`, `target_dns_name`, `evaluate_target_health`) |

**Required:** `hosted_zone_id`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/dns/route53@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/dns@v1.0.0
_body:
  hosted_zone_id: Z1234567890ABC
  routing_policy: latency
  health_checks:
    - protocol: HTTPS
      fqdn: example.com
      port: 443
      path: /health
      interval: 30
      failure_threshold: 3
  alias_records:
    - name: www
      target_dns_name: d123456.cloudfront.net
      target_hosted_zone_id: Z2FDTNDATAQYW2
      evaluate_target_health: true
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/DNS/Route53 |
|------|---------------------------------------------|
| raise | Provisions Route 53 zones and records via raise-aws plugin |
