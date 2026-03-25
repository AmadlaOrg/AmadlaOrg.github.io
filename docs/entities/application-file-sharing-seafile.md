# Application/FileSharing/Seafile

| Field | Value |
|-------|-------|
| **Purpose** | Seafile-specific configuration — high-performance file sync with delta transfer and encryption |
| **Repo** | [AmadlaOrg/Entities/Application/FileSharing/Seafile](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/file-sharing/seafile@v1.0.0` |
| **Parent type** | [Application/FileSharing](application-file-sharing.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `admin_email` | string | Administrator email address |
| `admin_password_secret` | string | Doorman secret reference for the admin password |
| `database.type` | string | Database backend type (`sqlite` or `mysql`) |
| `database.host` | string | Database host address |
| `database.port` | integer | Database port |
| `database.user` | string | Database username |
| `database.password_secret` | string | Doorman secret reference for the database password |
| `file_server_port` | integer | Port for the Seafile file server |
| `max_upload_size` | integer | Maximum upload file size in MB |
| `enable_thumbnail` | boolean | Whether to enable thumbnail generation for files |
| `storage_backend.type` | string | Storage backend type (`filesystem`, `s3`, or `ceph`) |
| `storage_backend.config` | object | Backend-specific configuration parameters |

## Example

```yaml
_type: amadla.org/entity/application/file-sharing/seafile@v1.0.0
_extends: amadla.org/entity/application/file-sharing@v1.0.0
_body:
  listen_port: 443
  data_dir: /srv/seafile/data
  admin_email: admin@example.com
  admin_password_secret: doorman://vault/seafile/admin-password
  database:
    type: mysql
    host: localhost
    port: 3306
    user: seafile
    password_secret: doorman://vault/seafile/db-password
  file_server_port: 8082
  max_upload_size: 5120
  enable_thumbnail: true
  storage_backend:
    type: filesystem
```

## Consumers

| Tool | How It Uses Application/FileSharing/Seafile |
|------|---------------------------------------------|
| [lay](../tools/lay.md) | Installs Seafile server and dependencies |
| [weaver](../tools/weaver.md) | Generates `seahub_settings.py`, Nginx proxy config |
| enjoin-service | Enables/starts `seafile` and `seahub` services |
