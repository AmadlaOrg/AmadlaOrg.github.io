# Application/RemoteAccess/VNC

| Field | Value |
|-------|-------|
| **Purpose** | VNC-specific configuration — platform-independent remote framebuffer access |
| **Repo** | [AmadlaOrg/Entities/Application/RemoteAccess/VNC](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/remote-access/vnc@v1.0.0` |
| **Parent type** | [Application/RemoteAccess](application-remote-access.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `display` | integer | VNC display number (e.g., `1` maps to port 5901) |
| `geometry` | string | Screen resolution (e.g., `1920x1080`) |
| `depth` | integer | Color depth in bits (`8`, `16`, or `24`) |
| `password_secret` | string | Doorman secret reference for the VNC password |
| `localhost_only` | boolean | Only accept local connections (tunnel via SSH) |
| `server` | string | VNC server implementation (`tigervnc`, `tightvnc`, or `x11vnc`) |

## Example

```yaml
_type: amadla.org/entity/application/remote-access/vnc@v1.0.0
_extends: amadla.org/entity/application/remote-access@v1.0.0
_body:
  listen_address: 0.0.0.0
  auth_required: true
  display: 1
  geometry: 1920x1080
  depth: 24
  password_secret: doorman://vault/vnc/password
  localhost_only: false
  server: tigervnc
```

## Consumers

| Tool | How It Uses Application/RemoteAccess/VNC |
|------|------------------------------------------|
| lay | Installs the VNC server package (e.g., `tigervnc-server`) |
| weaver | Generates VNC config and systemd unit files |
| enjoin-service | Enables/starts `vncserver@:<display>` service |
