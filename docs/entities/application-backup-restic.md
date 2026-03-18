# Application/Backup/Restic

| Field | Value |
|-------|-------|
| **Purpose** | Restic-specific configuration — fast, secure, efficient deduplicating backup |
| **Repo** | [AmadlaOrg/Entities/Application/Backup/Restic](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/backup/restic@v1.0.0` |
| **Parent type** | [Application/Backup](application-backup.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `repository` | string | Repository URL (local path, `s3:`, `sftp:`, `rest:`, etc.) |
| `password_secret` | string | Doorman secret reference for the repository password |
| `forget_policy.keep_last` | integer | Number of last snapshots to keep |
| `forget_policy.keep_daily` | integer | Number of daily snapshots to keep |
| `forget_policy.keep_weekly` | integer | Number of weekly snapshots to keep |
| `forget_policy.keep_monthly` | integer | Number of monthly snapshots to keep |
| `forget_policy.keep_yearly` | integer | Number of yearly snapshots to keep |
| `check_interval` | string | How often to verify repository integrity (e.g., `7d`, `30d`) |

## Example

```yaml
_type: amadla.org/entity/application/backup/restic@v1.0.0
_extends: amadla.org/entity/application/backup@v1.0.0
_body:
  schedule: "0 2 * * *"
  paths:
    - /etc
    - /home
    - /var/lib
  exclude:
    - "*.tmp"
  repository: s3:s3.amazonaws.com/my-backup-bucket
  password_secret: doorman://vault/backup/restic-password
  forget_policy:
    keep_last: 5
    keep_daily: 7
    keep_weekly: 4
    keep_monthly: 12
    keep_yearly: 2
  check_interval: "7d"
```

## Consumers

| Tool | How It Uses Application/Backup/Restic |
|------|---------------------------------------|
| lay | Installs the `restic` binary |
| weaver | Generates backup scripts and systemd timer units |
| enjoin-service | Enables/starts `restic-backup.timer` |
