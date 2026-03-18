# Infrastructure/Cloud/DNS/Cloudflare

| Field | Value |
|-------|-------|
| **Purpose** | Cloudflare DNS-specific properties — zone ID, proxy mode, SSL mode |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/DNS/Cloudflare/CloudflareDNS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/dns/cloudflare@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/DNS](infrastructure-cloud-dns.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `zone_id` | string | Cloudflare zone ID |
| `api_token_secret` | string | Doorman secret reference for Cloudflare API token |
| `proxied` | boolean | Whether to enable Cloudflare proxy (orange cloud) (default: `true`) |
| `ssl_mode` | string | SSL/TLS encryption mode (`off`, `flexible`, `full`, `strict`) |

**Required:** `zone_id`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/dns/cloudflare@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/dns@v1.0.0
_body:
  zone_id: abc123def456
  api_token_secret: doorman://cloudflare/api-token
  proxied: true
  ssl_mode: strict
  zone_name: example.com
  records:
    - name: "@"
      type: A
      ttl: 1
      values:
        - 203.0.113.10
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/DNS/Cloudflare |
|------|-----------------------------------------------|
| raise | Provisions Cloudflare DNS zones via raise-cloudflare plugin |
