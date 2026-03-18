# Application/Proxy/Privoxy

| Field | Value |
|-------|-------|
| **Purpose** | Privoxy-specific configuration — privacy-enhancing filtering proxy with ad blocking and SOCKS chaining |
| **Repo** | [AmadlaOrg/Entities/Application/Proxy/Privoxy](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/proxy/privoxy@v1.0.0` |
| **Parent type** | [Application/Proxy](application-proxy.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `toggle` | boolean | Enable or disable filtering |
| `enable_remote_toggle` | boolean | Allow remote toggling of filtering |
| `enable_edit_actions` | boolean | Allow editing actions via the web interface |
| `forward_socks5` | string | SOCKS5 proxy to chain to (e.g., `127.0.0.1:9050` for Tor) |
| `actionsfile` | array of strings | Action files to load |
| `filterfile` | array of strings | Filter files to load |
| `log_level` | integer | Logging bitmask |

## Example

```yaml
_type: amadla.org/entity/application/proxy/privoxy@v1.0.0
_extends: amadla.org/entity/application/proxy@v1.0.0
_body:
  listen_address: 127.0.0.1
  listen_port: 8118
  toggle: true
  enable_remote_toggle: false
  enable_edit_actions: false
  forward_socks5: 127.0.0.1:9050
  actionsfile:
    - match-all.action
    - default.action
    - user.action
  filterfile:
    - default.filter
    - user.filter
  log_level: 8192
```

## Consumers

| Tool | How It Uses Application/Proxy/Privoxy |
|------|---------------------------------------|
| lay | Installs the `privoxy` package |
| weaver | Generates `/etc/privoxy/config` |
| enjoin-service | Enables/starts the `privoxy` service |
