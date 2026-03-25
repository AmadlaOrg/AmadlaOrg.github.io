# Application/MessageQueue/NATS

| Field | Value |
|-------|-------|
| **Purpose** | NATS-specific configuration — cloud-native messaging system |
| **Repo** | [AmadlaOrg/Entities/Application/MessageQueue/NATS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/message-queue/nats@v1.0.0` |
| **Parent type** | [Application/MessageQueue](application-message-queue.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `max_payload` | string | Maximum message size (e.g., `1MB`) |
| `max_connections` | integer | Maximum number of client connections |
| `jetstream.enabled` | boolean | Enable JetStream persistence |
| `jetstream.store_dir` | string | JetStream storage directory |
| `jetstream.max_memory` | string | Maximum memory for JetStream |
| `jetstream.max_file` | string | Maximum file storage for JetStream |
| `cluster.name` | string | Cluster name |
| `cluster.routes` | array of strings | Routes to other cluster members |
| `authorization.users` | array of objects | Authorized users (`user`, `password_secret`, `permissions`) |

## Example

```yaml
_type: amadla.org/entity/application/message-queue/nats@v1.0.0
_extends: amadla.org/entity/application/message-queue@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 4222
  admin_port: 8222
  max_payload: 1MB
  max_connections: 65536
  jetstream:
    enabled: true
    store_dir: /var/lib/nats/jetstream
    max_memory: 1G
    max_file: 10G
  cluster:
    name: nats-cluster
    routes:
      - nats://nats-1:6222
      - nats://nats-2:6222
  authorization:
    users:
      - user: app_user
        password_secret: doorman://vault/nats/app-password
```

## Consumers

| Tool | How It Uses Application/MessageQueue/NATS |
|------|------------------------------------------|
| [lay](../tools/lay.md) | Installs the `nats-server` package |
| [weaver](../tools/weaver.md) | Generates `/etc/nats/nats-server.conf` |
| enjoin-service | Enables/starts `nats-server` service |
