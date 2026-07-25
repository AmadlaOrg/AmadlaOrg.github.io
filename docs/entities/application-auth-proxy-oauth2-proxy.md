# Application/AuthProxy/OAuth2Proxy

| Field | Value |
|-------|-------|
| **Purpose** | OAuth2 Proxy-specific configuration — multi-provider OAuth2 authentication reverse proxy |
| **Repo** | [AmadlaOrg/Entities/Application/AuthProxy/OAuth2Proxy](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/auth-proxy/oauth2-proxy@v1.0.0` |
| **Parent type** | [Application/AuthProxy](application-auth-proxy.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `provider` | string | OAuth2 identity provider: `google`, `github`, `gitlab`, `oidc`, `azure`, or `keycloak` |
| `client_id` | string | OAuth2 client ID |
| `client_secret_secret` | string | Doorman secret reference for OAuth2 client secret |
| `oidc_issuer_url` | string | OIDC discovery URL for the identity provider |
| `redirect_url` | string | OAuth2 callback URL |
| `skip_auth_routes` | array of strings | URL paths that bypass authentication |
| `pass_access_token` | boolean | Whether to pass the OAuth2 access token to the upstream |
| `pass_user_headers` | boolean | Whether to pass X-Forwarded-User and similar headers to the upstream |
| `whitelist_domains` | array of strings | Domains allowed for redirect after authentication |

## Example

```yaml
_type: amadla.org/entity/application/auth-proxy/oauth2-proxy@v1.0.0
_extends: amadla.org/entity/application/auth-proxy@v1.0.0
_body:
  listen_port: 4180
  upstream: http://localhost:8080
  cookie_secret_secret: doorman://vault/oauth2-proxy/cookie-secret
  email_domains:
    - example.com
  provider: oidc
  client_id: my-app
  client_secret_secret: doorman://vault/oauth2-proxy/client-secret
  oidc_issuer_url: https://auth.example.com/realms/main
  redirect_url: https://app.example.com/oauth2/callback
  skip_auth_routes:
    - /health
    - /api/public
  pass_access_token: true
  pass_user_headers: true
```

## Consumers

| Tool | How It Uses Application/AuthProxy/OAuth2Proxy |
|------|------------------------------------------------|
| [lay](../tools/lay.md) | Installs the `oauth2-proxy` binary |
| [weaver](../tools/weaver.md) | Generates OAuth2 Proxy configuration |
| enjoin-service | Enables/starts the `oauth2-proxy` service |
