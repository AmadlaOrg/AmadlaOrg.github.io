# Application/IdentityProvider/Authentik

| Field | Value |
|-------|-------|
| **Purpose** | Authentik-specific configuration — modern identity provider with flows and branding |
| **Repo** | [AmadlaOrg/Entities/Application/IdentityProvider/Authentik](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/identity-provider/authentik@v1.0.0` |
| **Parent type** | [Application/IdentityProvider](application-identity-provider.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `secret_key_secret` | string | Doorman secret reference for the Authentik secret key |
| `database.host` | string | Database host |
| `database.port` | integer | Database port |
| `database.name` | string | Database name |
| `database.user` | string | Database user |
| `database.password_secret` | string | Doorman secret reference for database password |
| `redis.host` | string | Redis host |
| `redis.port` | integer | Redis port |
| `redis.password_secret` | string | Doorman secret reference for Redis password |
| `email.host` | string | SMTP host |
| `email.port` | integer | SMTP port |
| `email.from` | string | From email address |
| `email.username` | string | SMTP username |
| `email.password_secret` | string | Doorman secret reference for SMTP password |
| `email.use_tls` | boolean | Whether to use TLS for email |
| `error_reporting.enabled` | boolean | Whether error reporting is enabled |
| `error_reporting.environment` | string | Environment name for error reports |
| `footer_links` | array of objects | Custom footer links (`name`, `href`) |

## Example

```yaml
_type: amadla.org/entity/application/identity-provider/authentik@v1.0.0
_extends: amadla.org/entity/application/identity-provider@v1.0.0
_body:
  listen_port: 9000
  issuer_url: https://auth.example.com
  admin_user: akadmin
  admin_password_secret: doorman://vault/authentik/admin-password
  secret_key_secret: doorman://vault/authentik/secret-key
  database:
    host: db.internal
    port: 5432
    name: authentik
    user: authentik
    password_secret: doorman://vault/authentik/db-password
  redis:
    host: redis.internal
    port: 6379
    password_secret: doorman://vault/authentik/redis-password
  email:
    host: smtp.example.com
    port: 587
    from: noreply@example.com
    username: authentik
    password_secret: doorman://vault/authentik/smtp-password
    use_tls: true
  error_reporting:
    enabled: false
  footer_links:
    - name: Support
      href: https://support.example.com
```

## Consumers

| Tool | How It Uses Application/IdentityProvider/Authentik |
|------|-----------------------------------------------------|
| [lay](../tools/lay.md) | Installs Authentik |
| [weaver](../tools/weaver.md) | Generates Authentik environment and configuration files |
| enjoin-service | Enables/starts the `authentik-server` and `authentik-worker` services |
