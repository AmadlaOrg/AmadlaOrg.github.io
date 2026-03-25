# Application/DNSResolver/Dnsmasq

| Field | Value |
|-------|-------|
| **Purpose** | Dnsmasq-specific configuration — lightweight DNS forwarder and DHCP server |
| **Repo** | [AmadlaOrg/Entities/Application/DNSResolver/Dnsmasq](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/dns-resolver/dnsmasq@v1.0.0` |
| **Parent type** | [Application/DNSResolver](application-dns-resolver.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `domain` | string | Local domain name |
| `dhcp_range.start` | string | Start of DHCP range (e.g., `192.168.1.100`) |
| `dhcp_range.end` | string | End of DHCP range (e.g., `192.168.1.200`) |
| `dhcp_range.lease_time` | string | Lease time (e.g., `12h`, `24h`) |
| `address_overrides` | array of objects | Static address overrides for domains |
| `address_overrides[].domain` | string | Domain name to override |
| `address_overrides[].ip` | string | IP address to return |
| `no_resolv` | boolean | Do not read `/etc/resolv.conf` for upstream servers |
| `bogus_priv` | boolean | Do not forward private reverse-lookup queries upstream |

## Example

```yaml
_type: amadla.org/entity/application/dns-resolver/dnsmasq@v1.0.0
_extends: amadla.org/entity/application/dns-resolver@v1.0.0
_body:
  listen_address: "127.0.0.1"
  listen_port: 53
  upstream_servers:
    - 1.1.1.1
    - 8.8.8.8
  cache_size: 1000
  domain: home.local
  no_resolv: true
  bogus_priv: true
  dhcp_range:
    start: "192.168.1.100"
    end: "192.168.1.200"
    lease_time: "24h"
  address_overrides:
    - domain: nas.home.local
      ip: "192.168.1.5"
    - domain: printer.home.local
      ip: "192.168.1.10"
```

## Consumers

| Tool | How It Uses Application/DNSResolver/Dnsmasq |
|------|----------------------------------------------|
| [lay](../tools/lay.md) | Installs the `dnsmasq` package |
| [weaver](../tools/weaver.md) | Generates `/etc/dnsmasq.conf` and `/etc/dnsmasq.d/*.conf` |
| enjoin-service | Enables/starts `dnsmasq` service |
