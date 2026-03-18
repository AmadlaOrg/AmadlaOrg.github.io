# Application/FTP/PureFTPD

| Field | Value |
|-------|-------|
| **Purpose** | Pure-FTPd-specific configuration — security-focused FTP daemon with virtual user support |
| **Repo** | [AmadlaOrg/Entities/Application/FTP/PureFTPD](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/ftp/pure-ftpd@v1.0.0` |
| **Parent type** | [Application/FTP](application-ftp.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `max_clients` | integer | Maximum number of simultaneous clients |
| `max_clients_per_ip` | integer | Maximum number of simultaneous clients from the same IP |
| `min_uid` | integer | Minimum UID allowed to login |
| `no_anonymous` | boolean | Whether to disable anonymous access |
| `chroot_everyone` | boolean | Whether to chroot all users to their home directory |
| `create_home_dirs` | boolean | Whether to create home directories on first login |
| `quota.max_files` | integer | Maximum number of files per user |
| `quota.max_size` | string | Maximum storage size per user (e.g., `1G`, `500M`) |
| `throttle.bandwidth_upload` | integer | Upload bandwidth limit in KB/s |
| `throttle.bandwidth_download` | integer | Download bandwidth limit in KB/s |

## Example

```yaml
_type: amadla.org/entity/application/ftp/pure-ftpd@v1.0.0
_extends: amadla.org/entity/application/ftp@v1.0.0
_body:
  listen_port: 21
  tls:
    enabled: true
    cert: /etc/ssl/certs/pure-ftpd.pem
    key: /etc/ssl/private/pure-ftpd.key
    force: true
  max_clients: 50
  max_clients_per_ip: 5
  min_uid: 1000
  no_anonymous: true
  chroot_everyone: true
  create_home_dirs: true
  quota:
    max_files: 10000
    max_size: 1G
  throttle:
    bandwidth_upload: 1024
    bandwidth_download: 2048
```

## Consumers

| Tool | How It Uses Application/FTP/PureFTPD |
|------|--------------------------------------|
| lay | Installs the `pure-ftpd` package |
| weaver | Generates Pure-FTPd configuration files |
| enjoin-service | Enables/starts `pure-ftpd` service |
