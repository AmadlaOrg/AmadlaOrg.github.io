# Application/FTP

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all FTP server applications |
| **Repo** | [AmadlaOrg/Entities/Application/FTP](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/ftp@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the FTP server listens on |
| `listen_port` | integer | Port the FTP server listens on (default: `21`) |
| `passive_ports.min` | integer | Minimum passive port |
| `passive_ports.max` | integer | Maximum passive port |
| `tls.enabled` | boolean | Whether TLS is enabled |
| `tls.cert` | string | Path to TLS certificate |
| `tls.key` | string | Path to TLS private key |
| `tls.force` | boolean | Whether to force TLS for all connections |
| `anonymous_enabled` | boolean | Whether anonymous FTP access is allowed (default: `false`) |
| `local_root` | string | Default root directory for local users |

These properties are common across all FTP implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [FTP/Vsftpd](application-ftp-vsftpd.md) | vsftpd — lightweight, secure FTP daemon | Most common on Linux |
| [FTP/ProFTPD](application-ftp-proftpd.md) | ProFTPD — highly configurable, Apache-style config | Feature-rich |
| [FTP/PureFTPD](application-ftp-pure-ftpd.md) | Pure-FTPd — security-focused with virtual users | BSD-friendly |

## Example

```yaml
_type: amadla.org/entity/application/ftp@v1.0.0
_body:
  listen_port: 21
  passive_ports:
    min: 40000
    max: 40100
  tls:
    enabled: true
    cert: /etc/ssl/certs/ftp.pem
    key: /etc/ssl/private/ftp.key
    force: true
  anonymous_enabled: false
  local_root: /srv/ftp
```

## Consumers

| Tool | How It Uses Application/FTP |
|------|----------------------------|
| lay | Installs the FTP server package |
| weaver | Generates FTP server configuration files |
| enjoin-service | Enables/starts the FTP service |
