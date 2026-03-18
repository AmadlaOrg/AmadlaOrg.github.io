# Application/IdentityProvider/Dex

| Field | Value |
|-------|-------|
| **Purpose** | Dex-specific configuration — lightweight OIDC connector with pluggable backends |
| **Repo** | [AmadlaOrg/Entities/Application/IdentityProvider/Dex](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/identity-provider/dex@v1.0.0` |
| **Parent type** | [Application/IdentityProvider](application-identity-provider.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `issuer` | string | Issuer URL for OIDC discovery |
| `storage.type` | string | Storage backend type (`sqlite3`, `postgres`, `mysql`, `kubernetes`) |
| `storage.config` | object | Storage-specific configuration |
| `connectors` | array of objects | Identity provider connectors (see below) |
| `static_clients` | array of objects | Statically configured OAuth2 clients (see below) |
| `enable_password_db` | boolean | Whether to enable the local password database |
| `static_passwords` | array of objects | Statically configured user passwords (development/testing) |

**Connector object:**

| Property | Type | Description |
|----------|------|-------------|
| `type` | string | Connector type (`ldap`, `github`, `gitlab`, `oidc`, `saml`) |
| `id` | string | Connector identifier |
| `name` | string | Connector display name |
| `config` | object | Connector-specific configuration |

**Static client object:**

| Property | Type | Description |
|----------|------|-------------|
| `id` | string | Client ID |
| `name` | string | Client display name |
| `secret_secret` | string | Doorman secret reference for client secret |
| `redirectURIs` | array of strings | Allowed redirect URIs |

## Example

```yaml
_type: amadla.org/entity/application/identity-provider/dex@v1.0.0
_extends: amadla.org/entity/application/identity-provider@v1.0.0
_body:
  listen_port: 5556
  issuer: https://dex.example.com
  storage:
    type: postgres
    config:
      host: db.internal
      port: 5432
      database: dex
      user: dex
      ssl:
        mode: require
  connectors:
    - type: ldap
      id: company-ldap
      name: Company LDAP
      config:
        host: ldap.internal:636
        bindDN: cn=admin,dc=example,dc=com
    - type: github
      id: github
      name: GitHub
      config:
        clientID: github-client-id
        redirectURI: https://dex.example.com/callback
  static_clients:
    - id: my-app
      name: My Application
      secret_secret: doorman://vault/dex/my-app-secret
      redirectURIs:
        - https://app.example.com/callback
  enable_password_db: false
```

## Consumers

| Tool | How It Uses Application/IdentityProvider/Dex |
|------|-----------------------------------------------|
| lay | Installs Dex |
| weaver | Generates `dex.yaml` configuration |
| enjoin-service | Enables/starts the `dex` service |
