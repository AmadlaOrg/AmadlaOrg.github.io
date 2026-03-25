# Infrastructure/Cloud/Queue

| Field | Value |
|-------|-------|
| **Purpose** | Common cloud message queue properties — queue name, message retention, visibility timeout, encryption |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Queue](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/queue@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `queue_name` | string | Name of the message queue |
| `message_retention` | string | Message retention period (e.g., `4d`, `7d`) |
| `visibility_timeout` | integer | Visibility timeout in seconds before a message becomes available again |
| `encryption` | boolean | Whether message encryption is enabled |

## Sub-types

| Sub-type | Provider |
|----------|----------|
| [Queue/SQS](infrastructure-cloud-queue-sqs.md) | AWS Simple Queue Service |
| [Queue/Pub/Sub](infrastructure-cloud-queue-pubsub.md) | GCP Pub/Sub |
| [Queue/Service Bus](infrastructure-cloud-queue-service-bus.md) | Azure Service Bus |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/queue@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  queue_name: order-processing
  message_retention: 7d
  visibility_timeout: 60
  encryption: true
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Queue |
|------|---------------------------------------|
| [raise](../tools/raise.md) | Provisions message queues via provider-specific plugins |
