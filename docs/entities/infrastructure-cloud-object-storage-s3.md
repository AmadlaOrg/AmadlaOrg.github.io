# Infrastructure/Cloud/ObjectStorage/S3

| Field | Value |
|-------|-------|
| **Purpose** | AWS S3 bucket configuration — encryption, CORS, replication, public access block |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/ObjectStorage/AWS/S3](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/object-storage/s3@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/ObjectStorage](infrastructure-cloud-object-storage.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `region` | string | AWS region for the S3 bucket |
| `encryption` | object | Server-side encryption configuration (`enabled`, `algorithm`, `kms_key_id`) |
| `encryption.algorithm` | string | Encryption algorithm (`AES256`, `aws:kms`) |
| `cors_rules` | array of objects | Cross-origin resource sharing rules (`allowed_origins[]`, `allowed_methods[]`, `allowed_headers[]`, `max_age_seconds`) |
| `replication` | object | Cross-region replication configuration (`enabled`, `destination_bucket`, `destination_region`) |
| `public_access_block` | object | Public access block (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`) |
| `logging` | object | Server access logging (`target_bucket`, `target_prefix`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/object-storage/s3@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/object-storage@v1.0.0
_body:
  bucket_name: my-app-assets
  region: us-east-1
  encryption:
    enabled: true
    algorithm: aws:kms
    kms_key_id: arn:aws:kms:us-east-1:123456789012:key/abc-123
  public_access_block:
    block_public_acls: true
    block_public_policy: true
    ignore_public_acls: true
    restrict_public_buckets: true
  replication:
    enabled: true
    destination_bucket: my-app-assets-replica
    destination_region: eu-west-1
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/ObjectStorage/S3 |
|------|--------------------------------------------------|
| raise | Provisions S3 buckets via raise-aws plugin |
