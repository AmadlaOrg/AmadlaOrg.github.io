# Cron

| Field | Value |
|-------|-------|
| **Purpose** | Defines scheduled tasks — cron jobs or systemd timers |
| **Repo** | [AmadlaOrg/Entities/Cron](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/cron@v1.0.0` |

## Schema

Cron describes scheduled tasks:

- Job name, schedule (cron expression or systemd calendar spec), and command
- User to run as
- Environment variables and working directory
- Stdout/stderr log paths
- Failure handler command
- Timeout (kill after duration)
- State management (present/absent)
- Backend selection: crontab or systemd-timer (auto-detected if omitted)

## Example

```yaml
_type: amadla.org/entity/cron@v1.0.0
_body:
  backend: systemd-timer
  jobs:
    - name: db-backup
      schedule: "0 2 * * *"
      command: /usr/local/bin/backup-db.sh
      user: postgres
      timeout: 1h
      on_failure: "/usr/local/bin/notify-failure.sh db-backup"
      log_output: /var/log/backup/db-backup.log
      log_error: /var/log/backup/db-backup.err

    - name: cleanup-tmp
      schedule: "0 */6 * * *"
      command: "find /tmp -type f -mtime +7 -delete"
      user: root
```

## Consumers

| Tool | How It Uses Cron |
|------|------------------------|
| lay | Creates crontab entries or systemd timer units |
| judge | Validates that scheduled jobs exist and match requirements |
