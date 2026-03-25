# Infrastructure/DNS/Knot

| Field | Value |
|-------|-------|
| **Purpose** | Knot DNS-specific configuration — high-performance authoritative DNS server with built-in DNSSEC signing |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/DNS/Knot](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/dns/knot@v1.0.0` |
| **Parent type** | [Infrastructure/DNS](infrastructure-dns.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `server.listen` | array of strings | Addresses and ports to listen on |
| `server.user` | string | User to run the server as |
| `server.rundir` | string | Runtime directory |
| `database.storage` | string | Path to zone database storage |
| `database.journal_db_mode` | string | Journal database mode |
| `remotes` | array of objects | Remote server definitions for zone transfers |
| `remotes[].id` | string | Remote identifier |
| `remotes[].address` | string | Remote server address |
| `remotes[].key` | string | TSIG key for authentication |
| `acl` | array of objects | Access control lists |
| `acl[].id` | string | ACL identifier |
| `acl[].address` | array of strings | Addresses in this ACL |
| `acl[].action` | array of strings | Allowed actions (`transfer`, `notify`, `update`) |
| `policy` | array of objects | DNSSEC signing policies |
| `policy[].id` | string | Policy identifier |
| `policy[].algorithm` | string | DNSSEC signing algorithm |
| `policy[].zsk_lifetime` | string | ZSK key lifetime (e.g., `30d`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/dns/knot@v1.0.0
_extends: amadla.org/entity/infrastructure/dns@v1.0.0
_body:
  listen_port: 53
  zones:
    - name: example.com
      type: master
      file: /var/lib/knot/zones/example.com.zone
  server:
    listen:
      - 0.0.0.0@53
      - "::@53"
    user: knot:knot
    rundir: /run/knot
  database:
    storage: /var/lib/knot
    journal_db_mode: robust
  remotes:
    - id: secondary
      address: 10.0.0.2@53
  acl:
    - id: transfer_acl
      address:
        - 10.0.0.2
      action:
        - transfer
  policy:
    - id: default
      algorithm: ecdsap256sha256
      zsk_lifetime: 30d
```

## Consumers

| Tool | How It Uses Infrastructure/DNS/Knot |
|------|-------------------------------------|
| [lay](../tools/lay.md) | Installs the `knot` package |
| [weaver](../tools/weaver.md) | Generates `knot.conf` and zone files |
| enjoin-service | Enables/starts the `knot` service |
