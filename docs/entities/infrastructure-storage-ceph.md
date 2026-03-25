# Infrastructure/Storage/Ceph

| Field | Value |
|-------|-------|
| **Purpose** | Ceph-specific configuration -- unified distributed storage providing block, object, and file interfaces |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Storage/Ceph](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/storage/ceph@v1.0.0` |
| **Parent type** | [Infrastructure/Storage](infrastructure-storage.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `fsid` | string | Cluster filesystem ID (UUID) |
| `mon_initial_members` | array of strings | Initial monitor names for cluster bootstrap |
| `mon_host` | array of strings | Monitor host addresses |
| `public_network` | string | Public-facing network CIDR (e.g., `10.0.0.0/24`) |
| `cluster_network` | string | Cluster replication network CIDR |
| `osd_pool_default_size` | integer | Default replication factor for OSD pools |
| `osd_pool_default_min_size` | integer | Minimum number of replicas required for I/O |
| `osd_journal_size` | integer | OSD journal size in MB |
| `mds_standby_count` | integer | Number of standby MDS daemons for CephFS |
| `rgw_enabled` | boolean | Whether RADOS Gateway (S3/Swift API) is enabled |

## Example

```yaml
_type: amadla.org/entity/infrastructure/storage/ceph@v1.0.0
_extends: amadla.org/entity/infrastructure/storage@v1.0.0
_body:
  data_dir: /var/lib/ceph
  replication_factor: 3
  listen_address: 0.0.0.0
  listen_port: 6789
  storage_class: ssd
  fsid: a1b2c3d4-e5f6-7890-abcd-ef1234567890
  mon_initial_members:
    - mon1
    - mon2
    - mon3
  mon_host:
    - 10.0.0.11
    - 10.0.0.12
    - 10.0.0.13
  public_network: 10.0.0.0/24
  cluster_network: 10.0.1.0/24
  osd_pool_default_size: 3
  osd_pool_default_min_size: 2
  osd_journal_size: 5120
  mds_standby_count: 1
  rgw_enabled: true
```

## Consumers

| Tool | How It Uses Infrastructure/Storage/Ceph |
|------|-----------------------------------------|
| [raise](../tools/raise.md) | Provisions VMs/instances for Ceph MON, OSD, and MDS nodes |
| [lay](../tools/lay.md) | Installs `ceph-mon`, `ceph-osd`, `ceph-mds`, `ceph-radosgw` packages |
| [weaver](../tools/weaver.md) | Generates `/etc/ceph/ceph.conf` |
| enjoin-service | Enables/starts `ceph-mon`, `ceph-osd`, `ceph-mds` services |
