# Application/ContainerRegistry/DockerRegistry

| Field | Value |
|-------|-------|
| **Purpose** | Docker Registry (distribution) configuration — lightweight OCI-compliant container image registry |
| **Repo** | [AmadlaOrg/Entities/Application/ContainerRegistry/DockerRegistry](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/container-registry/docker-registry@v1.0.0` |
| **Parent type** | [Application/ContainerRegistry](application-container-registry.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `version` | string | Registry version |
| `delete_enabled` | boolean | Whether image deletion is enabled |
| `cache.blobdescriptor` | string | Blob descriptor cache backend: `inmemory` or `redis` |
| `proxy.remoteurl` | string | Remote registry URL to proxy (pull-through cache) |
| `proxy.username` | string | Username for the remote registry |
| `proxy.password_secret` | string | Doorman secret reference for the remote registry password |
| `notifications` | array of objects | Notification endpoint configuration |
| `notifications[].name` | string | Notification endpoint name (required) |
| `notifications[].url` | string | Notification endpoint URL (required) |
| `notifications[].headers` | object | HTTP headers to send with notifications |
| `notifications[].timeout` | string | Request timeout (e.g., `5s`) |

## Example

```yaml
_type: amadla.org/entity/application/container-registry/docker-registry@v1.0.0
_extends: amadla.org/entity/application/container-registry@v1.0.0
_body:
  listen_port: 5000
  storage_backend: filesystem
  storage_path: /var/lib/registry
  version: "2"
  delete_enabled: true
  cache:
    blobdescriptor: inmemory
  notifications:
    - name: webhook
      url: https://ci.example.com/registry-hook
      timeout: 5s
```

## Consumers

| Tool | How It Uses Application/ContainerRegistry/DockerRegistry |
|------|----------------------------------------------------------|
| [lay](../tools/lay.md) | Installs the Docker Registry binary |
| [weaver](../tools/weaver.md) | Generates `config.yml` for the registry |
| enjoin-service | Enables/starts the registry service |
