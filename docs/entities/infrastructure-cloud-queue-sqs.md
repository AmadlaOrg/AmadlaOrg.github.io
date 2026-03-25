# Infrastructure/Cloud/Queue/SQS

| Field | Value |
|-------|-------|
| **Purpose** | AWS SQS configuration — FIFO queues, deduplication, long polling, dead letter queue |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Queue/AWS/SQS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/queue/sqs@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Queue](infrastructure-cloud-queue.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `fifo_queue` | boolean | Whether the queue is a FIFO queue (guarantees ordering) |
| `content_based_deduplication` | boolean | Whether content-based deduplication is enabled (FIFO only) |
| `delay_seconds` | integer | Default delay in seconds before messages become visible |
| `max_message_size` | integer | Maximum message size in bytes (max 262144) |
| `receive_wait_time_seconds` | integer | Long polling wait time in seconds |
| `redrive_policy` | object | Dead letter queue redrive policy (`dead_letter_target_arn`, `max_receive_count`) |
| `kms_master_key_id` | string | KMS key ID for server-side encryption |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/queue/sqs@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/queue@v1.0.0
_body:
  queue_name: order-processing.fifo
  fifo_queue: true
  content_based_deduplication: true
  delay_seconds: 0
  receive_wait_time_seconds: 20
  redrive_policy:
    dead_letter_target_arn: arn:aws:sqs:us-east-1:123456789012:order-dlq.fifo
    max_receive_count: 5
  kms_master_key_id: alias/sqs-key
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Queue/SQS |
|------|-------------------------------------------|
| [raise](../tools/raise.md) | Provisions SQS queues via raise-aws plugin |
