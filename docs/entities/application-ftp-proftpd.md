# Application/FTP/ProFTPD

| Field | Value |
|-------|-------|
| **Purpose** | ProFTPD-specific configuration — highly configurable FTP daemon with Apache-style config |
| **Repo** | [AmadlaOrg/Entities/Application/FTP/ProFTPD](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/ftp/proftpd@v1.0.0` |
| **Parent type** | [Application/FTP](application-ftp.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `server_name` | string | Server name displayed to clients |
| `server_type` | string | Server operation mode (`standalone` or `inetd`) |
| `max_instances` | integer | Maximum number of child processes (standalone mode) |
| `default_server` | boolean | Whether this is the default server for unmatched connections |
| `virtual_hosts` | array of objects | Virtual host definitions (address, server_name, root, config) |
| `modules` | array of strings | Modules to load (e.g., `mod_tls`, `mod_sql`, `mod_ldap`) |
| `sql_backend.engine` | string | SQL database engine (`mysql` or `postgres`) |
| `sql_backend.host` | string | Database host |
| `sql_backend.database` | string | Database name |
| `sql_backend.user` | string | Database user |
| `sql_backend.password_secret` | string | Doorman secret reference for database password |

## Example

```yaml
_type: amadla.org/entity/application/ftp/proftpd@v1.0.0
_extends: amadla.org/entity/application/ftp@v1.0.0
_body:
  listen_port: 21
  tls:
    enabled: true
    cert: /etc/ssl/certs/proftpd.pem
    key: /etc/ssl/private/proftpd.key
  server_name: "FTP Server"
  server_type: standalone
  max_instances: 30
  default_server: true
  modules:
    - mod_tls
    - mod_sql
    - mod_sql_mysql
  sql_backend:
    engine: mysql
    host: localhost
    database: proftpd
    user: proftpd
    password_secret: doorman://vault/proftpd/db-password
```

## Consumers

| Tool | How It Uses Application/FTP/ProFTPD |
|------|-------------------------------------|
| lay | Installs the `proftpd` package |
| weaver | Generates `/etc/proftpd/proftpd.conf` |
| enjoin-service | Enables/starts `proftpd` service |
