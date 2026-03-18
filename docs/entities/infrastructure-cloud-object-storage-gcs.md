# Infrastructure/Cloud/ObjectStorage/GCS

| Field | Value |
|-------|-------|
| **Purpose** | Google Cloud Storage bucket configuration — location, storage class, uniform access, retention |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/ObjectStorage/GCP/GCS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/object-storage/gcs@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/ObjectStorage](infrastructure-cloud-object-storage.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `location` | string | Bucket location (e.g., `US`, `EU`, `us-central1`) |
| `storage_class` | string | Storage class (`STANDARD`, `NEARLINE`, `COLDLINE`, `ARCHIVE`) |
| `uniform_bucket_level_access` | boolean | Enable uniform bucket-level access control |
| `retention_policy` | object | Retention policy for objects |
| `retention_policy.retention_period` | integer | Retention period in seconds |
| `labels` | object | Labels for the bucket |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/object-storage/gcs@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/object-storage@v1.0.0
_body:
  bucket_name: my-project-assets
  location: US
  storage_class: STANDARD
  uniform_bucket_level_access: true
  versioning: true
  labels:
    team: platform
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/ObjectStorage/GCS |
|------|---------------------------------------------------|
| raise | Provisions GCS buckets via raise-gcp plugin |
