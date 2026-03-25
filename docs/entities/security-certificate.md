# Certificate

| Field | Value |
|-------|-------|
| **Purpose** | Defines TLS/SSL certificate configuration — provisioning method, domains, renewal |
| **Repo** | [AmadlaOrg/Entities/Certificate](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/certificate@v1.0.0` |

## Schema

Certificate describes TLS/SSL certificate requirements:

- Provisioning method: ACME (Let's Encrypt), self-signed, or manual placement
- Domain names (primary + SANs)
- ACME configuration (server, email, challenge type, DNS provider)
- Self-signed options (validity, key size, key type, subject)
- File paths for cert, key, chain, and fullchain
- Key file permissions
- Auto-renewal (renew N days before expiry)
- Post-renewal command (e.g., reload nginx)

## Example

```yaml
_type: amadla.org/entity/certificate@v1.0.0
_body:
  provider: acme
  domains:
    - example.com
    - www.example.com
  acme:
    email: admin@example.com
    challenge: http-01
  cert_path: /etc/ssl/certs/example.com.pem
  key_path: /etc/ssl/private/example.com.key
  fullchain_path: /etc/ssl/certs/example.com.fullchain.pem
  renew_before_days: 30
  notify: "systemctl reload nginx"
```

### Self-signed example

```yaml
_type: amadla.org/entity/certificate@v1.0.0
_body:
  provider: self-signed
  domains:
    - dev.local
  self_signed:
    validity_days: 365
    key_type: ecdsa
    subject:
      cn: dev.local
      o: Development
  cert_path: /etc/ssl/certs/dev.local.pem
  key_path: /etc/ssl/private/dev.local.key
```

## Consumers

| Tool | How It Uses Certificate |
|------|-------------------------------|
| [enjoin](../tools/enjoin.md) | Manages TLS certificates via enjoin-certificate plugin |
| [lay](../tools/lay.md) | Provisions certificates (ACME client, openssl for self-signed, or copies manual certs) |
| [doorman](../tools/doorman.md) | Manages private key secrets |
