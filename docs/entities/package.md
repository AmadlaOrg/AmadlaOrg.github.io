# Package

| Field | Value |
|-------|-------|
| **Purpose** | Defines system package installation — packages, repositories, and package manager configuration |
| **Repo** | [AmadlaOrg/Entities/Package](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/package@v1.0.0` |

## Schema

Package describes package installation requirements:

- Package manager: apt, yum, dnf, pacman, apk, brew, zypper, pkg, snap, flatpak (auto-detected if omitted)
- Packages: name, version constraint, and state (present/absent/latest) — supports both string shorthand and object format
- Custom repositories with GPG key URLs
- Update package index before installing
- Upgrade existing packages
- Clean cache after install

## Example

```yaml
_type: amadla.org/entity/package@v1.0.0
_body:
  manager: apt
  update: true
  packages:
    - nginx
    - name: postgresql
      version: ">=15"
      state: present
    - name: redis-server
      state: latest

  repositories:
    - name: docker-ce
      url: "https://download.docker.com/linux/debian bookworm stable"
      key: "https://download.docker.com/linux/debian/gpg"

  clean: true
```

## Consumers

| Tool | How It Uses Package |
|------|--------------------------|
| lay | Installs packages using the specified or detected package manager |
| judge-application | Checks that required packages are installed at correct versions |
| garbage | Tracks and removes packages that are no longer needed |
