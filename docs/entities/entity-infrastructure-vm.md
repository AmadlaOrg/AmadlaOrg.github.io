# EntityInfrastructure/VM

| Field | Value |
|-------|-------|
| **Purpose** | Defines virtual machine provisioning — base box, resources, networking, synced folders |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/VM](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/vm@v1.0.0` |
| **Parent type** | [EntityInfrastructure](entity-infrastructure.md) |

## Schema

EntityInfrastructure/VM describes VM requirements (Vagrant-like):

- Base box name and download URL
- CPUs and memory
- Primary disk (size, type) and additional disks with mount points
- Network type (private/public/bridged/NAT) with optional static IP and bridge interface
- Forwarded ports (guest/host/protocol)
- Synced folders (host/guest paths, sync type: NFS, rsync, 9p, virtiofs)
- GUI mode

## Example

```yaml
_type: amadla.org/entity/infrastructure/vm@v1.0.0
_body:
  box: debian/bookworm64
  cpus: 2
  memory: 2048
  disk:
    size: 20g
    type: ssd
  additional_disks:
    - size: 50g
      type: hdd
      mount_point: /data
  network:
    type: private
    ip: 192.168.56.10
  forwarded_ports:
    - guest: 80
      host: 8080
    - guest: 443
      host: 8443
  synced_folders:
    - host: ./src
      guest: /opt/app
      type: virtiofs
```

## Consumers

| Tool | How It Uses EntityInfrastructure/VM |
|------|-------------------------------------|
| raise | Provisions VMs via raise-libvirt, raise-virtualbox, or raise-vmware plugins |
| conduct | Coordinates multi-VM deployments |
