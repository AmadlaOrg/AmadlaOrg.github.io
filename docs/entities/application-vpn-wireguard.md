# Application/VPN/WireGuard

| Field | Value |
|-------|-------|
| **Purpose** | WireGuard-specific configuration -- kernel-level VPN with minimal code and strong cryptography |
| **Repo** | [AmadlaOrg/Entities/Application/VPN/WireGuard](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/vpn/wireguard@v1.0.0` |
| **Parent type** | [Application/VPN](application-vpn.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `interface` | string | WireGuard interface name (e.g., `wg0`) |
| `private_key_secret` | string | Doorman secret reference for the WireGuard private key |
| `address` | string | Interface address with CIDR (e.g., `10.0.0.1/24`) |
| `post_up` | string | Command to run after the interface comes up (e.g., iptables rules) |
| `post_down` | string | Command to run after the interface goes down |
| `peers` | array of objects | WireGuard peer definitions |
| `peers[].public_key` | string | Peer public key |
| `peers[].allowed_ips` | array of strings | Allowed IP ranges for this peer |
| `peers[].endpoint` | string | Peer endpoint address:port |
| `peers[].persistent_keepalive` | integer | Keepalive interval in seconds (e.g., `25`) |

## Example

```yaml
_type: amadla.org/entity/application/vpn/wireguard@v1.0.0
_extends: amadla.org/entity/application/vpn@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 51820
  subnet: 10.0.0.0/24
  dns:
    - 1.1.1.1
  interface: wg0
  private_key_secret: doorman://vault/wireguard/server-private-key
  address: 10.0.0.1/24
  post_up: iptables -A FORWARD -i wg0 -j ACCEPT
  post_down: iptables -D FORWARD -i wg0 -j ACCEPT
  peers:
    - public_key: abc123...
      allowed_ips:
        - 10.0.0.2/32
      endpoint: 203.0.113.10:51820
      persistent_keepalive: 25
```

## Why WireGuard

- Lives in the Linux kernel -- fewer context switches, better performance
- ~4,000 lines of code vs ~100,000 for OpenVPN -- smaller attack surface
- Modern cryptography only (Curve25519, ChaCha20, BLAKE2s)
- Stateless design -- no connection state machine, silent when idle
- Default VPN on most modern Linux distributions

## Consumers

| Tool | How It Uses Application/VPN/WireGuard |
|------|---------------------------------------|
| [lay](../tools/lay.md) | Installs `wireguard-tools` package |
| [weaver](../tools/weaver.md) | Generates `/etc/wireguard/wg0.conf` |
| enjoin-service | Enables/starts `wg-quick@wg0` service |
