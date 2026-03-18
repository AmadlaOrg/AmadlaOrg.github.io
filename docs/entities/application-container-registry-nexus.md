# Application/ContainerRegistry/Nexus

| Field | Value |
|-------|-------|
| **Purpose** | Sonatype Nexus Repository Manager configuration — multi-format artifact repository |
| **Repo** | [AmadlaOrg/Entities/Application/ContainerRegistry/Nexus](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/container-registry/nexus@v1.0.0` |
| **Parent type** | [Application/ContainerRegistry](application-container-registry.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `admin_password_secret` | string | Doorman secret reference for the admin password |
| `repositories` | array of objects | Repository definitions |
| `repositories[].name` | string | Repository name (required) |
| `repositories[].type` | string | Repository type: `hosted`, `proxy`, or `group` (required) |
| `repositories[].format` | string | Repository format: `docker`, `maven`, `npm`, or `raw` (required) |
| `repositories[].config` | object | Format-specific configuration |
| `blob_stores` | array of objects | Blob store definitions |
| `blob_stores[].name` | string | Blob store name (required) |
| `blob_stores[].type` | string | Blob store type: `file` or `s3` (required) |
| `blob_stores[].path` | string | Storage path (for file type) |
| `realms` | array of strings | Enabled security realms (e.g., `DockerToken`, `NpmToken`) |
| `cleanup_policies` | array of objects | Cleanup policy definitions |
| `cleanup_policies[].name` | string | Policy name (required) |
| `cleanup_policies[].format` | string | Repository format this policy applies to (required) |
| `cleanup_policies[].criteria` | object | Cleanup criteria (e.g., last_downloaded, regex) |

## Example

```yaml
_type: amadla.org/entity/application/container-registry/nexus@v1.0.0
_extends: amadla.org/entity/application/container-registry@v1.0.0
_body:
  listen_port: 8081
  storage_backend: filesystem
  admin_password_secret: doorman://vault/nexus/admin-password
  repositories:
    - name: docker-hosted
      type: hosted
      format: docker
    - name: docker-proxy
      type: proxy
      format: docker
      config:
        remote_url: https://registry-1.docker.io
    - name: docker-group
      type: group
      format: docker
  blob_stores:
    - name: default
      type: file
      path: /nexus-data/blobs/default
  realms:
    - DockerToken
  cleanup_policies:
    - name: cleanup-old-images
      format: docker
      criteria:
        last_downloaded: 30
```

## Consumers

| Tool | How It Uses Application/ContainerRegistry/Nexus |
|------|-------------------------------------------------|
| lay | Installs Nexus Repository Manager |
| weaver | Generates Nexus configuration |
| enjoin-service | Enables/starts the Nexus service |
