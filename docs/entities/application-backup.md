# Application/Backup

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all backup applications |
| **Repo** | [AmadlaOrg/Entities/Application/Backup](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/backup@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `schedule` | string | Cron expression or systemd timer for backup schedule |
| `retention.daily` | integer | Number of daily backups to retain |
| `retention.weekly` | integer | Number of weekly backups to retain |
| `retention.monthly` | integer | Number of monthly backups to retain |
| `retention.yearly` | integer | Number of yearly backups to retain |
| `encryption.enabled` | boolean | Whether encryption is enabled |
| `encryption.password_secret` | string | Doorman secret reference for the encryption password |
| `paths` | array of strings | Paths to include in the backup |
| `exclude` | array of strings | Paths to exclude from the backup |

These properties are common across all backup implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [Backup/Restic](application-backup-restic.md) | Restic — fast, secure, efficient deduplicating backup | Modern, multi-backend |
| [Backup/Borg](application-backup-borg.md) | BorgBackup — deduplicating archiver with compression | Mature, SSH-based |

## Example

```yaml
_type: amadla.org/entity/application/backup@v1.0.0
_body:
  schedule: "0 2 * * *"
  retention:
    daily: 7
    weekly: 4
    monthly: 12
    yearly: 2
  encryption:
    enabled: true
    password_secret: doorman://vault/backup/encryption-key
  paths:
    - /etc
    - /home
    - /var/lib
  exclude:
    - /var/lib/docker
    - "*.tmp"
```

## Consumers

| Tool | How It Uses Application/Backup |
|------|-------------------------------|
| lay | Installs the backup application (restic, borg, etc.) |
| enjoin-service | Enables/starts backup timer or cron job |
| weaver | Generates backup configuration and wrapper scripts |
