# Infrastructure/Cloud/ObjectStorage/Azure Blob

| Field | Value |
|-------|-------|
| **Purpose** | Azure Blob Storage account configuration — account tier, replication, access tier, soft delete |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/ObjectStorage/Azure/BlobStorage](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/object-storage/azure-blob@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/ObjectStorage](infrastructure-cloud-object-storage.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `account_name` | string | Storage account name |
| `account_tier` | string | Storage account tier (`Standard`, `Premium`) |
| `replication_type` | string | Data replication strategy (`LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS`) |
| `access_tier` | string | Default access tier for blobs (`Hot`, `Cool`, `Archive`) |
| `container_access_type` | string | Public access level for containers (`private`, `blob`, `container`) |
| `soft_delete` | object | Soft delete configuration (`enabled`, `retention_days`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/object-storage/azure-blob@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/object-storage@v1.0.0
_body:
  account_name: myappassets
  account_tier: Standard
  replication_type: GRS
  access_tier: Hot
  container_access_type: private
  soft_delete:
    enabled: true
    retention_days: 30
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/ObjectStorage/Azure Blob |
|------|----------------------------------------------------------|
| raise | Provisions Azure Blob Storage via raise-azure plugin |
