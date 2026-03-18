# Infrastructure/Storage/MinIO

| Field | Value |
|-------|-------|
| **Purpose** | MinIO-specific configuration -- S3-compatible object storage for private clouds |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Storage/MinIO](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/storage/minio@v1.0.0` |
| **Parent type** | [Infrastructure/Storage](infrastructure-storage.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `root_user` | string | MinIO root/admin username |
| `root_password_secret` | string | Doorman secret reference for the root password |
| `volumes` | array of strings | Storage paths used by MinIO (e.g., `/data1`, `/data2`) |
| `console_address` | string | Network address the MinIO web console listens on |
| `console_port` | integer | Port the MinIO web console listens on |
| `server_url` | string | Public-facing S3 API URL |
| `region` | string | S3 region identifier |
| `erasure_coding` | boolean | Whether erasure coding is enabled for data protection |
| `distributed_nodes` | array of strings | Node addresses for distributed MinIO mode |

## Example

```yaml
_type: amadla.org/entity/infrastructure/storage/minio@v1.0.0
_extends: amadla.org/entity/infrastructure/storage@v1.0.0
_body:
  data_dir: /data/minio
  replication_factor: 2
  listen_address: 0.0.0.0
  listen_port: 9000
  storage_class: ssd
  root_user: minioadmin
  root_password_secret: doorman://vault/minio/root-password
  volumes:
    - /data1
    - /data2
    - /data3
    - /data4
  console_address: 0.0.0.0
  console_port: 9001
  server_url: https://s3.example.com
  region: us-east-1
  erasure_coding: true
  distributed_nodes:
    - minio1.example.com
    - minio2.example.com
    - minio3.example.com
    - minio4.example.com
```

## Consumers

| Tool | How It Uses Infrastructure/Storage/MinIO |
|------|------------------------------------------|
| raise | Provisions VMs/instances for MinIO nodes |
| lay | Installs the `minio` binary |
| weaver | Generates `/etc/default/minio` environment file |
| enjoin-service | Enables/starts `minio` service |
