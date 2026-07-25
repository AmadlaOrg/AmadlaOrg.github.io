# Application/GitServer/Gogs

| Field | Value |
|-------|-------|
| **Purpose** | Gogs-specific configuration — painless self-hosted Git service with minimal resource usage |
| **Repo** | [AmadlaOrg/Entities/Application/GitServer/Gogs](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/git-server/gogs@v1.0.0` |
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
| `repository_root` | string | Root directory for Git repositories |
| `disable_registration` | boolean | Whether to disable user self-registration |
| `require_sign_in_view` | boolean | Whether to require sign-in to view content |
| `mailer.enabled` | boolean | Whether the mailer is enabled |
| `mailer.host` | string | SMTP server host |
| `mailer.from` | string | Sender email address |
| `mailer.user` | string | SMTP authentication user |
| `mailer.password_secret` | string | Doorman secret reference for SMTP password |

## Example

```yaml
_type: amadla.org/entity/application/git-server/gogs@v1.0.0
_extends: amadla.org/entity/application/git-server@v1.0.0
_body:
  listen_port: 3000
  domain: gogs.example.com
  admin_user: admin
  admin_password_secret: doorman://vault/gogs/admin-password
  data_dir: /var/lib/gogs
  app_name: My Gogs
  run_mode: prod
  database:
    type: sqlite3
  repository_root: /var/lib/gogs/repositories
  disable_registration: true
  require_sign_in_view: false
  mailer:
    enabled: true
    host: smtp.example.com:587
    from: gogs@example.com
    user: gogs@example.com
    password_secret: doorman://vault/gogs/smtp-password
```

## Consumers

| Tool | How It Uses Application/GitServer/Gogs |
|------|----------------------------------------|
| [lay](../tools/lay.md) | Installs the `gogs` binary |
| [weaver](../tools/weaver.md) | Generates `app.ini` configuration |
| enjoin-service | Enables/starts the `gogs` service |
