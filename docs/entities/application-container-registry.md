# Application/ContainerRegistry

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all container registry applications |
| **Repo** | [AmadlaOrg/Entities/Application/ContainerRegistry](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/container-registry@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the registry listens on |
| `listen_port` | integer | Port the registry listens on |
| `storage_backend` | string | Storage backend type: `filesystem`, `s3`, `gcs`, or `azure` |
| `storage_path` | string | Local storage path |
| `tls.enabled` | boolean | Whether TLS is enabled |
| `tls.cert` | string | Path to TLS certificate |
| `tls.key` | string | Path to TLS private key |
| `auth.type` | string | Authentication type: `htpasswd`, `token`, or `ldap` |
| `auth.config` | object | Authentication backend configuration |

These properties are common across all container registry implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [ContainerRegistry/Harbor](application-container-registry-harbor.md) | Harbor — enterprise registry with scanning and replication |
| [ContainerRegistry/DockerRegistry](application-container-registry-docker-registry.md) | Docker Registry (distribution) — lightweight OCI registry |
| [ContainerRegistry/Nexus](application-container-registry-nexus.md) | Sonatype Nexus — multi-format repository manager |

## Example

```yaml
_type: amadla.org/entity/application/container-registry@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 5000
  storage_backend: filesystem
  storage_path: /var/lib/registry
  tls:
    enabled: true
    cert: /etc/ssl/registry/cert.pem
    key: /etc/ssl/registry/key.pem
  auth:
    type: htpasswd
```

## Consumers

| Tool | How It Uses Application/ContainerRegistry |
|------|-------------------------------------------|
| [lay](../tools/lay.md) | Installs the container registry application |
| enjoin-service | Enables/starts the registry service |
| [weaver](../tools/weaver.md) | Generates configuration files |
