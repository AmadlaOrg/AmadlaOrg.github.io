# Application/FTP/Vsftpd

| Field | Value |
|-------|-------|
| **Purpose** | Vsftpd-specific configuration — lightweight, secure FTP daemon, default on many Linux distributions |
| **Repo** | [AmadlaOrg/Entities/Application/FTP/Vsftpd](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/ftp/vsftpd@v1.0.0` |
| **Parent type** | [Application/FTP](application-ftp.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `write_enable` | boolean | Whether to allow write commands (upload, delete, mkdir, etc.) |
| `local_umask` | string | Umask for file creation by local users (e.g., `022`) |
| `chroot_local_user` | boolean | Whether to chroot local users to their home directory |
| `allow_writeable_chroot` | boolean | Whether to allow writable chroot directories |
| `userlist_enable` | boolean | Whether to enable the user list feature |
| `userlist_deny` | boolean | If false, only users in userlist_file are allowed (whitelist mode) |
| `userlist_file` | string | Path to the user list file |
| `xferlog_enable` | boolean | Whether to enable transfer logging |
| `xferlog_file` | string | Path to the transfer log file |
| `idle_session_timeout` | integer | Seconds before an idle session is disconnected |
| `data_connection_timeout` | integer | Seconds before a stalled data connection is closed |

## Example

```yaml
_type: amadla.org/entity/application/ftp/vsftpd@v1.0.0
_extends: amadla.org/entity/application/ftp@v1.0.0
_body:
  listen_port: 21
  tls:
    enabled: true
    cert: /etc/ssl/certs/vsftpd.pem
    key: /etc/ssl/private/vsftpd.key
    force: true
  anonymous_enabled: false
  write_enable: true
  local_umask: "022"
  chroot_local_user: true
  allow_writeable_chroot: false
  userlist_enable: true
  userlist_deny: false
  userlist_file: /etc/vsftpd.userlist
  xferlog_enable: true
  xferlog_file: /var/log/vsftpd.log
  idle_session_timeout: 600
  data_connection_timeout: 120
```

## Consumers

| Tool | How It Uses Application/FTP/Vsftpd |
|------|-----------------------------------|
| [lay](../tools/lay.md) | Installs the `vsftpd` package |
| [weaver](../tools/weaver.md) | Generates `/etc/vsftpd.conf` |
| enjoin-service | Enables/starts `vsftpd` service |
