# Application/Monitoring/ZabbixAgent

| Field | Value |
|-------|-------|
| **Purpose** | Zabbix agent configuration — enterprise-grade monitoring agent |
| **Repo** | [AmadlaOrg/Entities/Application/Monitoring/ZabbixAgent](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/monitoring/zabbix-agent@v1.0.0` |
| **Parent type** | [Application/Monitoring](application-monitoring.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `server` | string | Zabbix server address for passive checks |
| `server_active` | string | Zabbix server address for active checks |
| `hostname` | string | Hostname reported to the Zabbix server |
| `user_parameters` | array of objects | Custom user parameter checks |
| `user_parameters[].key` | string | Item key for the custom check |
| `user_parameters[].command` | string | Shell command to execute for the check |
| `tls_connect` | string | TLS connection mode to the Zabbix server (`unencrypted`, `psk`, `cert`) |
| `tls_psk_identity` | string | PSK identity string for TLS PSK encryption |
| `tls_psk_secret` | string | PSK secret value (doorman secret reference) |

## Example

```yaml
_type: amadla.org/entity/application/monitoring/zabbix-agent@v1.0.0
_extends: amadla.org/entity/application/monitoring@v1.0.0
_body:
  listen_address: "0.0.0.0"
  listen_port: 10050
  server: zabbix.example.com
  server_active: zabbix.example.com
  hostname: webserver01
  tls_connect: psk
  tls_psk_identity: webserver01-psk
  tls_psk_secret: doorman://vault/zabbix/psk
  user_parameters:
    - key: custom.nginx.active
      command: "curl -s http://localhost/nginx_status | head -1 | awk '{print $NF}'"
```

## Consumers

| Tool | How It Uses Application/Monitoring/ZabbixAgent |
|------|------------------------------------------------|
| lay | Installs the `zabbix-agent2` package |
| weaver | Generates `/etc/zabbix/zabbix_agent2.conf` |
| enjoin-service | Enables/starts `zabbix-agent2` service |
