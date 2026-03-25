# Application/LogShipping

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all log shipping/forwarding applications |
| **Repo** | [AmadlaOrg/Entities/Application/LogShipping](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/log-shipping@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `inputs` | array of objects | Log input sources |
| `inputs[].type` | string | Input type (`file`, `journald`, `syslog`) |
| `inputs[].path` | string | File path (for file type inputs) |
| `inputs[].unit` | string | Systemd unit name (for journald type inputs) |
| `output.type` | string | Output type (`elasticsearch`, `loki`, `kafka`, `file`) |
| `output.url` | string | Destination URL |
| `output.index` | string | Index name (for Elasticsearch) |
| `output.labels` | object | Labels to attach (for Loki) |

These properties are common across all log shipping implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [LogShipping/Filebeat](application-log-shipping-filebeat.md) | Filebeat — lightweight log shipper from Elastic |
| [LogShipping/Fluentbit](application-log-shipping-fluentbit.md) | Fluent Bit — lightweight log processor and forwarder |
| [LogShipping/Promtail](application-log-shipping-promtail.md) | Promtail — log collector for Grafana Loki |
| [LogShipping/Vector](application-log-shipping-vector.md) | Vector — high-performance observability data pipeline |

## Example

```yaml
_type: amadla.org/entity/application/log-shipping@v1.0.0
_body:
  inputs:
    - type: file
      path: /var/log/nginx/access.log
    - type: journald
      unit: myapp.service
  output:
    type: loki
    url: http://loki.example.com:3100/loki/api/v1/push
    labels:
      job: server-logs
      environment: production
```

## Consumers

| Tool | How It Uses Application/LogShipping |
|------|-------------------------------------|
| [lay](../tools/lay.md) | Installs the log shipping application (filebeat, fluent-bit, etc.) |
| enjoin-service | Enables/starts the log shipping service |
| [weaver](../tools/weaver.md) | Generates configuration files |
