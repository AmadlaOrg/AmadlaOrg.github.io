# Infrastructure/Cloud/DNS/Azure DNS

| Field | Value |
|-------|-------|
| **Purpose** | Azure DNS-specific properties — resource group, zone type, virtual network links |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/DNS/Azure/AzureDNS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/dns/azure-dns@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/DNS](infrastructure-cloud-dns.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `resource_group` | string | Azure resource group name |
| `zone_type` | string | DNS zone type (`Public`, `Private`) |
| `virtual_network_links` | array of objects | Virtual network links for private DNS zones (`name`, `virtual_network_id`, `registration_enabled`) |

**Required:** `resource_group`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/dns/azure-dns@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/dns@v1.0.0
_body:
  resource_group: dns-rg
  zone_type: Private
  zone_name: internal.example.com
  virtual_network_links:
    - name: hub-link
      virtual_network_id: /subscriptions/.../hub-vnet
      registration_enabled: true
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/DNS/Azure DNS |
|------|-----------------------------------------------|
| [raise](../tools/raise.md) | Provisions Azure DNS zones via raise-azure plugin |
