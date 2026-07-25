# User

| Field | Value |
|-------|-------|
| **Purpose** | Defines system user and group configuration — accounts, permissions, SSH keys |
| **Repo** | [AmadlaOrg/Entities/User](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/user@v1.0.0` |

## Schema

User describes system user requirements:

- Username (POSIX-compliant pattern) and optional UID
- Primary group and GID, supplementary groups
- Home directory and login shell
- GECOS comment (full name)
- System account flag
- Home directory creation
- Password via secret reference (resolved by doorman)
- SSH authorized keys
- Sudo access (boolean for full access, or custom sudoers rule)
- Account expiration date

## Example

```yaml
_type: amadla.org/entity/user@v1.0.0
_body:
  username: deploy
  group: deploy
  groups:
    - docker
    - sudo
  home: /home/deploy
  shell: /bin/bash
  comment: "Deployment user"
  ssh_authorized_keys:
    - "ssh-ed25519 AAAAC3... deploy@workstation"
  sudo: true
```

### Service account example

```yaml
_type: amadla.org/entity/user@v1.0.0
_body:
  username: my-app
  system: true
  create_home: false
  shell: /usr/sbin/nologin
  comment: "my-app service account"
```

## Consumers

| Tool | How It Uses User |
|------|------------------------|
| [enjoin](../tools/enjoin.md) | Creates/manages system users and groups via enjoin-user plugin |
| [doorman](../tools/doorman.md) | Resolves password secrets referenced by `password_secret` |
| [judge](../tools/judge.md) | Validates that users exist with correct configuration |
