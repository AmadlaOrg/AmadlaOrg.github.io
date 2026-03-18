# Infrastructure/Storage/GlusterFS

| Field | Value |
|-------|-------|
| **Purpose** | GlusterFS-specific configuration -- distributed POSIX filesystem with transparent replication |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Storage/GlusterFS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/storage/glusterfs@v1.0.0` |
| **Parent type** | [Infrastructure/Storage](infrastructure-storage.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `peers` | array of strings | Trusted storage pool peer addresses |
| `volumes` | array of objects | GlusterFS volume definitions |
| `volumes[].name` | string | Volume name |
| `volumes[].type` | string | Volume type (`distribute`, `replicate`, `disperse`, `stripe`) |
| `volumes[].bricks` | array of strings | Brick locations in `host:/path` format |
| `volumes[].replica_count` | integer | Number of replicas per file |
| `volumes[].disperse_count` | integer | Number of bricks in disperse set |
| `volumes[].redundancy_count` | integer | Number of redundancy bricks in disperse volume |
| `volumes[].transport` | string | Transport protocol (`tcp` or `rdma`) |
| `nfs_enabled` | boolean | Whether NFS export of volumes is enabled |

## Example

```yaml
_type: amadla.org/entity/infrastructure/storage/glusterfs@v1.0.0
_extends: amadla.org/entity/infrastructure/storage@v1.0.0
_body:
  data_dir: /data/glusterfs
  replication_factor: 3
  listen_address: 0.0.0.0
  listen_port: 24007
  storage_class: standard
  peers:
    - gfs1.example.com
    - gfs2.example.com
    - gfs3.example.com
  volumes:
    - name: shared-data
      type: replicate
      replica_count: 3
      transport: tcp
      bricks:
        - gfs1.example.com:/data/brick1
        - gfs2.example.com:/data/brick1
        - gfs3.example.com:/data/brick1
    - name: large-files
      type: disperse
      disperse_count: 6
      redundancy_count: 2
      transport: tcp
      bricks:
        - gfs1.example.com:/data/brick2
        - gfs2.example.com:/data/brick2
        - gfs3.example.com:/data/brick2
        - gfs1.example.com:/data/brick3
        - gfs2.example.com:/data/brick3
        - gfs3.example.com:/data/brick3
  nfs_enabled: false
```

## Consumers

| Tool | How It Uses Infrastructure/Storage/GlusterFS |
|------|-----------------------------------------------|
| raise | Provisions VMs/instances for GlusterFS nodes |
| lay | Installs the `glusterfs-server` package |
| weaver | Generates volume configuration scripts |
| enjoin-service | Enables/starts `glusterd` service |
