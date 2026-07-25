# Application/VPN/OpenVPN

| Field | Value |
|-------|-------|
| **Purpose** | OpenVPN-specific configuration -- TLS-based VPN with broad platform support |
| **Repo** | [AmadlaOrg/Entities/Application/VPN/OpenVPN](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/vpn/openvpn@v1.0.0` |
| **Parent type** | [Application/VPN](application-vpn.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `mode` | string | OpenVPN operating mode (`server` or `client`) |
| `protocol` | string | Transport protocol (`udp` or `tcp`) |
| `device` | string | Virtual network device type (`tun` or `tap`) |
| `ca` | string | Path to the CA certificate |
| `cert` | string | Path to the server certificate |
| `key_secret` | string | Doorman secret reference for the private key |
| `dh` | string | Path to the Diffie-Hellman parameters file |
| `cipher` | string | Encryption cipher (e.g., `AES-256-GCM`) |
| `auth` | string | HMAC authentication algorithm (e.g., `SHA256`) |
| `push_routes` | array of strings | Routes pushed to connected clients |
| `client_to_client` | boolean | Whether clients can communicate with each other |
| `keepalive.interval` | integer | Ping interval in seconds |
| `keepalive.timeout` | integer | Ping timeout in seconds |

## Example

```yaml
_type: amadla.org/entity/application/vpn/openvpn@v1.0.0
_extends: amadla.org/entity/application/vpn@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 1194
  subnet: 10.8.0.0/24
  dns:
    - 1.1.1.1
  mode: server
  protocol: udp
  device: tun
  ca: /etc/openvpn/ca.crt
  cert: /etc/openvpn/server.crt
  key_secret: doorman://vault/openvpn/server-key
  dh: /etc/openvpn/dh2048.pem
  cipher: AES-256-GCM
  auth: SHA256
  push_routes:
    - 192.168.1.0/24
  client_to_client: false
  keepalive:
    interval: 10
    timeout: 120
```

## Consumers

| Tool | How It Uses Application/VPN/OpenVPN |
|------|-------------------------------------|
| [lay](../tools/lay.md) | Installs the `openvpn` package |
| [weaver](../tools/weaver.md) | Generates `/etc/openvpn/server.conf` |
| enjoin-service | Enables/starts `openvpn-server@server` service |
