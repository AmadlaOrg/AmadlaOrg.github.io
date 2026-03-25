# Application/Monitoring/Collectd

| Field | Value |
|-------|-------|
| **Purpose** | collectd-specific configuration — lightweight C-based system statistics daemon |
| **Repo** | [AmadlaOrg/Entities/Application/Monitoring/Collectd](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/monitoring/collectd@v1.0.0` |
| **Parent type** | [Application/Monitoring](application-monitoring.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `plugins` | array of objects | Plugin configurations for collectd |
| `plugins[].name` | string | Plugin name (e.g., `cpu`, `memory`, `disk`, `interface`, `network`) |
| `plugins[].options` | object | Plugin-specific options |
| `global_options.Hostname` | string | Hostname reported by collectd |
| `global_options.FQDNLookup` | boolean | Whether to perform FQDN lookup for hostname (default: `true`) |
| `global_options.Interval` | integer | Default collection interval in seconds (default: `10`) |

## Example

```yaml
_type: amadla.org/entity/application/monitoring/collectd@v1.0.0
_extends: amadla.org/entity/application/monitoring@v1.0.0
_body:
  interval: "10s"
  global_options:
    Hostname: webserver01
    FQDNLookup: true
    Interval: 10
  plugins:
    - name: cpu
    - name: memory
    - name: disk
      options:
        Disk: ["sda", "sdb"]
    - name: interface
      options:
        Interface: ["eth0"]
    - name: network
      options:
        Server: "monitoring.example.com"
```

## Consumers

| Tool | How It Uses Application/Monitoring/Collectd |
|------|----------------------------------------------|
| [lay](../tools/lay.md) | Installs the `collectd` package |
| [weaver](../tools/weaver.md) | Generates `/etc/collectd/collectd.conf` |
| enjoin-service | Enables/starts `collectd` service |
