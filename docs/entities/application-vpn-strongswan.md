# Application/VPN/StrongSwan

| Field | Value |
|-------|-------|
| **Purpose** | StrongSwan-specific configuration -- IPsec/IKEv2 VPN for site-to-site and remote access |
| **Repo** | [AmadlaOrg/Entities/Application/VPN/StrongSwan](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/vpn/strongswan@v1.0.0` |
| **Parent type** | [Application/VPN](application-vpn.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `connections` | array of objects | IPsec connection definitions |
| `connections[].name` | string | Connection name |
| `connections[].local.auth` | string | Local authentication method (e.g., `pubkey`, `psk`, `eap`) |
| `connections[].local.certs` | string | Path to local certificate |
| `connections[].local.id` | string | Local identity |
| `connections[].remote.auth` | string | Remote authentication method |
| `connections[].remote.id` | string | Remote identity |
| `connections[].children.local_ts` | array of strings | Local traffic selectors (subnets) |
| `connections[].children.remote_ts` | array of strings | Remote traffic selectors (subnets) |
| `connections[].children.start_action` | string | Action on startup (`start`, `trap`, `none`) |
| `pools` | array of objects | Virtual IP address pools for clients |
| `pools[].name` | string | Pool name |
| `pools[].addrs` | string | Address range in CIDR notation |
| `pools[].dns` | array of strings | DNS servers assigned from this pool |
| `authorities` | array of objects | Certificate authority definitions |
| `authorities[].name` | string | Authority name |
| `authorities[].cacert` | string | Path to CA certificate |
| `authorities[].crl_uris` | array of strings | URIs for certificate revocation lists |

## Example

```yaml
_type: amadla.org/entity/application/vpn/strongswan@v1.0.0
_extends: amadla.org/entity/application/vpn@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 500
  subnet: 10.10.0.0/24
  connections:
    - name: site-to-site
      local:
        auth: pubkey
        certs: /etc/swanctl/x509/server.crt
        id: vpn.example.com
      remote:
        auth: pubkey
        id: remote.example.com
      children:
        local_ts:
          - 192.168.1.0/24
        remote_ts:
          - 192.168.2.0/24
        start_action: start
  pools:
    - name: client-pool
      addrs: 10.10.0.0/24
      dns:
        - 1.1.1.1
  authorities:
    - name: internal-ca
      cacert: /etc/swanctl/x509ca/ca.crt
      crl_uris:
        - http://crl.example.com/ca.crl
```

## Consumers

| Tool | How It Uses Application/VPN/StrongSwan |
|------|----------------------------------------|
| lay | Installs the `strongswan` package |
| weaver | Generates `/etc/swanctl/swanctl.conf` |
| enjoin-service | Enables/starts `strongswan` service |
