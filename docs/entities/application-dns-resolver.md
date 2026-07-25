# Application/DNSResolver

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all DNS resolver applications |
| **Repo** | [AmadlaOrg/Entities/Application/DNSResolver](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/dns-resolver@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address to listen on (e.g., `127.0.0.1`, `0.0.0.0`) |
| `listen_port` | integer | Port to listen on (default: `53`) |
| `upstream_servers` | array of strings | Upstream DNS servers for recursive resolution |
| `cache_size` | integer | Maximum number of cache entries |

These properties are common across all DNS resolver implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [DNSResolver/Unbound](application-dns-resolver-unbound.md) | Unbound — validating, recursive, caching DNS resolver |
| [DNSResolver/Dnsmasq](application-dns-resolver-dnsmasq.md) | Dnsmasq — lightweight DNS/DHCP server |
| [DNSResolver/SystemdResolved](application-dns-resolver-systemd-resolved.md) | systemd-resolved — network name resolution manager |

## Example

```yaml
_type: amadla.org/entity/application/dns-resolver@v1.0.0
_body:
  listen_address: "127.0.0.1"
  listen_port: 53
  upstream_servers:
    - 1.1.1.1
    - 8.8.8.8
    - 9.9.9.9
  cache_size: 10000
```

## Consumers

| Tool | How It Uses Application/DNSResolver |
|------|-------------------------------------|
| [lay](../tools/lay.md) | Installs the DNS resolver application (unbound, dnsmasq, etc.) |
| enjoin-service | Enables/starts the DNS resolver service |
| [weaver](../tools/weaver.md) | Generates configuration files (unbound.conf, dnsmasq.conf) |
