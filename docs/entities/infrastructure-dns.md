# Infrastructure/DNS

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all authoritative DNS server implementations |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/DNS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/dns@v1.0.0` |
| **Parent type** | [Infrastructure](infrastructure.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the DNS server listens on |
| `listen_port` | integer | Port the DNS server listens on (default: `53`) |
| `zones` | array of objects | DNS zones served by this server |
| `zones[].name` | string | Zone name (e.g., `example.com`) |
| `zones[].type` | string | Zone type (`master` or `slave`) |
| `zones[].file` | string | Path to the zone file |
| `allow_transfer` | array of strings | IP addresses allowed to perform zone transfers |
| `recursion` | boolean | Whether to enable recursion (default: `false`) |

These properties are common across all DNS server implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [DNS/BIND](infrastructure-dns-bind.md) | BIND (named) — most widely deployed DNS server | Industry standard |
| [DNS/PowerDNS](infrastructure-dns-powerdns.md) | PowerDNS — database-backed authoritative server with API | Modern |
| [DNS/CoreDNS](infrastructure-dns-coredns.md) | CoreDNS — plugin-based DNS server, Kubernetes default | Cloud-native |
| [DNS/Knot](infrastructure-dns-knot.md) | Knot DNS — high-performance authoritative server | High-performance |

## Example

```yaml
_type: amadla.org/entity/infrastructure/dns@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 53
  zones:
    - name: example.com
      type: master
      file: /etc/dns/zones/example.com.zone
    - name: 168.192.in-addr.arpa
      type: master
      file: /etc/dns/zones/192.168.rev
  allow_transfer:
    - 10.0.0.2
    - 10.0.0.3
  recursion: false
```

## Consumers

| Tool | How It Uses Infrastructure/DNS |
|------|--------------------------------|
| raise | Provisions infrastructure for DNS servers |
| lay | Installs the DNS server application |
| weaver | Generates zone files and server configuration |
| enjoin-service | Enables/starts the DNS service |
