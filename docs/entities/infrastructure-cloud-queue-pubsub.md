# Infrastructure/Cloud/Queue/Pub/Sub

| Field | Value |
|-------|-------|
| **Purpose** | GCP Pub/Sub configuration — topics, subscriptions, push delivery, dead letter policy, schema validation |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Queue/GCP/PubSub](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/queue/pubsub@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Queue](infrastructure-cloud-queue.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `topic_name` | string | Name of the Pub/Sub topic |
| `subscriptions` | array of objects | Subscription configurations (`name`, `ack_deadline_seconds`, `message_retention_duration`, `push_config`, `filter`, `dead_letter_policy`) |
| `subscriptions[].push_config` | object | Push delivery configuration (`push_endpoint`, `attributes`) |
| `subscriptions[].dead_letter_policy` | object | Dead letter policy (`dead_letter_topic`, `max_delivery_attempts`) |
| `schema` | object | Schema for message validation (`name`, `type`, `definition`) |
| `schema.type` | string | Schema type (`AVRO`, `PROTOCOL_BUFFER`) |
| `message_retention_duration` | string | Topic-level message retention duration |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/queue/pubsub@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/queue@v1.0.0
_body:
  topic_name: order-events
  message_retention_duration: 7d
  subscriptions:
    - name: order-processor
      ack_deadline_seconds: 60
      dead_letter_policy:
        dead_letter_topic: projects/my-project/topics/order-events-dlq
        max_delivery_attempts: 5
    - name: order-analytics
      filter: 'attributes.type = "completed"'
      push_config:
        push_endpoint: https://analytics.example.com/webhook
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Queue/Pub/Sub |
|------|-----------------------------------------------|
| raise | Provisions Pub/Sub topics and subscriptions via raise-gcp plugin |
