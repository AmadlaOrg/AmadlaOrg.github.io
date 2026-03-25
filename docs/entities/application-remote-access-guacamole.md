# Application/RemoteAccess/Guacamole

| Field | Value |
|-------|-------|
| **Purpose** | Apache Guacamole-specific configuration — clientless remote desktop gateway accessible via web browser |
| **Repo** | [AmadlaOrg/Entities/Application/RemoteAccess/Guacamole](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/remote-access/guacamole@v1.0.0` |
| **Parent type** | [Application/RemoteAccess](application-remote-access.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `guacd_hostname` | string | Hostname of the guacd proxy daemon |
| `guacd_port` | integer | Port of the guacd proxy daemon (default: `4822`) |
| `database.type` | string | Database backend type (`mysql` or `postgresql`) |
| `database.hostname` | string | Database host address |
| `database.port` | integer | Database port |
| `database.database` | string | Database name |
| `database.username` | string | Database username |
| `database.password_secret` | string | Doorman secret reference for the database password |
| `totp_enabled` | boolean | Whether two-factor authentication via TOTP is enabled |
| `ldap.hostname` | string | LDAP server hostname |
| `ldap.port` | integer | LDAP server port |
| `ldap.user_base_dn` | string | Base DN for user searches |
| `ldap.username_attribute` | string | LDAP attribute used as the username |
| `ldap.search_bind_dn` | string | DN used to bind for LDAP searches |
| `ldap.search_bind_password_secret` | string | Doorman secret reference for the LDAP bind password |
| `connections` | array of objects | Pre-configured remote connections |
| `connections[].name` | string | Connection display name |
| `connections[].protocol` | string | Connection protocol (`rdp`, `vnc`, `ssh`, or `telnet`) |
| `connections[].hostname` | string | Target host address |
| `connections[].port` | integer | Target port |
| `connections[].username` | string | Connection username |
| `connections[].password_secret` | string | Doorman secret reference for the connection password |
| `connections[].parameters` | object | Additional protocol-specific parameters |

## Example

```yaml
_type: amadla.org/entity/application/remote-access/guacamole@v1.0.0
_extends: amadla.org/entity/application/remote-access@v1.0.0
_body:
  listen_port: 8080
  auth_required: true
  guacd_hostname: localhost
  guacd_port: 4822
  database:
    type: postgresql
    hostname: localhost
    port: 5432
    database: guacamole
    username: guacamole
    password_secret: doorman://vault/guacamole/db-password
  totp_enabled: true
  connections:
    - name: Web Server
      protocol: ssh
      hostname: 10.0.1.10
      port: 22
      username: admin
      password_secret: doorman://vault/guacamole/conn-webserver
    - name: Desktop
      protocol: rdp
      hostname: 10.0.1.20
      port: 3389
      username: user
      password_secret: doorman://vault/guacamole/conn-desktop
```

## Consumers

| Tool | How It Uses Application/RemoteAccess/Guacamole |
|------|------------------------------------------------|
| [lay](../tools/lay.md) | Installs Guacamole server, guacd, and dependencies |
| [weaver](../tools/weaver.md) | Generates `guacamole.properties`, Tomcat/Nginx config |
| enjoin-service | Enables/starts `guacd` and `tomcat` services |
