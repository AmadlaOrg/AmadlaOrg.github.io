# Application/APIGateway/Tyk

| Field | Value |
|-------|-------|
| **Purpose** | Tyk-specific configuration — open source API gateway with dashboard and analytics |
| **Repo** | [AmadlaOrg/Entities/Application/APIGateway/Tyk](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/api-gateway/tyk@v1.0.0` |
| **Parent type** | [Application/APIGateway](application-api-gateway.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_port` | integer | Port the Tyk gateway listens on |
| `secret_secret` | string | Doorman secret reference for the Tyk node secret |
| `template_path` | string | Path to API definition templates |
| `use_db_app_configs` | boolean | Whether to pull API definitions from the Tyk Dashboard |
| `dashboard_url` | string | URL of the Tyk Dashboard |
| `policies.policy_source` | string | Policy source (`service` or `file`) |
| `policies.policy_record_name` | string | Policy record name or path |
| `analytics.enabled` | boolean | Whether analytics are enabled |
| `analytics.storage_expiration_after` | integer | Seconds before analytics records expire |
| `health_check.enable_health_checks` | boolean | Whether health checks are enabled |
| `health_check.health_check_value_timeouts` | integer | Timeout in seconds for health check values |

## Example

```yaml
_type: amadla.org/entity/application/api-gateway/tyk@v1.0.0
_extends: amadla.org/entity/application/api-gateway@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 8080
  secret_secret: doorman://vault/tyk/node-secret
  use_db_app_configs: true
  dashboard_url: http://dashboard.internal:3000
  policies:
    policy_source: service
    policy_record_name: tyk_policies
  analytics:
    enabled: true
    storage_expiration_after: 60
  health_check:
    enable_health_checks: true
    health_check_value_timeouts: 60
```

## Consumers

| Tool | How It Uses Application/APIGateway/Tyk |
|------|----------------------------------------|
| lay | Installs Tyk gateway |
| weaver | Generates `tyk.conf` and API definitions |
| enjoin-service | Enables/starts the `tyk-gateway` service |
