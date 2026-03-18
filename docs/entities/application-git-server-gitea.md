# Application/GitServer/Gitea

| Field | Value |
|-------|-------|
| **Purpose** | Gitea-specific configuration — lightweight, self-hosted Git service written in Go |
| **Repo** | [AmadlaOrg/Entities/Application/GitServer/Gitea](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/git-server/gitea@v1.0.0` |
| **Parent type** | [Application/GitServer](application-git-server.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `app_name` | string | Application display name |
| `run_mode` | string | Run mode: `dev` or `prod` |
| `database.type` | string | Database type: `sqlite3`, `mysql`, or `postgres` |
| `database.host` | string | Database host |
| `database.name` | string | Database name |
| `database.user` | string | Database user |
| `database.password_secret` | string | Doorman secret reference for database password |
| `lfs_enabled` | boolean | Whether Git LFS is enabled |
| `lfs_path` | string | Storage path for LFS objects |
| `mailer.enabled` | boolean | Whether the mailer is enabled |
| `mailer.smtp_addr` | string | SMTP server address |
| `mailer.smtp_port` | integer | SMTP server port |
| `mailer.from` | string | Sender email address |
| `mailer.user` | string | SMTP authentication user |
| `mailer.password_secret` | string | Doorman secret reference for SMTP password |
| `service.disable_registration` | boolean | Whether to disable user self-registration |
| `service.require_signin_view` | boolean | Whether to require sign-in to view content |
| `service.enable_captcha` | boolean | Whether to enable CAPTCHA on registration |
| `oauth2_enabled` | boolean | Whether OAuth2 provider is enabled |

## Example

```yaml
_type: amadla.org/entity/application/git-server/gitea@v1.0.0
_extends: amadla.org/entity/application/git-server@v1.0.0
_body:
  listen_port: 3000
  domain: git.example.com
  admin_user: admin
  admin_password_secret: doorman://vault/gitea/admin-password
  data_dir: /var/lib/gitea
  app_name: My Gitea
  run_mode: prod
  database:
    type: postgres
    host: db.example.com
    name: gitea
    user: gitea
    password_secret: doorman://vault/gitea/db-password
  lfs_enabled: true
  lfs_path: /var/lib/gitea/lfs
  mailer:
    enabled: true
    smtp_addr: smtp.example.com
    smtp_port: 587
    from: gitea@example.com
    user: gitea@example.com
    password_secret: doorman://vault/gitea/smtp-password
  service:
    disable_registration: true
    require_signin_view: false
    enable_captcha: false
  oauth2_enabled: true
```

## Consumers

| Tool | How It Uses Application/GitServer/Gitea |
|------|------------------------------------------|
| lay | Installs the `gitea` binary |
| weaver | Generates `app.ini` configuration |
| enjoin-service | Enables/starts the `gitea` service |
