# Infrastructure/Cloud/Queue/Service Bus

| Field | Value |
|-------|-------|
| **Purpose** | Azure Service Bus configuration — namespace, queues, topics, subscriptions, authorization rules |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Queue/Azure/ServiceBus](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/queue/service-bus@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Queue](infrastructure-cloud-queue.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `namespace_name` | string | Name of the Service Bus namespace |
| `sku` | string | SKU tier (`Basic`, `Standard`, `Premium`) |
| `queues` | array of objects | Queue definitions (`name`, `max_size_mb`, `lock_duration`, `dead_lettering_on_message_expiration`, `max_delivery_count`) |
| `topics` | array of objects | Topic definitions (`name`, `max_size_mb`, `subscriptions[]`) |
| `topics[].subscriptions` | array of objects | Topic subscriptions (`name`, `max_delivery_count`, `filter`) |
| `authorization_rules` | array of objects | Shared access authorization rules (`name`, `listen`, `send`, `manage`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/queue/service-bus@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/queue@v1.0.0
_body:
  namespace_name: prod-servicebus
  sku: Standard
  queues:
    - name: order-processing
      max_size_mb: 5120
      lock_duration: PT1M
      dead_lettering_on_message_expiration: true
      max_delivery_count: 10
  topics:
    - name: order-events
      max_size_mb: 5120
      subscriptions:
        - name: analytics
          max_delivery_count: 5
        - name: notifications
          max_delivery_count: 3
  authorization_rules:
    - name: app-sender
      send: true
      listen: false
      manage: false
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Queue/Service Bus |
|------|---------------------------------------------------|
| [raise](../tools/raise.md) | Provisions Service Bus namespaces via raise-azure plugin |
