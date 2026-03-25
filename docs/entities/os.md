# OS

| Field | Value |
|-------|-------|
| **Purpose** | Defines operating system identity — distro, version, architecture, kernel, init system |
| **Repo** | [AmadlaOrg/Entities/OS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/os@v1.0.0` |

## Schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `distro` | string | yes | Distribution name (e.g., `rocky`, `ubuntu`, `debian`, `alpine`, `arch`, `fedora`, `opensuse`) |
| `version` | string | no | Distribution version (e.g., `9`, `24.04`, `3.20`) |
| `arch` | array of strings | yes | Supported architectures (e.g., `["x86_64", "aarch64"]`) |
| `family` | string | no | Abstract OS family: `rhel`, `debian`, `arch`, `alpine`, `suse`, `gentoo`, `bsd`, `macos`, `windows` |
| `init` | string | no | Init system: `systemd`, `openrc`, `sysvinit`, `launchd`, `windows` (default: `systemd`) |
| `kernel` | string | no | Kernel version constraint (e.g., `>=5.15`) |
| `codename` | string | no | Distribution release codename (e.g., `noble`, `bookworm`) |

## Sub-types

| Entity | Purpose | Handled By |
|--------|---------|------------|
| [OS/Preference](os-preference.md) | Preferred system tools per concern (firewall, network, cron, etc.) | lay, enjoin |

## Example

```yaml
_type: amadla.org/entity/os@v1.0.0
_body:
  distro: rocky
  version: "9"
  arch:
    - x86_64
    - aarch64
  family: rhel
  init: systemd
  kernel: ">=5.14"
  codename: Blue Onyx
```

### Minimal example

```yaml
_type: amadla.org/entity/os@v1.0.0
_body:
  distro: ubuntu
  arch:
    - x86_64
```

## Consumers

| Tool | How It Uses OS |
|------|----------------|
| [lay](../tools/lay.md) | Selects package manager and install commands based on distro/family |
| [enjoin](../tools/enjoin.md) | Selects backend tools (firewall, service manager, cron) based on OS identity |
| [raise](../tools/raise.md) | Chooses VM images and cloud AMIs matching distro/version/arch |
| [unravel](../tools/unravel.md) | Discovers and outputs the OS entity from a running system |
| [judge](../tools/judge.md) | Validates that the running OS matches declared requirements |
