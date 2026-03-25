# Application/Backup/Borg

| Field | Value |
|-------|-------|
| **Purpose** | BorgBackup-specific configuration — deduplicating archiver with compression and encryption |
| **Repo** | [AmadlaOrg/Entities/Application/Backup/Borg](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/backup/borg@v1.0.0` |
| **Parent type** | [Application/Backup](application-backup.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `repository` | string | Repository path (local path or `ssh://user@host/path`) |
| `passphrase_secret` | string | Doorman secret reference for the repository passphrase |
| `compression` | string | Compression algorithm for archives (`none`, `lz4`, `zstd`, `zlib`, `lzma`) |
| `prune.keep_daily` | integer | Number of daily archives to keep |
| `prune.keep_weekly` | integer | Number of weekly archives to keep |
| `prune.keep_monthly` | integer | Number of monthly archives to keep |
| `prune.keep_yearly` | integer | Number of yearly archives to keep |

## Example

```yaml
_type: amadla.org/entity/application/backup/borg@v1.0.0
_extends: amadla.org/entity/application/backup@v1.0.0
_body:
  schedule: "0 3 * * *"
  paths:
    - /etc
    - /home
    - /var/lib
  encryption:
    enabled: true
  repository: ssh://backup@storage.example.com/srv/borg/webserver01
  passphrase_secret: doorman://vault/backup/borg-passphrase
  compression: zstd
  prune:
    keep_daily: 7
    keep_weekly: 4
    keep_monthly: 6
    keep_yearly: 1
```

## Consumers

| Tool | How It Uses Application/Backup/Borg |
|------|--------------------------------------|
| [lay](../tools/lay.md) | Installs the `borgbackup` package |
| [weaver](../tools/weaver.md) | Generates backup scripts and systemd timer units |
| enjoin-service | Enables/starts `borg-backup.timer` |
