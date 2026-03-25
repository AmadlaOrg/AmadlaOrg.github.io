# Application/Monitoring

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all monitoring agents |
| **Repo** | [AmadlaOrg/Entities/Application/Monitoring](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/monitoring@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address to bind the metrics endpoint (e.g., `0.0.0.0`, `127.0.0.1`) |
| `listen_port` | integer | Port for the metrics endpoint |
| `interval` | string | Collection interval (e.g., `10s`, `1m`, `30s`) |
| `tags` | object | Key-value tags attached to all collected metrics |

These properties are common across all monitoring implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [Monitoring/NodeExporter](application-monitoring-node-exporter.md) | Prometheus node_exporter — hardware/OS metrics |
| [Monitoring/ZabbixAgent](application-monitoring-zabbix-agent.md) | Zabbix agent — enterprise monitoring |
| [Monitoring/Telegraf](application-monitoring-telegraf.md) | Telegraf — plugin-driven metrics collector |
| [Monitoring/Collectd](application-monitoring-collectd.md) | collectd — system statistics daemon |

## Example

```yaml
_type: amadla.org/entity/application/monitoring@v1.0.0
_body:
  listen_address: "0.0.0.0"
  listen_port: 9100
  interval: "10s"
  tags:
    environment: production
    datacenter: us-east-1
```

## Consumers

| Tool | How It Uses Application/Monitoring |
|------|------------------------------------|
| [lay](../tools/lay.md) | Installs the monitoring agent (node_exporter, telegraf, etc.) |
| enjoin-service | Enables/starts the monitoring service |
| [weaver](../tools/weaver.md) | Generates configuration files |
