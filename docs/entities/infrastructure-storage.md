# Infrastructure/Storage

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all distributed storage systems |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Storage](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/storage@v1.0.0` |
| **Parent type** | [Infrastructure](infrastructure.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `data_dir` | string | Primary data directory for storage |
| `replication_factor` | integer | Number of data copies maintained across the cluster |
| `listen_address` | string | Network address the storage service listens on |
| `listen_port` | integer | Port the storage service listens on |
| `storage_class` | string | Storage tier (e.g., `standard`, `ssd`, `archive`) |

These properties are common across all distributed storage implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [Storage/MinIO](infrastructure-storage-minio.md) | MinIO -- S3-compatible object storage | Most common for S3 API |
| [Storage/Ceph](infrastructure-storage-ceph.md) | Ceph -- unified block, object, and file storage | Enterprise, OpenStack |
| [Storage/GlusterFS](infrastructure-storage-glusterfs.md) | GlusterFS -- distributed POSIX filesystem | File-level replication |

## Example

```yaml
_type: amadla.org/entity/infrastructure/storage@v1.0.0
_body:
  data_dir: /data/storage
  replication_factor: 3
  listen_address: 0.0.0.0
  listen_port: 9000
  storage_class: ssd
```

## Consumers

| Tool | How It Uses Infrastructure/Storage |
|------|-------------------------------------|
| raise | Provisions VMs/instances for storage nodes |
| lay | Installs the storage application (minio, ceph, glusterfs) |
| enjoin-service | Enables/starts the storage service |
