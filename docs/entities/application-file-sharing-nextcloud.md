# Application/FileSharing/Nextcloud

| Field | Value |
|-------|-------|
| **Purpose** | Nextcloud-specific configuration — self-hosted productivity platform with file sync, collaboration, and apps |
| **Repo** | [AmadlaOrg/Entities/Application/FileSharing/Nextcloud](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/file-sharing/nextcloud@v1.0.0` |
| **Parent type** | [Application/FileSharing](application-file-sharing.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `admin_user` | string | Administrator username |
| `admin_password_secret` | string | Doorman secret reference for the admin password |
| `database.type` | string | Database backend type (`sqlite`, `mysql`, or `pgsql`) |
| `database.host` | string | Database host address |
| `database.name` | string | Database name |
| `database.user` | string | Database username |
| `database.password_secret` | string | Doorman secret reference for the database password |
| `trusted_domains` | array of strings | List of trusted domains allowed to access Nextcloud |
| `default_phone_region` | string | Default phone region as ISO 3166-1 country code (e.g., `US`, `DE`) |
| `mail.mode` | string | Mail sending mode (e.g., `smtp`) |
| `mail.smtp_host` | string | SMTP server hostname |
| `mail.smtp_port` | integer | SMTP server port |
| `mail.smtp_secure` | string | SMTP encryption type (`ssl` or `tls`) |
| `mail.from_address` | string | Sender email address (local part) |
| `mail.domain` | string | Sender email domain |
| `apps` | array of strings | Nextcloud apps to install and enable |
| `redis.host` | string | Redis server hostname |
| `redis.port` | integer | Redis server port |
| `redis.password_secret` | string | Doorman secret reference for the Redis password |
| `object_store.class` | string | Object storage class (`S3` or `Swift`) |
| `object_store.bucket` | string | Storage bucket name |
| `object_store.region` | string | Storage region |
| `object_store.key` | string | Access key identifier |
| `object_store.secret_secret` | string | Doorman secret reference for the storage secret key |

## Example

```yaml
_type: amadla.org/entity/application/file-sharing/nextcloud@v1.0.0
_extends: amadla.org/entity/application/file-sharing@v1.0.0
_body:
  listen_port: 443
  data_dir: /srv/nextcloud/data
  max_upload_size: 10G
  admin_user: admin
  admin_password_secret: doorman://vault/nextcloud/admin-password
  database:
    type: pgsql
    host: localhost
    name: nextcloud
    user: nextcloud
    password_secret: doorman://vault/nextcloud/db-password
  trusted_domains:
    - cloud.example.com
  default_phone_region: US
  apps:
    - calendar
    - contacts
    - deck
  redis:
    host: localhost
    port: 6379
```

## Consumers

| Tool | How It Uses Application/FileSharing/Nextcloud |
|------|-----------------------------------------------|
| [lay](../tools/lay.md) | Installs Nextcloud (PHP, web server, dependencies) |
| [weaver](../tools/weaver.md) | Generates `config.php`, Apache/Nginx vhost, PHP pool config |
| enjoin-service | Enables/starts web server and PHP-FPM services |
