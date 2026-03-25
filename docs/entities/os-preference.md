# OS/Preference

| Field | Value |
|-------|-------|
| **Purpose** | Declares preferred system tools per concern — package manager, firewall, network, cron, MAC |
| **Repo** | [AmadlaOrg/Entities/OS/Preference](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/os/preference@v1.0.0` |
| **Parent** | [OS](os.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `network` | string | Preferred network tool: `nmcli`, `netplan`, `ifupdown`, `systemd-networkd`, `networkmanager` |
| `firewall` | string | Preferred firewall backend: `ufw`, `iptables`, `nftables`, `firewalld` |
| `mac` | string | Mandatory Access Control system: `selinux`, `apparmor`, `none` (default: `none`) |
| `mac_mode` | string | MAC enforcement mode: `enforcing`, `permissive` (SELinux) or `enforce`, `complain` (AppArmor) or `disabled` |
| `package_managers` | object | Package manager preferences |
| `package_managers.default` | string | Default package manager (e.g., `dnf`, `apt`, `pacman`, `brew`) — **required** within object |
| `package_managers.additional` | array of strings | Additional package managers available (e.g., `snap`, `flatpak`, `nix`) |
| `cron` | string | Preferred scheduling backend: `crontab`, `systemd-timer` |
| `service_manager` | string | Preferred service management: `systemd`, `openrc`, `sysvinit` |

## Example

```yaml
_type: amadla.org/entity/os/preference@v1.0.0
_body:
  network: netplan
  firewall: nftables
  mac: apparmor
  mac_mode: enforce
  package_managers:
    default: apt
    additional:
      - snap
      - flatpak
  cron: systemd-timer
  service_manager: systemd
```

### RHEL-family example

```yaml
_type: amadla.org/entity/os/preference@v1.0.0
_body:
  network: nmcli
  firewall: firewalld
  mac: selinux
  mac_mode: enforcing
  package_managers:
    default: dnf
  cron: crontab
  service_manager: systemd
```

## Consumers

| Tool | How It Uses OS/Preference |
|------|---------------------------|
| [lay](../tools/lay.md) | Selects package manager backend from `package_managers.default` |
| [enjoin](../tools/enjoin.md) | Selects firewall, network, cron, and service backends from preferences |
| enjoin-network | Uses `network` preference to choose configuration tool |
| enjoin-selinux | Reads `mac` and `mac_mode` to determine SELinux configuration |
