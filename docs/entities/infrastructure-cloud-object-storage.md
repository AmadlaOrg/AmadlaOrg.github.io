# Infrastructure/Cloud/ObjectStorage

| Field | Value |
|-------|-------|
| **Purpose** | Common object storage properties — bucket name, ACL, versioning, lifecycle rules |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/ObjectStorage](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/object-storage@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `bucket_name` | string | Name of the storage bucket |
| `acl` | string | Access control list (`private`, `public-read`, `public-read-write`) |
| `versioning` | boolean | Enable object versioning |
| `lifecycle_rules` | array of objects | Lifecycle management rules (`prefix`, `expiration_days`, `transition`) |

## Sub-types

| Sub-type | Provider |
|----------|----------|
| [ObjectStorage/S3](infrastructure-cloud-object-storage-s3.md) | AWS S3 |
| [ObjectStorage/GCS](infrastructure-cloud-object-storage-gcs.md) | Google Cloud Storage |
| [ObjectStorage/Azure Blob](infrastructure-cloud-object-storage-azure-blob.md) | Azure Blob Storage |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/object-storage@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  bucket_name: my-app-assets
  acl: private
  versioning: true
  lifecycle_rules:
    - prefix: logs/
      expiration_days: 90
    - prefix: backups/
      transition:
        days: 30
        storage_class: GLACIER
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/ObjectStorage |
|------|----------------------------------------------|
| [raise](../tools/raise.md) | Provisions storage buckets via provider-specific plugins |
