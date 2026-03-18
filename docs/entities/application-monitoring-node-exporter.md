# Application/Monitoring/NodeExporter

| Field | Value |
|-------|-------|
| **Purpose** | Prometheus node_exporter configuration — hardware and OS metrics for Prometheus |
| **Repo** | [AmadlaOrg/Entities/Application/Monitoring/NodeExporter](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/monitoring/node-exporter@v1.0.0` |
| **Parent type** | [Application/Monitoring](application-monitoring.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `collectors` | array of strings | Enabled collectors (e.g., `cpu`, `diskstats`, `filesystem`, `meminfo`, `netdev`, `loadavg`) |
| `disabled_collectors` | array of strings | Explicitly disabled collectors |
| `web_config.tls_cert` | string | Path to the TLS certificate file |
| `web_config.tls_key` | string | Path to the TLS private key file |
| `web_config.basic_auth_users` | object | Basic auth users (username to bcrypt-hashed password) |
| `textfile_directory` | string | Directory for the textfile collector to read `.prom` files from |

## Example

```yaml
_type: amadla.org/entity/application/monitoring/node-exporter@v1.0.0
_extends: amadla.org/entity/application/monitoring@v1.0.0
_body:
  listen_address: "0.0.0.0"
  listen_port: 9100
  collectors:
    - cpu
    - diskstats
    - filesystem
    - meminfo
    - netdev
    - loadavg
    - systemd
  disabled_collectors:
    - infiniband
    - nfs
  textfile_directory: /var/lib/node_exporter/textfile
  web_config:
    tls_cert: /etc/node_exporter/cert.pem
    tls_key: /etc/node_exporter/key.pem
```

## Consumers

| Tool | How It Uses Application/Monitoring/NodeExporter |
|------|------------------------------------------------|
| lay | Installs the `node_exporter` binary |
| weaver | Generates web config YAML and systemd unit overrides |
| enjoin-service | Enables/starts `node_exporter` service |
