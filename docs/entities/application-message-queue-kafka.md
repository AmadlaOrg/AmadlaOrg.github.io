# Application/MessageQueue/Kafka

| Field | Value |
|-------|-------|
| **Purpose** | Kafka-specific configuration — distributed event streaming platform |
| **Repo** | [AmadlaOrg/Entities/Application/MessageQueue/Kafka](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/message-queue/kafka@v1.0.0` |
| **Parent type** | [Application/MessageQueue](application-message-queue.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `broker_id` | integer | Unique broker identifier |
| `log_dirs` | array of strings | Data directories for log segments |
| `num_partitions` | integer | Default number of partitions per topic |
| `default_replication_factor` | integer | Default replication factor for topics |
| `log_retention_hours` | integer | Hours to retain log segments |
| `log_retention_bytes` | integer | Maximum bytes to retain per partition |
| `zookeeper_connect` | string | ZooKeeper connection string (legacy mode) |
| `kraft_mode` | boolean | Enable KRaft mode (no ZooKeeper dependency) |
| `kraft_controller_quorum_voters` | string | KRaft controller quorum voters configuration |

## Example

```yaml
_type: amadla.org/entity/application/message-queue/kafka@v1.0.0
_extends: amadla.org/entity/application/message-queue@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 9092
  broker_id: 0
  log_dirs:
    - /var/lib/kafka/data
  num_partitions: 3
  default_replication_factor: 2
  log_retention_hours: 168
  log_retention_bytes: 1073741824
  kraft_mode: true
  kraft_controller_quorum_voters: "0@kafka-0:9093,1@kafka-1:9093,2@kafka-2:9093"
  tls:
    enabled: true
    cert: /etc/ssl/certs/kafka.pem
    key: /etc/ssl/private/kafka.key
```

## Consumers

| Tool | How It Uses Application/MessageQueue/Kafka |
|------|-------------------------------------------|
| lay | Installs the `kafka` package |
| weaver | Generates `/etc/kafka/server.properties` |
| enjoin-service | Enables/starts `kafka` service |
