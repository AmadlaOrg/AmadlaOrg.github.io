# Application/VPN

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all VPN applications |
| **Repo** | [AmadlaOrg/Entities/Application/VPN](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/vpn@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the VPN server listens on |
| `listen_port` | integer | Port the VPN server listens on |
| `subnet` | string | VPN subnet (e.g., `10.0.0.0/24`) |
| `dns` | array of strings | DNS servers pushed to VPN clients |

These properties are common across all VPN implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [VPN/WireGuard](application-vpn-wireguard.md) | WireGuard -- kernel-level VPN, minimal attack surface |
| [VPN/OpenVPN](application-vpn-openvpn.md) | OpenVPN -- TLS-based VPN, broad platform support |
| [VPN/StrongSwan](application-vpn-strongswan.md) | StrongSwan -- IPsec/IKEv2, standards-compliant |

## Example

```yaml
_type: amadla.org/entity/application/vpn@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 51820
  subnet: 10.0.0.0/24
  dns:
    - 1.1.1.1
    - 8.8.8.8
```

## Consumers

| Tool | How It Uses Application/VPN |
|------|----------------------------|
| [lay](../tools/lay.md) | Installs the VPN application (wireguard-tools, openvpn, strongswan) |
| [weaver](../tools/weaver.md) | Generates configuration files (wg0.conf, server.conf, ipsec.conf) |
| enjoin-service | Enables/starts the VPN service |
