# Application/LogShipping/Vector

| Field | Value |
|-------|-------|
| **Purpose** | Vector-specific configuration — high-performance observability data pipeline |
| **Repo** | [AmadlaOrg/Entities/Application/LogShipping/Vector](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/log-shipping/vector@v1.0.0` |
| **Parent type** | [Application/LogShipping](application-log-shipping.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `sources` | object | Named source configurations (each key is a source ID) |
| `sources.<id>.type` | string | Source type (`file`, `journald`, `syslog`) |
| `transforms` | object | Named transform configurations (each key is a transform ID) |
| `transforms.<id>.type` | string | Transform type (`remap`, `filter`, `aggregate`) |
| `transforms.<id>.inputs` | array of strings | Input source or transform IDs |
| `sinks` | object | Named sink configurations (each key is a sink ID) |
| `sinks.<id>.type` | string | Sink type (`elasticsearch`, `loki`, `kafka`, `console`) |
| `sinks.<id>.inputs` | array of strings | Input source or transform IDs |

## Example

```yaml
_type: amadla.org/entity/application/log-shipping/vector@v1.0.0
_extends: amadla.org/entity/application/log-shipping@v1.0.0
_body:
  sources:
    nginx_logs:
      type: file
      include:
        - /var/log/nginx/*.log
    journal:
      type: journald
      units:
        - myapp.service
  transforms:
    parse_nginx:
      type: remap
      inputs:
        - nginx_logs
      source: ". = parse_nginx_log!(.message)"
    add_metadata:
      type: remap
      inputs:
        - journal
      source: '.environment = "production"'
  sinks:
    loki:
      type: loki
      inputs:
        - parse_nginx
        - add_metadata
      endpoint: http://loki.example.com:3100
      labels:
        job: vector
    console:
      type: console
      inputs:
        - parse_nginx
      encoding:
        codec: json
```

## Consumers

| Tool | How It Uses Application/LogShipping/Vector |
|------|---------------------------------------------|
| [lay](../tools/lay.md) | Installs the `vector` package |
| [weaver](../tools/weaver.md) | Generates `/etc/vector/vector.toml` |
| enjoin-service | Enables/starts `vector` service |
