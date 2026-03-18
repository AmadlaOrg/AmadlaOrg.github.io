# Security

| Field | Value |
|-------|-------|
| **Purpose** | Defines security posture and baseline configuration — enforcement mode, audit logging, compliance profiles |
| **Repo** | [AmadlaOrg/Entities/Security](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/security@v1.0.0` |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `enforcement_mode` | string | Overall security enforcement: `strict` (block violations), `permissive` (log only), `audit` (report). Default: `strict` |
| `audit_log` | string | Path to security audit log (e.g., `/var/log/amadla/security-audit.log`) |
| `compliance_profile` | string | Compliance standard to follow (e.g., `cis-benchmark`, `pci-dss`, `hipaa`, `stig`) |

## Sub-types

| Entity | Purpose | Handled By |
|--------|---------|------------|
| [Security/Certificate](security-certificate.md) | TLS/SSL certificate provisioning and renewal | enjoin, doorman |
| [Security/Firewall](security-firewall.md) | Firewall rules — iptables, nftables, ufw, firewalld | enjoin-firewall |
| [Security/IDS](security-ids.md) | Intrusion detection/prevention — fail2ban, OSSEC, Suricata, Snort, CrowdSec | enjoin |
| [Security/Network](security-network.md) | Network security posture — TLS, isolation, protocol hardening, DNS security | enjoin-network |
| [Security/SELinux](security-selinux.md) | SELinux policies, booleans, file contexts, port labels | enjoin-selinux |

## Example

```yaml
_type: amadla.org/entity/security@v1.0.0
_body:
  enforcement_mode: strict
  audit_log: /var/log/amadla/security-audit.log
  compliance_profile: cis-benchmark
```

### Permissive mode (staging)

```yaml
_type: amadla.org/entity/security@v1.0.0
_body:
  enforcement_mode: permissive
  audit_log: /var/log/amadla/security-audit.log
```

## Consumers

| Tool | How It Uses Security |
|------|----------------------|
| enjoin | Applies security baseline (enforcement mode, audit log path) |
| judge | Validates system state against the declared compliance profile |
