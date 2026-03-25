# Application/MessageQueue

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all message queue applications |
| **Repo** | [AmadlaOrg/Entities/Application/MessageQueue](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/message-queue@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Bind address for the message queue service |
| `listen_port` | integer | Port the message queue service listens on |
| `admin_port` | integer | Management/API port |
| `auth.username` | string | Authentication username |
| `auth.password_secret` | string | Doorman secret reference for the password |
| `tls.enabled` | boolean | Enable TLS |
| `tls.cert` | string | Path to TLS certificate |
| `tls.key` | string | Path to TLS private key |

These properties are common across all message queue implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Use Case |
|----------|-------------|----------|
| [MessageQueue/RabbitMQ](application-message-queue-rabbitmq.md) | RabbitMQ — AMQP message broker | Traditional message routing, exchanges, queues |
| [MessageQueue/Kafka](application-message-queue-kafka.md) | Apache Kafka — distributed event streaming | High-throughput event streaming, log aggregation |
| [MessageQueue/NATS](application-message-queue-nats.md) | NATS — cloud-native messaging | Lightweight pub/sub, request-reply, JetStream persistence |

## Example

```yaml
_type: amadla.org/entity/application/message-queue@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 5672
  admin_port: 15672
  auth:
    username: admin
    password_secret: doorman://vault/mq/password
  tls:
    enabled: true
    cert: /etc/ssl/certs/mq.pem
    key: /etc/ssl/private/mq.key
```

## Consumers

| Tool | How It Uses Application/MessageQueue |
|------|--------------------------------------|
| [lay](../tools/lay.md) | Installs the message queue application (rabbitmq, kafka, nats) |
| enjoin-service | Enables/starts the message queue service |
| [weaver](../tools/weaver.md) | Generates configuration files (rabbitmq.conf, server.properties, nats.conf) |
