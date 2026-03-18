# Infrastructure/Cloud/CDN/CloudFront

| Field | Value |
|-------|-------|
| **Purpose** | AWS CloudFront CDN distribution configuration — origins, cache behaviors, price class, WAF |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/CDN/AWS/CloudFront](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/cdn/cloudfront@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/CDN](infrastructure-cloud-cdn.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `distribution_id` | string | CloudFront distribution identifier |
| `origins` | array of objects | Origin configurations (`id`, `domain_name`, `origin_path`, `s3_origin_config`, `custom_origin_config`) |
| `default_cache_behavior` | object | Default cache behavior settings (`viewer_protocol_policy`, `allowed_methods[]`, `cached_methods[]`, `compress`, `ttl`) |
| `default_cache_behavior.viewer_protocol_policy` | string | Protocol policy (`redirect-to-https`, `allow-all`, `https-only`) |
| `price_class` | string | Edge location coverage (`PriceClass_100`, `PriceClass_200`, `PriceClass_All`) |
| `acm_certificate_arn` | string | ARN of the ACM certificate for HTTPS |
| `waf_web_acl_id` | string | WAF Web ACL identifier for request filtering |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/cdn/cloudfront@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/cdn@v1.0.0
_body:
  origins:
    - id: s3-origin
      domain_name: my-bucket.s3.amazonaws.com
  default_cache_behavior:
    viewer_protocol_policy: redirect-to-https
    compress: true
    ttl:
      default: 86400
      max: 604800
      min: 0
  price_class: PriceClass_100
  acm_certificate_arn: arn:aws:acm:us-east-1:123456789012:certificate/abc-123
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/CDN/CloudFront |
|------|------------------------------------------------|
| raise | Provisions CloudFront distributions via raise-aws plugin |
