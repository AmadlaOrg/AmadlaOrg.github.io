# Infrastructure/Cloud/Database/Azure Database

| Field | Value |
|-------|-------|
| **Purpose** | Azure Database managed instance configuration — SKU, geo-redundant backup, SSL, firewall rules |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Database/Azure/AzureDatabase](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/database/azure-database@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Database](infrastructure-cloud-database.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `sku_name` | string | SKU name (e.g., `GP_Gen5_2`) |
| `storage_mb` | integer | Maximum storage in megabytes |
| `geo_redundant_backup_enabled` | boolean | Enable geo-redundant backups |
| `auto_grow_enabled` | boolean | Enable storage auto-grow |
| `ssl_enforcement_enabled` | boolean | Enforce SSL connections |
| `firewall_rules` | array of objects | IP-based access control rules (`name`, `start_ip_address`, `end_ip_address`) |
| `virtual_network_rules` | array of objects | Subnet-based access control rules (`name`, `subnet_id`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/database/azure-database@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/database@v1.0.0
_body:
  engine: postgres
  sku_name: GP_Gen5_2
  storage_mb: 102400
  geo_redundant_backup_enabled: true
  auto_grow_enabled: true
  ssl_enforcement_enabled: true
  firewall_rules:
    - name: office-ip
      start_ip_address: 203.0.113.10
      end_ip_address: 203.0.113.10
  virtual_network_rules:
    - name: app-subnet
      subnet_id: /subscriptions/.../app-subnet
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Database/Azure Database |
|------|--------------------------------------------------------|
| [raise](../tools/raise.md) | Provisions Azure Database instances via raise-azure plugin |
