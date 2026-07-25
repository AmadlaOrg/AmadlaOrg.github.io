# Application/AuthProxy/Authelia

| Field | Value |
|-------|-------|
| **Purpose** | Authelia-specific configuration — SSO and multi-factor authentication server with per-domain access control |
| **Repo** | [AmadlaOrg/Entities/Application/AuthProxy/Authelia](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/auth-proxy/authelia@v1.0.0` |
| **Parent type** | [Application/AuthProxy](application-auth-proxy.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `default_policy` | string | Default access control policy: `bypass`, `one_factor`, `two_factor`, or `deny` |
| `access_control` | array of objects | Access control rules per domain |
| `access_control[].domain` | string | Domain to match |
| `access_control[].policy` | string | Policy for this domain |
| `access_control[].subject` | array of strings | Subjects this rule applies to (e.g., `group:admins`) |
| `session.domain` | string | Cookie domain for sessions |
| `session.expiration` | string | Session expiration duration (e.g., `1h`) |
| `session.inactivity` | string | Session inactivity timeout (e.g., `5m`) |
| `session.redis.host` | string | Redis host for session storage |
| `session.redis.port` | integer | Redis port for session storage |
| `storage.local.path` | string | Path to SQLite database file |
| `storage.mysql` | object | MySQL storage backend (host, port, database, username, password_secret) |
| `storage.postgres` | object | PostgreSQL storage backend (host, port, database, username, password_secret) |
| `authentication_backend.file.path` | string | Path to the users file |
| `authentication_backend.ldap` | object | LDAP backend (url, base_dn, username_attribute, users_filter) |
| `notifier.smtp` | object | SMTP notifier (host, port, sender, username, password_secret) |
| `notifier.filesystem.filename` | string | Path to notification output file (development) |
| `totp.issuer` | string | TOTP issuer name shown in authenticator apps |
| `totp.period` | integer | TOTP token validity period in seconds |
| `totp.digits` | integer | Number of digits in TOTP token |

## Example

```yaml
_type: amadla.org/entity/application/auth-proxy/authelia@v1.0.0
_extends: amadla.org/entity/application/auth-proxy@v1.0.0
_body:
  listen_port: 9091
  default_policy: two_factor
  access_control:
    - domain: public.example.com
      policy: bypass
    - domain: admin.example.com
      policy: two_factor
      subject:
        - group:admins
    - domain: "*.example.com"
      policy: one_factor
  session:
    domain: example.com
    expiration: 1h
    inactivity: 5m
    redis:
      host: redis.example.com
      port: 6379
  storage:
    postgres:
      host: db.example.com
      port: 5432
      database: authelia
      username: authelia
      password_secret: doorman://vault/authelia/db-password
  authentication_backend:
    ldap:
      url: ldap://ldap.example.com
      base_dn: dc=example,dc=com
      username_attribute: uid
      users_filter: "(&(|({username_attribute}={input}))(objectClass=person))"
  totp:
    issuer: example.com
    period: 30
    digits: 6
```

## Consumers

| Tool | How It Uses Application/AuthProxy/Authelia |
|------|---------------------------------------------|
| [lay](../tools/lay.md) | Installs the `authelia` binary |
| [weaver](../tools/weaver.md) | Generates `configuration.yml` |
| enjoin-service | Enables/starts the `authelia` service |
