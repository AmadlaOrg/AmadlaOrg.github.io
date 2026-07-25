# Enjoin Plugins

Enjoin plugins apply system state configuration based on [HERY](../architecture/hery-concepts.md) entity declarations. Each plugin is a **fat plugin** — it contains multiple OS-aware backends and selects the right one at runtime based on the OS/Preference entity or auto-detection.

## Plugin Inventory

| Plugin | Manages | Backends | Entity |
|--------|---------|----------|--------|
| `enjoin-user` | Users, groups, sudoers | useradd, groupadd | [User](../entities/user.md) |
| `enjoin-service` | System services | systemctl, init.d, rc-service | [Service](../entities/service.md) |
| `enjoin-firewall` | Firewall rules | ufw, iptables, nftables, firewalld | [Security/Firewall](../entities/security-firewall.md) |
| `enjoin-cron` | Scheduled tasks | crontab, systemd timers | [Cron](../entities/cron.md) |
| `enjoin-network` | Network config | ip, nmcli, netplan, ifupdown | [System/Network](../entities/system-network.md) |
| `enjoin-filesystem` | Mounts, fstab | mount, fstab, tmpfs | [System/Filesystem](../entities/system-filesystem.md) |
| `enjoin-certificate` | TLS certificates | certbot, openssl, mkcert | [Security/Certificate](../entities/security-certificate.md) |
| `enjoin-selinux` | SELinux policies | semanage, setsebool, restorecon | — |
| `enjoin-apparmor` | AppArmor profiles | aa-enforce, aa-complain | — |
| `enjoin-sysctl` | Kernel parameters | sysctl.conf | — |

## Protocol

Enjoin plugins follow the standard [Plugin Protocol](../architecture/plugin-system.md):

```bash
# Plugin metadata — declares which entity types are supported
enjoin-user info
# {"name": "enjoin-user", "version": "1.0.0", "supports": ["amadla.org/entity/user@^v1.0.0"], ...}

# Apply system state (file or stdin)
enjoin-user apply -f users.yaml
# {"success": true, "status": "applied", "changes": [...]}

# Dry-run validation
enjoin-user validate -f users.yaml
# {"success": true, "status": "valid", "changes": [...]}

# Exit codes: 0 = success, 1 = failure, 2 = usage error
```

## Backend Selection

Each fat plugin selects its backend at runtime:

1. **OS/Preference entity** — explicit declaration (e.g., `firewall: firewalld`)
2. **Runtime detection** — probes PATH for available tools (fallback if no OS entity)
3. **Mismatch warning** — if entity declares firewalld but system has ufw, warn/error

Example: `enjoin-service` detects:

- `systemctl` on PATH → systemd backend
- `rc-service` on PATH → OpenRC backend
- Neither → SysV init backend (`service`, `update-rc.d`)

## Go Framework (Optional)

**LibraryEnjoinFramework** provides convenience wrappers for Go plugin authors:

- Standard `apply`/`validate` subcommands with entity input handling
- JSON result output with status and change details
- `-o table|json|yaml` display formatting
- UNIX exit code protocol

Plugins can also be written in any language — just implement the protocol.

## Active Plugins

### enjoin-user

Manages system users and groups.

- **Repo:** [AmadlaOrg/enjoin-user](https://github.com/AmadlaOrg/enjoin-user)
- **Entity:** [User](../entities/user.md)
- **Backends:** `useradd`/`usermod`/`userdel`, `groupadd`/`groupmod`/`groupdel`
- **Features:** UID/GID assignment, supplementary groups, shell, home directory, system accounts, sudoers

```yaml
# Example input
users:
  - name: deploy
    shell: /bin/bash
    groups: [docker, sudo]
    sudoer: true
groups:
  - name: deploy
```

### enjoin-service

Manages system services (start, stop, enable, disable, restart).

- **Repo:** [AmadlaOrg/enjoin-service](https://github.com/AmadlaOrg/enjoin-service)
- **Entity:** [Service](../entities/service.md)
- **Backends:** systemd (`systemctl`), SysV (`service`/`update-rc.d`), OpenRC (`rc-service`/`rc-update`)
- **Features:** State management (started/stopped/restarted), enable/disable at boot

```yaml
# Example input
services:
  - name: nginx
    state: started
    enabled: true
  - name: apache2
    state: stopped
    enabled: false
```

### enjoin-firewall

Manages firewall rules and default policies.

- **Repo:** [AmadlaOrg/enjoin-firewall](https://github.com/AmadlaOrg/enjoin-firewall)
- **Entity:** [Security/Firewall](../entities/security-firewall.md)
- **Backends:** ufw, firewalld (`firewall-cmd`), nftables (`nft`), iptables
- **Features:** Default policy (allow/deny), per-rule action/direction/protocol/port, source/destination filtering

```yaml
# Example input
default_policy: deny
rules:
  - action: allow
    direction: in
    protocol: tcp
    port: "443"
    comment: "HTTPS"
  - action: allow
    direction: in
    protocol: tcp
    port: "22"
    from: "10.0.0.0/8"
    comment: "SSH from internal"
```

## Workflow

```
Entity (YAML/JSON)  →  enjoin  →  enjoin-* plugin  →  OS-aware backend  →  system changes
                         │              │                     │
                    --from flag    auto-detect or        useradd,
                    routes to      OS/Preference         systemctl,
                    plugin         selects backend       ufw, etc.
```
