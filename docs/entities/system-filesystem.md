# System/Filesystem

| Field | Value |
|-------|-------|
| **Purpose** | Defines storage and volume configuration — inspired by Docker Compose volumes |
| **Repo** | [AmadlaOrg/Entities/System/Filesystem](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/system/filesystem@v1.0.0` |
| **Parent type** | [System](system.md) |

## Schema

System/Filesystem describes storage requirements:

- Named volumes: name, driver (default: local), driver options, labels
- Mounts: type (bind/volume/tmpfs/nfs/cifs), source, target, read-only flag, mount options
- Tmpfs mounts: target path, size, mode
- Root filesystem read-only flag

## Example

```yaml
_type: amadla.org/entity/system/filesystem@v1.0.0
_body:
  volumes:
    - name: app-data
      driver: local
      labels:
        com.example.description: "Application persistent data"

    - name: db-data
      driver: local
      driver_opts:
        type: nfs
        o: "addr=192.168.1.100,rw"
        device: ":/exports/db-data"

  mounts:
    - type: bind
      source: /opt/config
      target: /etc/my-app
      read_only: true

    - type: volume
      source: app-data
      target: /var/lib/my-app

  tmpfs:
    - target: /tmp
      size: 100m
      mode: 1777
```

## Consumers

| Tool | How It Uses System/Filesystem |
|------|-----------------------------------|
| enjoin-filesystem | Creates volumes, mount points, fstab entries, tmpfs |
| raise | Provisions storage for VMs/cloud instances |
| judge | Validates that volumes and mounts exist with correct configuration |
