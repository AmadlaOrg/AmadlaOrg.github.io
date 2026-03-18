# Application/MessageQueue/RabbitMQ

| Field | Value |
|-------|-------|
| **Purpose** | RabbitMQ-specific configuration — AMQP message broker with exchange-based routing |
| **Repo** | [AmadlaOrg/Entities/Application/MessageQueue/RabbitMQ](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/message-queue/rabbitmq@v1.0.0` |
| **Parent type** | [Application/MessageQueue](application-message-queue.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `vhosts` | array of strings | Virtual hosts to create |
| `users` | array of objects | Users to create (`name`, `password_secret`, `tags`) |
| `permissions` | array of objects | Permission definitions (`user`, `vhost`, `configure`, `write`, `read`) |
| `plugins` | array of strings | Enabled plugins (e.g., `rabbitmq_management`, `rabbitmq_shovel`) |
| `cluster_nodes` | array of strings | Nodes for clustering |
| `memory_high_watermark` | string | Memory high watermark (e.g., `0.4` as fraction or `512MB`) |

## Example

```yaml
_type: amadla.org/entity/application/message-queue/rabbitmq@v1.0.0
_extends: amadla.org/entity/application/message-queue@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 5672
  admin_port: 15672
  auth:
    username: admin
    password_secret: doorman://vault/rabbitmq/admin-password
  vhosts:
    - /
    - /production
    - /staging
  users:
    - name: app_user
      password_secret: doorman://vault/rabbitmq/app-password
      tags:
        - monitoring
    - name: admin
      password_secret: doorman://vault/rabbitmq/admin-password
      tags:
        - administrator
  permissions:
    - user: app_user
      vhost: /production
      configure: ".*"
      write: ".*"
      read: ".*"
  plugins:
    - rabbitmq_management
    - rabbitmq_shovel
  memory_high_watermark: "0.4"
```

## Consumers

| Tool | How It Uses Application/MessageQueue/RabbitMQ |
|------|-----------------------------------------------|
| lay | Installs the `rabbitmq-server` package |
| weaver | Generates `/etc/rabbitmq/rabbitmq.conf` |
| enjoin-service | Enables/starts `rabbitmq-server` service |
