# Application/AuthProxy

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all authentication proxy applications |
| **Repo** | [AmadlaOrg/Entities/Application/AuthProxy](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/auth-proxy@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the auth proxy listens on |
| `listen_port` | integer | Port the auth proxy listens on |
| `upstream` | string | URL of the protected upstream application |
| `cookie_secret_secret` | string | Doorman secret reference for cookie encryption key |
| `cookie_name` | string | Name of the session cookie |
| `cookie_secure` | boolean | Whether the session cookie requires HTTPS (default: `true`) |
| `email_domains` | array of strings | Allowed email domains for authentication |

These properties are common across all authentication proxy implementations. Sub-types add provider-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [AuthProxy/OAuth2Proxy](application-auth-proxy-oauth2-proxy.md) | OAuth2 Proxy — multi-provider OAuth2 reverse proxy | Most common |
| [AuthProxy/Authelia](application-auth-proxy-authelia.md) | Authelia — SSO and 2FA authentication server | Feature-rich |
| [AuthProxy/KeycloakGatekeeper](application-auth-proxy-keycloak-gatekeeper.md) | Keycloak Gatekeeper — Keycloak-integrated auth proxy | Keycloak ecosystems |

## Example

```yaml
_type: amadla.org/entity/application/auth-proxy@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 4180
  upstream: http://localhost:8080
  cookie_secret_secret: doorman://vault/auth-proxy/cookie-secret
  cookie_name: _oauth2_proxy
  cookie_secure: true
  email_domains:
    - example.com
```

## Consumers

| Tool | How It Uses Application/AuthProxy |
|------|-----------------------------------|
| lay | Installs the authentication proxy application |
| enjoin-service | Enables/starts the auth proxy service |
| weaver | Generates configuration files |
