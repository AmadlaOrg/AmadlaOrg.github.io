# Application/MailRelay

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all mail relay applications |
| **Repo** | [AmadlaOrg/Entities/Application/MailRelay](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/mail-relay@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `relay_host` | string | Upstream SMTP server to relay mail through |
| `relay_port` | integer | Port of the upstream SMTP server |
| `from_address` | string | Default sender address for system mail |
| `tls` | boolean | Whether to use TLS for the relay connection (default: `true`) |
| `auth.username` | string | SMTP authentication username |
| `auth.password_secret` | string | Doorman secret reference for the SMTP password |

These properties are common across all mail relay implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [MailRelay/Postfix](application-mail-relay-postfix.md) | Postfix — full-featured MTA in relay mode | Most common on servers |
| [MailRelay/Msmtp](application-mail-relay-msmtp.md) | msmtp — lightweight SMTP client | Minimal footprint |

## Example

```yaml
_type: amadla.org/entity/application/mail-relay@v1.0.0
_body:
  relay_host: smtp.example.com
  relay_port: 587
  from_address: server@example.com
  tls: true
  auth:
    username: server@example.com
    password_secret: doorman://vault/mail/smtp-password
```

## Consumers

| Tool | How It Uses Application/MailRelay |
|------|----------------------------------|
| lay | Installs the mail relay application (postfix, msmtp, etc.) |
| enjoin-service | Enables/starts the mail relay service |
| weaver | Generates configuration files (main.cf, msmtprc) |
