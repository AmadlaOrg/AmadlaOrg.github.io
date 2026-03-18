# Application/RemoteAccess/XRDP

| Field | Value |
|-------|-------|
| **Purpose** | XRDP-specific configuration — open-source RDP server for Linux desktops |
| **Repo** | [AmadlaOrg/Entities/Application/RemoteAccess/XRDP](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/remote-access/xrdp@v1.0.0` |
| **Parent type** | [Application/RemoteAccess](application-remote-access.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `max_bpp` | integer | Maximum bits per pixel for the session (`8`, `15`, `16`, `24`, or `32`) |
| `session_types` | array of strings | Allowed session types (`Xvnc`, `Xorg`, or `X11rdp`) |
| `crypt_level` | string | RDP encryption level (`low`, `medium`, `high`, or `fips`) |
| `allow_channels` | boolean | Whether RDP virtual channels are enabled |
| `channel_rdpdr` | boolean | Enable drive redirection channel |
| `channel_rdpsnd` | boolean | Enable sound redirection channel |
| `channel_cliprdr` | boolean | Enable clipboard redirection channel |

## Example

```yaml
_type: amadla.org/entity/application/remote-access/xrdp@v1.0.0
_extends: amadla.org/entity/application/remote-access@v1.0.0
_body:
  listen_port: 3389
  auth_required: true
  tls:
    enabled: true
    cert: /etc/xrdp/cert.pem
    key: /etc/xrdp/key.pem
  max_bpp: 24
  session_types:
    - Xorg
    - Xvnc
  crypt_level: high
  allow_channels: true
  channel_rdpdr: true
  channel_rdpsnd: true
  channel_cliprdr: true
```

## Consumers

| Tool | How It Uses Application/RemoteAccess/XRDP |
|------|-------------------------------------------|
| lay | Installs the `xrdp` package |
| weaver | Generates `/etc/xrdp/xrdp.ini` and `/etc/xrdp/sesman.ini` |
| enjoin-service | Enables/starts `xrdp` and `xrdp-sesman` services |
