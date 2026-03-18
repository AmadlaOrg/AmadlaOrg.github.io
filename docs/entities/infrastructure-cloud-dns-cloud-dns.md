# Infrastructure/Cloud/DNS/Cloud DNS

| Field | Value |
|-------|-------|
| **Purpose** | Google Cloud DNS-specific properties — visibility, private zone config, DNSSEC |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/DNS/GCP/CloudDNS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/dns/cloud-dns@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/DNS](infrastructure-cloud-dns.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `dns_name` | string | Zone DNS name with trailing dot (e.g., `example.com.`) |
| `visibility` | string | Zone visibility (`public`, `private`) |
| `private_visibility_config` | object | Private zone visibility configuration |
| `private_visibility_config.networks` | array of strings | VPC network self links that can see this zone |
| `dnssec_config` | object | DNSSEC configuration (`state`, `default_key_specs[]`) |
| `dnssec_config.state` | string | Whether DNSSEC is enabled (`on`, `off`) |

**Required:** `dns_name`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/dns/cloud-dns@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/dns@v1.0.0
_body:
  dns_name: example.com.
  visibility: public
  dnssec_config:
    state: "on"
  records:
    - name: "@"
      type: A
      ttl: 300
      values:
        - 203.0.113.10
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/DNS/Cloud DNS |
|------|-----------------------------------------------|
| raise | Provisions Cloud DNS zones via raise-gcp plugin |
