# Infrastructure/VM

| Field | Value |
|-------|-------|
| **Purpose** | Defines virtual machine provisioning — base box, disks, port forwarding, synced folders |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/VM](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/vm@v1.0.0` |
| **Parent type** | [Infrastructure](infrastructure.md) |

## Schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `box` | string | Yes | Base box or image name (e.g., `debian/bookworm64`) |
| `box_url` | string (URI) | No | URL to download the base box |
| `disk.size` | integer/string | No | Primary disk size (e.g., `20g`) |
| `disk.type` | string | No | `ssd`, `hdd`, or `nvme` |
| `additional_disks` | array | No | Extra disks with `size`, `type`, `mount_point` |
| `forwarded_ports` | array | No | Port mappings: `guest`, `host`, `protocol` (tcp/udp) |
| `synced_folders` | array | No | Shared folders: `host`, `guest`, `type` (nfs/rsync/9p/virtiofs) |
| `gui` | boolean | No | Enable GUI display (default: `false`) |

CPU, memory, network, and filesystem are **not** part of this schema. They are declared as separate entities and connected via `_requires`. This avoids duplicating what [System/CPU](system-cpu.md), [System/Memory](system-memory.md), [System/Network](system-network.md), and [System/Filesystem](system-filesystem.md) already define.

## Example

```yaml
# vm.hery — what to provision
_type: amadla.org/entity/infrastructure/vm@v1.0.0
_requires:
  - amadla.org/entity/system/cpu@v1.0.0
  - amadla.org/entity/system/memory@v1.0.0
  - amadla.org/entity/system/network@v1.0.0
_body:
  box: debian/bookworm64
  disk:
    size: 20g
    type: ssd
  forwarded_ports:
    - guest: 80
      host: 8080
    - guest: 443
      host: 8443
  synced_folders:
    - host: ./src
      guest: /opt/app
      type: virtiofs

# cpu.hery — how many CPUs
_type: amadla.org/entity/system/cpu@v1.0.0
_body:
  cpus: 2
  cpuset: "0,1"

# memory.hery — how much RAM
_type: amadla.org/entity/system/memory@v1.0.0
_body:
  mem_limit: 2g

# network.hery — network config
_type: amadla.org/entity/system/network@v1.0.0
_body:
  network:
    name: vm-net
    driver: bridge
  dns:
    - 8.8.8.8
```

Each concern is a separate entity file. `raise` reads the VM entity and its `_requires` to get the full picture. The DAG ensures CPU/Memory/Network are resolved before provisioning.

## Consumers

| Tool | How It Uses Infrastructure/VM |
|------|-------------------------------------|
| [raise](../tools/raise.md) | Provisions VMs via raise-libvirt, raise-virtualbox, or raise-vmware plugins |
| [conduct](../tools/conduct.md) | Coordinates multi-VM deployments |
