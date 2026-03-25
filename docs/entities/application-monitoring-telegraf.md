# Application/Monitoring/Telegraf

| Field | Value |
|-------|-------|
| **Purpose** | Telegraf-specific configuration — plugin-driven metrics collector from InfluxData |
| **Repo** | [AmadlaOrg/Entities/Application/Monitoring/Telegraf](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/monitoring/telegraf@v1.0.0` |
| **Parent type** | [Application/Monitoring](application-monitoring.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `agent_interval` | string | Default data collection interval (e.g., `10s`, `30s`) |
| `agent_flush_interval` | string | Interval for flushing data to outputs (e.g., `10s`, `1m`) |
| `inputs` | array of objects | Input plugin configurations |
| `inputs[].plugin` | string | Input plugin name (e.g., `cpu`, `disk`, `mem`, `net`, `system`) |
| `inputs[].config` | object | Plugin-specific configuration options |
| `outputs` | array of objects | Output plugin configurations |
| `outputs[].plugin` | string | Output plugin name (e.g., `influxdb`, `prometheus_client`, `file`) |
| `outputs[].config` | object | Plugin-specific configuration options |

## Example

```yaml
_type: amadla.org/entity/application/monitoring/telegraf@v1.0.0
_extends: amadla.org/entity/application/monitoring@v1.0.0
_body:
  listen_address: "127.0.0.1"
  listen_port: 9273
  agent_interval: "10s"
  agent_flush_interval: "10s"
  tags:
    environment: production
  inputs:
    - plugin: cpu
      config:
        percpu: true
        totalcpu: true
    - plugin: mem
    - plugin: disk
      config:
        ignore_fs: ["tmpfs", "devtmpfs"]
    - plugin: net
  outputs:
    - plugin: influxdb
      config:
        urls: ["http://influxdb.example.com:8086"]
        database: telegraf
```

## Consumers

| Tool | How It Uses Application/Monitoring/Telegraf |
|------|---------------------------------------------|
| [lay](../tools/lay.md) | Installs the `telegraf` package |
| [weaver](../tools/weaver.md) | Generates `/etc/telegraf/telegraf.conf` |
| enjoin-service | Enables/starts `telegraf` service |
