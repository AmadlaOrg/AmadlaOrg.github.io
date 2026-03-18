# Application/MailRelay/Postfix

| Field | Value |
|-------|-------|
| **Purpose** | Postfix-specific configuration — full-featured MTA commonly used as a relay |
| **Repo** | [AmadlaOrg/Entities/Application/MailRelay/Postfix](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/mail-relay/postfix@v1.0.0` |
| **Parent type** | [Application/MailRelay](application-mail-relay.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `myhostname` | string | The hostname of this mail system |
| `mydomain` | string | The domain name of this mail system |
| `mynetworks` | array of strings | Trusted networks allowed to relay through this server |
| `inet_interfaces` | string | Network interfaces to listen on (`loopback-only` or `all`) |
| `smtp_tls_security_level` | string | TLS security level for outbound SMTP connections (`none`, `may`, `encrypt`, `dane`) |
| `alias_maps` | object | Mail alias mappings (key: alias, value: destination) |

## Example

```yaml
_type: amadla.org/entity/application/mail-relay/postfix@v1.0.0
_extends: amadla.org/entity/application/mail-relay@v1.0.0
_body:
  relay_host: smtp.example.com
  relay_port: 587
  from_address: server@example.com
  tls: true
  auth:
    username: server@example.com
    password_secret: doorman://vault/mail/smtp-password
  myhostname: webserver01.example.com
  mydomain: example.com
  inet_interfaces: loopback-only
  mynetworks:
    - 127.0.0.0/8
  smtp_tls_security_level: encrypt
  alias_maps:
    root: admin@example.com
    postmaster: admin@example.com
```

## Consumers

| Tool | How It Uses Application/MailRelay/Postfix |
|------|-------------------------------------------|
| lay | Installs the `postfix` package |
| weaver | Generates `/etc/postfix/main.cf` and `/etc/postfix/sasl_passwd` |
| enjoin-service | Enables/starts `postfix` service |
