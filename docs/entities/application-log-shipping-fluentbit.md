# Application/LogShipping/Fluentbit

| Field | Value |
|-------|-------|
| **Purpose** | Fluent Bit-specific configuration — lightweight, CNCF log processor and forwarder |
| **Repo** | [AmadlaOrg/Entities/Application/LogShipping/Fluentbit](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/log-shipping/fluentbit@v1.0.0` |
| **Parent type** | [Application/LogShipping](application-log-shipping.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `inputs` | array of objects | Fluent Bit input plugin configurations |
| `inputs[].name` | string | Input plugin name (`tail`, `systemd`, `cpu`, `mem`) |
| `inputs[].tag` | string | Tag to assign to collected records |
| `inputs[].path` | string | File path (for tail input) |
| `inputs[].systemd_filter` | string | Systemd unit filter (for systemd input) |
| `filters` | array of objects | Fluent Bit filter plugin configurations |
| `filters[].name` | string | Filter plugin name (`grep`, `modify`, `record_modifier`) |
| `filters[].match` | string | Tag pattern to match |
| `filters[].config` | object | Filter-specific configuration |
| `outputs` | array of objects | Fluent Bit output plugin configurations |
| `outputs[].name` | string | Output plugin name (`es`, `loki`, `forward`, `file`) |
| `outputs[].match` | string | Tag pattern to match |
| `outputs[].config` | object | Output-specific configuration |
| `parsers` | array of objects | Custom parser definitions |
| `parsers[].name` | string | Parser name |
| `parsers[].format` | string | Parser format (`regex`, `json`, `logfmt`) |
| `parsers[].regex` | string | Regular expression (for regex format) |

## Example

```yaml
_type: amadla.org/entity/application/log-shipping/fluentbit@v1.0.0
_extends: amadla.org/entity/application/log-shipping@v1.0.0
_body:
  inputs:
    - name: tail
      tag: nginx
      path: /var/log/nginx/access.log
    - name: systemd
      tag: app
      systemd_filter: myapp.service
  filters:
    - name: record_modifier
      match: "*"
      config:
        Record: "hostname ${HOSTNAME}"
  outputs:
    - name: loki
      match: "*"
      config:
        host: loki.example.com
        port: 3100
        labels: "job=fluentbit"
  parsers:
    - name: nginx_access
      format: regex
      regex: '^(?<remote>[^ ]*) - (?<user>[^ ]*) \[(?<time>[^\]]*)\]'
```

## Consumers

| Tool | How It Uses Application/LogShipping/Fluentbit |
|------|------------------------------------------------|
| lay | Installs the `fluent-bit` package |
| weaver | Generates `/etc/fluent-bit/fluent-bit.conf` and parsers config |
| enjoin-service | Enables/starts `fluent-bit` service |
