# Infrastructure/Cloud/CDN

| Field | Value |
|-------|-------|
| **Purpose** | Common CDN properties — origin, domain, cache TTL, compression |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/CDN](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/cdn@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `origin` | string | Origin server URL or domain |
| `domain` | string | CDN domain or alias |
| `cache_ttl` | integer | Default cache TTL in seconds |
| `compress` | boolean | Enable compression for served content |

## Sub-types

| Sub-type | Provider |
|----------|----------|
| [CDN/CloudFront](infrastructure-cloud-cdn-cloudfront.md) | AWS CloudFront |
| [CDN/Cloudflare](infrastructure-cloud-cdn-cloudflare.md) | Cloudflare CDN |
| [CDN/Fastly](infrastructure-cloud-cdn-fastly.md) | Fastly CDN |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/cdn@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  origin: https://origin.example.com
  domain: cdn.example.com
  cache_ttl: 86400
  compress: true
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/CDN |
|------|-------------------------------------|
| [raise](../tools/raise.md) | Provisions CDN distributions via provider-specific plugins |
