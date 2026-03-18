# Application/IdentityProvider

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all identity provider applications |
| **Repo** | [AmadlaOrg/Entities/Application/IdentityProvider](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/identity-provider@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the identity provider listens on |
| `listen_port` | integer | Port the identity provider listens on |
| `issuer_url` | string | OIDC issuer URL |
| `admin_user` | string | Admin username |
| `admin_password_secret` | string | Doorman secret reference for admin password |

These properties are common across all identity provider implementations. Sub-types add provider-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [IdentityProvider/Keycloak](application-identity-provider-keycloak.md) | Keycloak — full-featured IAM with realms, SMTP, and proxy modes | Most common |
| [IdentityProvider/Authentik](application-identity-provider-authentik.md) | Authentik — modern identity provider with flows and branding | Feature-rich |
| [IdentityProvider/Dex](application-identity-provider-dex.md) | Dex — lightweight OIDC connector with pluggable backends | Lightweight |

## Example

```yaml
_type: amadla.org/entity/application/identity-provider@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 8443
  issuer_url: https://auth.example.com
  admin_user: admin
  admin_password_secret: doorman://vault/idp/admin-password
```

## Consumers

| Tool | How It Uses Application/IdentityProvider |
|------|-------------------------------------------|
| lay | Installs the identity provider application |
| weaver | Generates configuration files |
| enjoin-service | Enables/starts the identity provider service |
