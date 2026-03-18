# Infrastructure/DNS/PowerDNS

| Field | Value |
|-------|-------|
| **Purpose** | PowerDNS-specific configuration — database-backed authoritative DNS server with HTTP API |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/DNS/PowerDNS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/dns/powerdns@v1.0.0` |
| **Parent type** | [Infrastructure/DNS](infrastructure-dns.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `backend` | string | Storage backend: `gsqlite3`, `gmysql`, `gpgsql`, `bind`, or `pipe` |
| `backend_config` | object | Backend-specific configuration (host, port, dbname, user, password_secret) |
| `api_enabled` | boolean | Whether to enable the HTTP API |
| `api_key_secret` | string | Doorman secret reference for the API key |
| `webserver_address` | string | Address for the built-in webserver |
| `webserver_port` | integer | Port for the built-in webserver |
| `default_soa_name` | string | Default SOA MNAME field for new zones |
| `default_soa_mail` | string | Default SOA RNAME field for new zones |

## Example

```yaml
_type: amadla.org/entity/infrastructure/dns/powerdns@v1.0.0
_extends: amadla.org/entity/infrastructure/dns@v1.0.0
_body:
  listen_port: 53
  zones:
    - name: example.com
      type: master
  backend: gpgsql
  backend_config:
    host: db.example.com
    port: 5432
    dbname: pdns
    user: pdns
    password_secret: doorman://vault/pdns/db-password
  api_enabled: true
  api_key_secret: doorman://vault/pdns/api-key
  webserver_address: 0.0.0.0
  webserver_port: 8081
  default_soa_name: ns1.example.com
  default_soa_mail: hostmaster.example.com
```

## Consumers

| Tool | How It Uses Infrastructure/DNS/PowerDNS |
|------|-----------------------------------------|
| lay | Installs the `pdns-server` package and backend |
| weaver | Generates `pdns.conf` |
| enjoin-service | Enables/starts the `pdns` service |
