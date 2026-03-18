# Application/RemoteAccess

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all remote access applications |
| **Repo** | [AmadlaOrg/Entities/Application/RemoteAccess](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/remote-access@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the service listens on (e.g., `0.0.0.0`, `127.0.0.1`) |
| `listen_port` | integer | Port the service listens on |
| `auth_required` | boolean | Whether authentication is required for connections (default: `true`) |
| `tls.enabled` | boolean | Whether TLS is enabled |
| `tls.cert` | string | Path to TLS certificate file |
| `tls.key` | string | Path to TLS private key file |

These properties are common across all remote access implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [RemoteAccess/XRDP](application-remote-access-xrdp.md) | XRDP — open-source RDP server for Linux | RDP protocol |
| [RemoteAccess/VNC](application-remote-access-vnc.md) | VNC — platform-independent remote framebuffer | VNC protocol |
| [RemoteAccess/Guacamole](application-remote-access-guacamole.md) | Apache Guacamole — clientless remote desktop gateway | Web-based |

## Example

```yaml
_type: amadla.org/entity/application/remote-access@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 3389
  auth_required: true
  tls:
    enabled: true
    cert: /etc/ssl/certs/remote.pem
    key: /etc/ssl/private/remote.key
```

## Consumers

| Tool | How It Uses Application/RemoteAccess |
|------|--------------------------------------|
| lay | Installs the remote access application |
| weaver | Generates configuration files |
| enjoin-service | Enables/starts the remote access service |
