# Application/LogShipping/Filebeat

| Field | Value |
|-------|-------|
| **Purpose** | Filebeat-specific configuration — lightweight log shipper from the Elastic Stack |
| **Repo** | [AmadlaOrg/Entities/Application/LogShipping/Filebeat](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/log-shipping/filebeat@v1.0.0` |
| **Parent type** | [Application/LogShipping](application-log-shipping.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `inputs` | array of objects | Filebeat input configurations |
| `inputs[].type` | string | Input type (`log`, `filestream`, `journald`) |
| `inputs[].paths` | array of strings | File paths to collect |
| `inputs[].fields` | object | Additional fields to attach to events |
| `output_elasticsearch.hosts` | array of strings | Elasticsearch host addresses |
| `output_elasticsearch.index` | string | Index name pattern |
| `output_elasticsearch.username` | string | Authentication username |
| `output_elasticsearch.password_secret` | string | Doorman secret reference for the password |
| `output_logstash.hosts` | array of strings | Logstash host addresses |
| `output_logstash.ssl` | boolean | Whether to use SSL for the connection |
| `processors` | array of objects | Event processors (`add_host_metadata`, `add_cloud_metadata`, etc.) |

## Example

```yaml
_type: amadla.org/entity/application/log-shipping/filebeat@v1.0.0
_extends: amadla.org/entity/application/log-shipping@v1.0.0
_body:
  inputs:
    - type: filestream
      paths:
        - /var/log/nginx/access.log
        - /var/log/nginx/error.log
      fields:
        service: nginx
    - type: filestream
      paths:
        - /var/log/app/*.log
      fields:
        service: myapp
  output_elasticsearch:
    hosts:
      - https://elasticsearch.example.com:9200
    index: "filebeat-%{+yyyy.MM.dd}"
    username: filebeat
    password_secret: doorman://vault/elastic/filebeat-password
  processors:
    - add_host_metadata: {}
```

## Consumers

| Tool | How It Uses Application/LogShipping/Filebeat |
|------|----------------------------------------------|
| lay | Installs the `filebeat` package |
| weaver | Generates `/etc/filebeat/filebeat.yml` |
| enjoin-service | Enables/starts `filebeat` service |
