# Application/AuthProxy/KeycloakGatekeeper

| Field | Value |
|-------|-------|
| **Purpose** | Keycloak Gatekeeper-specific configuration — Keycloak-integrated authentication proxy with role-based access |
| **Repo** | [AmadlaOrg/Entities/Application/AuthProxy/KeycloakGatekeeper](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/auth-proxy/keycloak-gatekeeper@v1.0.0` |
| **Parent type** | [Application/AuthProxy](application-auth-proxy.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `discovery_url` | string | Keycloak realm discovery URL |
| `client_id` | string | OAuth2 client ID registered in Keycloak |
| `client_secret_secret` | string | Doorman secret reference for OAuth2 client secret |
| `redirection_url` | string | URL to redirect to after authentication |
| `resources` | array of objects | Protected resources with role-based access |
| `resources[].uri` | string | URI pattern to protect |
| `resources[].methods` | array of strings | HTTP methods allowed |
| `resources[].roles` | array of strings | Required roles for access |
| `cors_origins` | array of strings | Allowed CORS origins |
| `enable_refresh_tokens` | boolean | Whether to enable refresh token support |
| `encryption_key_secret` | string | Doorman secret reference for encryption key |

## Example

```yaml
_type: amadla.org/entity/application/auth-proxy/keycloak-gatekeeper@v1.0.0
_extends: amadla.org/entity/application/auth-proxy@v1.0.0
_body:
  listen_port: 3000
  upstream: http://localhost:8080
  cookie_secret_secret: doorman://vault/gatekeeper/cookie-secret
  discovery_url: https://keycloak.example.com/realms/main
  client_id: my-app
  client_secret_secret: doorman://vault/gatekeeper/client-secret
  redirection_url: https://app.example.com
  resources:
    - uri: /admin/*
      methods:
        - GET
        - POST
      roles:
        - admin
    - uri: /api/*
      methods:
        - GET
      roles:
        - user
  cors_origins:
    - https://app.example.com
  enable_refresh_tokens: true
  encryption_key_secret: doorman://vault/gatekeeper/encryption-key
```

## Consumers

| Tool | How It Uses Application/AuthProxy/KeycloakGatekeeper |
|------|------------------------------------------------------|
| lay | Installs the Keycloak Gatekeeper binary |
| weaver | Generates gatekeeper configuration |
| enjoin-service | Enables/starts the gatekeeper service |
