# Application/DNSResolver/SystemdResolved

| Field | Value |
|-------|-------|
| **Purpose** | systemd-resolved-specific configuration — network name resolution manager, default on many systemd distros |
| **Repo** | [AmadlaOrg/Entities/Application/DNSResolver/SystemdResolved](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/dns-resolver/systemd-resolved@v1.0.0` |
| **Parent type** | [Application/DNSResolver](application-dns-resolver.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `dns` | array of strings | DNS server addresses |
| `fallback_dns` | array of strings | Fallback DNS server addresses |
| `domains` | array of strings | Search domains |
| `dnssec` | string | DNSSEC validation mode (`yes`, `no`, `allow-downgrade`) |
| `dns_over_tls` | string | DNS-over-TLS mode (`yes`, `no`, `opportunistic`) |
| `multicast_dns` | string | Multicast DNS mode (`yes`, `no`, `resolve`) |
| `llmnr` | string | Link-Local Multicast Name Resolution mode (`yes`, `no`, `resolve`) |

## Example

```yaml
_type: amadla.org/entity/application/dns-resolver/systemd-resolved@v1.0.0
_extends: amadla.org/entity/application/dns-resolver@v1.0.0
_body:
  listen_address: "127.0.0.53"
  listen_port: 53
  dns:
    - 1.1.1.1
    - 8.8.8.8
  fallback_dns:
    - 9.9.9.9
    - 208.67.222.222
  domains:
    - example.com
  dnssec: allow-downgrade
  dns_over_tls: opportunistic
  multicast_dns: resolve
  llmnr: resolve
```

## Consumers

| Tool | How It Uses Application/DNSResolver/SystemdResolved |
|------|-----------------------------------------------------|
| [lay](../tools/lay.md) | Ensures `systemd-resolved` is present (typically built-in) |
| [weaver](../tools/weaver.md) | Generates `/etc/systemd/resolved.conf` |
| enjoin-service | Restarts `systemd-resolved` to apply configuration |
