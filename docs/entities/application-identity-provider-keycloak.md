# Application/IdentityProvider/Keycloak

| Field | Value |
|-------|-------|
| **Purpose** | Keycloak-specific configuration — full-featured IAM with realms, SMTP, and proxy modes |
| **Repo** | [AmadlaOrg/Entities/Application/IdentityProvider/Keycloak](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/identity-provider/keycloak@v1.0.0` |
| **Parent type** | [Application/IdentityProvider](application-identity-provider.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `hostname` | string | Public hostname for Keycloak |
| `database.vendor` | string | Database vendor (`postgres`, `mysql`, `mariadb`, `mssql`, `h2`) |
| `database.url` | string | JDBC connection URL |
| `database.username` | string | Database username |
| `database.password_secret` | string | Doorman secret reference for database password |
| `realms` | array of objects | Realm definitions (see below) |
| `smtp.host` | string | SMTP host |
| `smtp.port` | integer | SMTP port |
| `smtp.from` | string | From email address |
| `smtp.user` | string | SMTP username |
| `smtp.password_secret` | string | Doorman secret reference for SMTP password |
| `smtp.starttls` | boolean | Whether to use STARTTLS |
| `proxy_mode` | string | Reverse proxy mode (`edge`, `reencrypt`, `passthrough`, `none`) |
| `features` | array of strings | Enabled Keycloak features (e.g., `docker`, `scripts`, `token-exchange`) |
| `metrics_enabled` | boolean | Whether Prometheus metrics endpoint is enabled |

**Realm object:**

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Realm name |
| `display_name` | string | Realm display name |
| `enabled` | boolean | Whether the realm is enabled |
| `sso_session_idle_timeout` | string | SSO session idle timeout (e.g., `30m`) |
| `sso_session_max_lifespan` | string | SSO session max lifespan (e.g., `10h`) |

## Example

```yaml
_type: amadla.org/entity/application/identity-provider/keycloak@v1.0.0
_extends: amadla.org/entity/application/identity-provider@v1.0.0
_body:
  listen_port: 8443
  admin_user: admin
  admin_password_secret: doorman://vault/keycloak/admin-password
  hostname: auth.example.com
  database:
    vendor: postgres
    url: jdbc:postgresql://db.internal:5432/keycloak
    username: keycloak
    password_secret: doorman://vault/keycloak/db-password
  realms:
    - name: production
      display_name: Production
      enabled: true
      sso_session_idle_timeout: 30m
      sso_session_max_lifespan: 10h
  smtp:
    host: smtp.example.com
    port: 587
    from: noreply@example.com
    user: keycloak
    password_secret: doorman://vault/keycloak/smtp-password
    starttls: true
  proxy_mode: edge
  features:
    - token-exchange
    - scripts
  metrics_enabled: true
```

## Consumers

| Tool | How It Uses Application/IdentityProvider/Keycloak |
|------|---------------------------------------------------|
| [lay](../tools/lay.md) | Installs Keycloak |
| [weaver](../tools/weaver.md) | Generates `keycloak.conf` and realm import files |
| enjoin-service | Enables/starts the `keycloak` service |
