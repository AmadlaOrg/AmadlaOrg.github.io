# Infrastructure/Cloud/DNS

| Field | Value |
|-------|-------|
| **Purpose** | Common cloud DNS zone and record properties — zone name, record definitions |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/DNS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/dns@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `zone_name` | string | DNS zone name (e.g., `example.com`) |
| `zone_type` | string | Whether the zone is publicly or privately resolvable (`public`, `private`) |
| `records` | array of objects | DNS record definitions (`name`, `type`, `ttl`, `values[]`) |
| `records[].type` | string | DNS record type (`A`, `AAAA`, `CNAME`, `MX`, `TXT`, `SRV`, `NS`) |

**Required:** `zone_name`

## Sub-types

| Sub-type | Provider | Status |
|----------|----------|--------|
| [DNS/Route53](infrastructure-cloud-dns-route53.md) | AWS Route 53 | Stable |
| [DNS/Cloud DNS](infrastructure-cloud-dns-cloud-dns.md) | Google Cloud DNS | Stable |
| [DNS/Azure DNS](infrastructure-cloud-dns-azure-dns.md) | Azure DNS | Stable |
| [DNS/Cloudflare](infrastructure-cloud-dns-cloudflare.md) | Cloudflare DNS | Stable |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/dns@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  zone_name: example.com
  zone_type: public
  records:
    - name: "@"
      type: A
      ttl: 300
      values:
        - 203.0.113.10
    - name: www
      type: CNAME
      ttl: 3600
      values:
        - example.com
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/DNS |
|------|-------------------------------------|
| raise | Provisions DNS zones and records via provider-specific plugins |
