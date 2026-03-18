# Infrastructure/Cloud/CDN/Cloudflare

| Field | Value |
|-------|-------|
| **Purpose** | Cloudflare CDN zone configuration — SSL mode, cache level, page rules, firewall rules |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/CDN/Cloudflare/CloudflareCDN](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/cdn/cloudflare@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/CDN](infrastructure-cloud-cdn.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `zone_id` | string | Cloudflare zone identifier |
| `api_token_secret` | string | Secret reference for the Cloudflare API token |
| `ssl_mode` | string | SSL/TLS encryption mode (`off`, `flexible`, `full`, `strict`) |
| `always_use_https` | boolean | Redirect all HTTP requests to HTTPS |
| `min_tls_version` | string | Minimum TLS version allowed (`1.0`, `1.1`, `1.2`, `1.3`) |
| `cache_level` | string | Cache level for the zone (`bypass`, `basic`, `simplified`, `aggressive`) |
| `browser_cache_ttl` | integer | Browser cache TTL in seconds |
| `page_rules` | array of objects | Page rules for URL-based behavior overrides (`url_pattern`, `actions`) |
| `firewall_rules` | array of objects | Firewall rules for request filtering (`expression`, `action`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/cdn/cloudflare@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/cdn@v1.0.0
_body:
  zone_id: abc123def456
  api_token_secret: doorman://cloudflare/api-token
  ssl_mode: strict
  always_use_https: true
  min_tls_version: "1.2"
  cache_level: aggressive
  browser_cache_ttl: 14400
  firewall_rules:
    - expression: (ip.geoip.country eq "CN")
      action: challenge
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/CDN/Cloudflare |
|------|------------------------------------------------|
| raise | Provisions Cloudflare CDN zones via raise-cloudflare plugin |
