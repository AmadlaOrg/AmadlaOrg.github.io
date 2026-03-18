# Application/ContainerRegistry/Harbor

| Field | Value |
|-------|-------|
| **Purpose** | Harbor-specific configuration — enterprise container registry with vulnerability scanning and content trust |
| **Repo** | [AmadlaOrg/Entities/Application/ContainerRegistry/Harbor](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/container-registry/harbor@v1.0.0` |
| **Parent type** | [Application/ContainerRegistry](application-container-registry.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `hostname` | string | External URL hostname |
| `admin_password_secret` | string | Doorman secret reference for the admin password |
| `database.type` | string | Internal or external database: `internal` or `external` |
| `database.host` | string | Database host |
| `database.port` | integer | Database port |
| `database.name` | string | Database name |
| `database.username` | string | Database username |
| `database.password_secret` | string | Doorman secret reference for the database password |
| `trivy_enabled` | boolean | Enable Trivy vulnerability scanning |
| `notary_enabled` | boolean | Enable Notary content trust |
| `chartmuseum_enabled` | boolean | Enable ChartMuseum Helm chart repository |
| `log_level` | string | Log level: `debug`, `info`, `warning`, `error`, or `fatal` |

## Example

```yaml
_type: amadla.org/entity/application/container-registry/harbor@v1.0.0
_extends: amadla.org/entity/application/container-registry@v1.0.0
_body:
  listen_port: 443
  storage_backend: s3
  tls:
    enabled: true
    cert: /etc/ssl/harbor/cert.pem
    key: /etc/ssl/harbor/key.pem
  hostname: registry.example.com
  admin_password_secret: doorman://vault/harbor/admin-password
  database:
    type: external
    host: db.example.com
    port: 5432
    name: harbor
    username: harbor
    password_secret: doorman://vault/harbor/db-password
  trivy_enabled: true
  notary_enabled: true
  chartmuseum_enabled: false
  log_level: info
```

## Consumers

| Tool | How It Uses Application/ContainerRegistry/Harbor |
|------|--------------------------------------------------|
| lay | Installs Harbor components |
| weaver | Generates `harbor.yml` configuration |
| enjoin-service | Enables/starts Harbor services |
