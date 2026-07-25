# Security/AppArmor

| Field | Value |
|-------|-------|
| **Purpose** | AppArmor mandatory access control profiles and policies |
| **Repo** | [AmadlaOrg/Entities/Security/AppArmor](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/security/apparmor@v1.0.0` |
| **Parent type** | [Security](security.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `profiles` | array of objects | AppArmor profile definitions |
| `profiles[].name` | string | Profile name (required) |
| `profiles[].path` | string | Binary path the profile applies to (required) |
| `profiles[].mode` | string | Profile enforcement mode: `enforce`, `complain`, or `disable` (required) |
| `profiles[].rules` | array of strings | Raw AppArmor rules for this profile |
| `custom_profiles_dir` | string | Directory for custom profiles (e.g., `/etc/apparmor.d`) |
| `tunables` | object | Key-value tunable variables |
| `abstractions` | array of strings | Included abstractions (e.g., `base`, `nameservice`, `authentication`) |

## Example

```yaml
_type: amadla.org/entity/security/apparmor@v1.0.0
_body:
  profiles:
    - name: usr.sbin.nginx
      path: /usr/sbin/nginx
      mode: enforce
      rules:
        - /var/log/nginx/** rw,
        - /etc/nginx/** r,
        - /var/www/** r,
    - name: usr.bin.curl
      path: /usr/bin/curl
      mode: complain
  custom_profiles_dir: /etc/apparmor.d
  tunables:
    HOME: /home/*
  abstractions:
    - base
    - nameservice
```

## Consumers

| Tool | How It Uses Security/AppArmor |
|------|-------------------------------|
| [enjoin](../tools/enjoin.md) | Manages AppArmor profiles via enjoin-apparmor plugin |
| [judge](../tools/judge.md) | Validates that profiles are loaded and in the expected mode |
