# Application/IAM

| Field | Value |
|-------|-------|
| **Purpose** | Defines identity and access management application configuration — OAuth2/OIDC clients, users, protocols |
| **Repo** | [AmadlaOrg/Entities/Application/IAM](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/iam@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

Application/IAM describes identity provider requirements:

- Provider: keycloak, authentik, authelia, openldap
- Authentication realm or domain
- OAuth2/OIDC client registrations (client_id, redirect URIs, grant types, public/confidential)
- Initial user accounts (username, email, roles, password via doorman secret)
- Supported protocols: OIDC, SAML, LDAP, OAuth2

## Example

```yaml
_type: amadla.org/entity/application/iam@v1.0.0
_body:
  provider: keycloak
  realm: my-app
  protocols:
    - oidc
    - saml
  clients:
    - client_id: my-web-app
      redirect_uris:
        - "https://app.example.com/callback"
        - "http://localhost:3000/callback"
      grant_types:
        - authorization_code
        - refresh_token
      public: true

    - client_id: my-api
      grant_types:
        - client_credentials
      public: false

  users:
    - username: admin
      email: admin@example.com
      roles:
        - admin
        - user
      password_secret: iam/admin-password
```

## Consumers

| Tool | How It Uses Application/IAM |
|------|-----------------------------------|
| [lay](../tools/lay.md) | Installs the IAM provider |
| [weaver](../tools/weaver.md) | Generates realm/client configuration files |
| [doorman](../tools/doorman.md) | Resolves `password_secret` references |
| [judge-application](../plugins/judges.md) | Validates IAM provider is running with correct configuration |
