# enjoin

| Field | Value |
|-------|-------|
| **Purpose** | System state configuration — applies users, services, cron, network, firewall, certificates, SELinux, and more |
| **Repo** | [AmadlaOrg/enjoin](https://github.com/AmadlaOrg/enjoin) |

## Overview

enjoin applies system state configuration. It is distinct from lay (installation) and weaver (template/config file generation). Where lay installs packages and applications, enjoin handles everything else that requires imperative system commands — creating users, enabling services, setting firewall rules, mounting filesystems, etc.

Each concern is handled by a **fat plugin** (`enjoin-*`) with multiple OS-aware backends built in. Backend selection is driven by the OS/Preference entity, with runtime detection as fallback.

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `enjoin apply --from <plugin> -f <data>` | Active | Apply system state configuration via a plugin |
| `enjoin validate --from <plugin> -f <data>` | Active | Dry-run validation — shows what would change without applying |
| `enjoin plugins` | Active | List discovered enjoin plugins on PATH |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryEnjoinFramework | Enjoin plugin loading and communication |

## Pipeline Position

enjoin sits between lay (installation) and weaver (config file generation):

```
raise (infra) → lay (install) → enjoin (system state) → weaver (config files) → waiter (deploy)
```

```bash
# Apply user configuration
enjoin apply --from user -f users.yaml

# Dry-run firewall changes
enjoin validate --from firewall -f firewall.yaml

# Pipeline: pipe entity from hery
hery entity get "amadla.org/entity/user@v1.0.0" | enjoin apply --from user

# List available plugins
enjoin plugins
```

## How It Works

```
Entity (YAML/JSON)  →  enjoin apply --from <plugin>  →  enjoin-<plugin> apply -f <data>
                                                               │
                                                        OS-aware backend
                                                        (useradd, systemctl, ufw, etc.)
                                                               │
                                                        JSON result (stdout)
                                                        Exit 0=success, 1=failure
```

## Plugin Selection Flow

Each enjoin plugin is a **fat plugin** — it contains multiple backends internally and selects the right one at runtime:

1. Read OS/Preference entity (e.g., `firewall: firewalld`)
2. `enjoin-firewall` receives this and uses its firewalld backend
3. No OS entity? Runtime detect (probe for ufw, firewalld, iptables, nft)
4. Entity says firewalld but system has ufw? Warn/error (reality doesn't match IaC)

## Enjoin Plugins

| Plugin | Manages | Backends | Entity | Status |
|--------|---------|----------|--------|--------|
| `enjoin-user` | Users, groups, sudoers | useradd, groupadd | [User](../entities/user.md) | Active |
| `enjoin-service` | System services | systemctl, init.d, rc-service | [Service](../entities/service.md) | Active |
| `enjoin-firewall` | Firewall rules | ufw, iptables, nftables, firewalld | [Security/Firewall](../entities/security-firewall.md) | Active |
| `enjoin-cron` | Scheduled tasks | crontab, systemd timers | [Cron](../entities/cron.md) | Planned |
| `enjoin-network` | Network config | ip, nmcli, netplan, ifupdown | [System/Network](../entities/system-network.md) | Planned |
| `enjoin-filesystem` | Mounts, fstab | mount, fstab, tmpfs | [System/Filesystem](../entities/system-filesystem.md) | Planned |
| `enjoin-certificate` | TLS certificates | certbot, openssl, mkcert | [Security/Certificate](../entities/security-certificate.md) | Planned |
| `enjoin-selinux` | SELinux policies | semanage, setsebool, restorecon | — | Planned |
| `enjoin-apparmor` | AppArmor profiles | aa-enforce, aa-complain | — | Planned |
| `enjoin-sysctl` | Kernel parameters | sysctl.conf | — | Planned |

Plugins are discovered via PATH (`enjoin-*` naming convention). Each plugin declares supported entity types via its `info` subcommand.

## File Writing

enjoin plugins can write simple declarative files directly (cron entry, sudoers line, fstab mount) — these are direct expressions of the entity with no templating needed. If templating with entity data interpolation is required, pipe through weaver instead.

## Security/Network vs System/Network

- **Security/Network** (firewall) = default posture: deny-all baseline, allowed protocols, rate limits
- **System/Network** = connectivity: interfaces, ports, DNS, routes
- System/Network `_requires` Security/Network — security baseline applied first
- Declared ports in System/Network become implicit allow-list against Security/Network's deny-all
