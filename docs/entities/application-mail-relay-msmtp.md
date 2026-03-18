# Application/MailRelay/Msmtp

| Field | Value |
|-------|-------|
| **Purpose** | msmtp-specific configuration — lightweight SMTP client for sending mail |
| **Repo** | [AmadlaOrg/Entities/Application/MailRelay/Msmtp](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/mail-relay/msmtp@v1.0.0` |
| **Parent type** | [Application/MailRelay](application-mail-relay.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `account` | string | Account name for this configuration |
| `host` | string | SMTP server hostname |
| `port` | integer | SMTP server port |
| `tls` | boolean | Whether to use TLS |
| `tls_starttls` | boolean | Whether to use STARTTLS instead of direct TLS |
| `auth` | string | Authentication method (`plain`, `login`, `cram-md5`, `on`, `off`) |
| `log` | string | Log file path or `syslog` for syslog logging |

## Example

```yaml
_type: amadla.org/entity/application/mail-relay/msmtp@v1.0.0
_extends: amadla.org/entity/application/mail-relay@v1.0.0
_body:
  relay_host: smtp.example.com
  relay_port: 587
  from_address: server@example.com
  account: default
  host: smtp.example.com
  port: 587
  tls: true
  tls_starttls: true
  auth: plain
  log: syslog
```

## Consumers

| Tool | How It Uses Application/MailRelay/Msmtp |
|------|----------------------------------------|
| lay | Installs the `msmtp` and `msmtp-mta` packages |
| weaver | Generates `/etc/msmtprc` |
| enjoin-service | Sets msmtp as the system sendmail alternative |
