# Security/IDS

| Field | Value |
|-------|-------|
| **Purpose** | Defines intrusion detection/prevention configuration — fail2ban jails, Suricata/Snort rules, alerting |
| **Repo** | [AmadlaOrg/Entities/Security/IDS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/security/ids@v1.0.0` |
| **Parent** | [Security](security.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `backend` | string | IDS/IPS backend: `fail2ban`, `ossec`, `suricata`, `snort`, `crowdsec`. Auto-detected if omitted |
| `mode` | string | `detection` (log only) or `prevention` (block). Default: `detection` |
| `jails` | array | Fail2ban-style jail definitions |
| `jails[].name` | string | Jail name (**required**) |
| `jails[].enabled` | boolean | Whether the jail is active (default: `true`) |
| `jails[].port` | integer/string | Port to protect |
| `jails[].protocol` | string | Protocol: `tcp`, `udp`, `all` (default: `tcp`) |
| `jails[].filter` | string | Filter name or path to filter config |
| `jails[].log_path` | string | Log file to monitor |
| `jails[].max_retry` | integer | Max failures before ban (default: `5`) |
| `jails[].find_time` | string | Window for counting failures (default: `10m`) |
| `jails[].ban_time` | string | Ban duration (default: `1h`) |
| `jails[].action` | string | Action on ban (e.g., `iptables-multiport`) |
| `rules` | array | IDS rules (Suricata/Snort-style) |
| `rules[].name` | string | Rule name (**required**) |
| `rules[].source` | string | Path to rules file or URL (**required**) |
| `rules[].enabled` | boolean | Whether the rule is active (default: `true`) |
| `rules[].category` | string | Rule category (e.g., `emerging-threats`, `malware`) |
| `whitelist` | array of strings | IP addresses or CIDRs to exclude from detection |
| `alerting` | object | Alert configuration |
| `alerting.log_path` | string | Where to write alerts |
| `alerting.syslog` | boolean | Send alerts to syslog (default: `false`) |
| `alerting.email` | string | Email address for alert notifications |

## Example

```yaml
_type: amadla.org/entity/security/ids@v1.0.0
_body:
  backend: fail2ban
  mode: prevention
  jails:
    - name: sshd
      port: 22
      filter: sshd
      log_path: /var/log/auth.log
      max_retry: 3
      find_time: 10m
      ban_time: 1h
      action: iptables-multiport

    - name: nginx-http-auth
      port: 80,443
      filter: nginx-http-auth
      log_path: /var/log/nginx/error.log
      max_retry: 5
      ban_time: 30m

  whitelist:
    - 10.0.0.0/8
    - 192.168.1.0/24
  alerting:
    log_path: /var/log/fail2ban.log
    syslog: true
```

### Suricata example

```yaml
_type: amadla.org/entity/security/ids@v1.0.0
_body:
  backend: suricata
  mode: detection
  rules:
    - name: et-open
      source: https://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz
      category: emerging-threats
    - name: custom-rules
      source: /etc/suricata/rules/local.rules
  alerting:
    log_path: /var/log/suricata/eve.json
    syslog: true
    email: security@example.com
```

## Consumers

| Tool | How It Uses Security/IDS |
|------|--------------------------|
| enjoin | Installs and configures the IDS backend, deploys jails and rules |
| judge | Validates that IDS is running and configured as declared |
