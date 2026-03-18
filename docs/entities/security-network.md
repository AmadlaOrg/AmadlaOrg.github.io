# Security/Network

| Field | Value |
|-------|-------|
| **Purpose** | Defines network security posture — TLS requirements, network isolation, protocol hardening, DNS security |
| **Repo** | [AmadlaOrg/Entities/Security/Network](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/security/network@v1.0.0` |
| **Parent** | [Security](security.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `tls` | object | TLS configuration |
| `tls.min_version` | string | Minimum TLS version: `1.0`, `1.1`, `1.2`, `1.3` (default: `1.2`) |
| `tls.cipher_suites` | array of strings | Allowed cipher suites (e.g., `TLS_AES_256_GCM_SHA384`) |
| `tls.require_client_cert` | boolean | Require mutual TLS (default: `false`) |
| `tls.hsts` | object | HTTP Strict Transport Security configuration |
| `tls.hsts.enabled` | boolean | Enable HSTS header (default: `false`) |
| `tls.hsts.max_age` | integer | HSTS max-age in seconds (default: `31536000`) |
| `tls.hsts.include_subdomains` | boolean | Include subdomains in HSTS (default: `true`) |
| `tls.hsts.preload` | boolean | Enable HSTS preload (default: `false`) |
| `isolation` | object | Network isolation settings |
| `isolation.network_namespaces` | boolean | Enable network namespace isolation (default: `false`) |
| `isolation.allowed_outbound` | array of strings | Allowed outbound destinations (CIDR or domain) |
| `isolation.deny_link_local` | boolean | Block link-local (169.254.0.0/16) traffic (default: `false`) |
| `protocols` | object | Protocol hardening |
| `protocols.disable_ipv6` | boolean | Disable IPv6 (default: `false`) |
| `protocols.disable_icmp_redirect` | boolean | Disable ICMP redirects (default: `true`) |
| `protocols.disable_source_routing` | boolean | Disable source routing (default: `true`) |
| `protocols.enable_syn_cookies` | boolean | Enable SYN cookies (default: `true`) |
| `protocols.enable_rp_filter` | boolean | Enable reverse path filtering (default: `true`) |
| `dns_security` | object | DNS security configuration |
| `dns_security.dnssec` | boolean | Enable DNSSEC validation (default: `false`) |
| `dns_security.dns_over_tls` | boolean | Enable DNS-over-TLS (default: `false`) |
| `dns_security.allowed_dns_servers` | array of strings | Restrict DNS queries to these servers |

## Example

```yaml
_type: amadla.org/entity/security/network@v1.0.0
_body:
  tls:
    min_version: "1.2"
    cipher_suites:
      - TLS_AES_256_GCM_SHA384
      - TLS_CHACHA20_POLY1305_SHA256
      - TLS_AES_128_GCM_SHA256
    require_client_cert: false
    hsts:
      enabled: true
      max_age: 31536000
      include_subdomains: true
      preload: true
  isolation:
    network_namespaces: true
    allowed_outbound:
      - 0.0.0.0/0
    deny_link_local: true
  protocols:
    disable_ipv6: false
    disable_icmp_redirect: true
    disable_source_routing: true
    enable_syn_cookies: true
    enable_rp_filter: true
  dns_security:
    dnssec: true
    dns_over_tls: true
    allowed_dns_servers:
      - 1.1.1.1
      - 9.9.9.9
```

## Consumers

| Tool | How It Uses Security/Network |
|------|------------------------------|
| enjoin-network | Applies TLS settings, protocol hardening (sysctl), DNS security, and isolation rules |
| enjoin-sysctl | Applies protocol hardening kernel parameters (SYN cookies, RP filter, ICMP redirects) |
| judge | Validates network security posture matches declared policy |
