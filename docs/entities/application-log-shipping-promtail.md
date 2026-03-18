# Application/LogShipping/Promtail

| Field | Value |
|-------|-------|
| **Purpose** | Promtail-specific configuration — log collector agent for Grafana Loki |
| **Repo** | [AmadlaOrg/Entities/Application/LogShipping/Promtail](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/log-shipping/promtail@v1.0.0` |
| **Parent type** | [Application/LogShipping](application-log-shipping.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `server_port` | integer | HTTP server port for Promtail metrics and health checks |
| `positions_file` | string | Path to the positions file for tracking read offsets |
| `clients` | array of objects | Loki client configurations |
| `clients[].url` | string | Loki push API URL |
| `clients[].tenant_id` | string | Tenant ID for multi-tenant Loki |
| `clients[].basic_auth.username` | string | Authentication username |
| `clients[].basic_auth.password_secret` | string | Doorman secret reference for the password |
| `scrape_configs` | array of objects | Scrape configurations for log discovery |
| `scrape_configs[].job_name` | string | Name of the scrape job |
| `scrape_configs[].static_configs` | array of objects | Static target configurations |
| `pipeline_stages` | array of objects | Pipeline stages for log processing (`regex`, `json`, `labels`, `timestamp`) |

## Example

```yaml
_type: amadla.org/entity/application/log-shipping/promtail@v1.0.0
_extends: amadla.org/entity/application/log-shipping@v1.0.0
_body:
  server_port: 9080
  positions_file: /var/lib/promtail/positions.yaml
  clients:
    - url: http://loki.example.com:3100/loki/api/v1/push
      tenant_id: default
  scrape_configs:
    - job_name: system
      static_configs:
        - targets:
            - localhost
          labels:
            job: varlogs
            __path__: /var/log/*.log
    - job_name: nginx
      static_configs:
        - targets:
            - localhost
          labels:
            job: nginx
            __path__: /var/log/nginx/*.log
  pipeline_stages:
    - regex:
        expression: '(?P<timestamp>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})'
    - timestamp:
        source: timestamp
        format: "2006-01-02T15:04:05"
```

## Consumers

| Tool | How It Uses Application/LogShipping/Promtail |
|------|----------------------------------------------|
| lay | Installs the `promtail` binary |
| weaver | Generates `/etc/promtail/config.yml` |
| enjoin-service | Enables/starts `promtail` service |
