# Application/ServiceDiscovery/Etcd

| Field | Value |
|-------|-------|
| **Purpose** | Etcd-specific configuration -- distributed key-value store, backbone of Kubernetes |
| **Repo** | [AmadlaOrg/Entities/Application/ServiceDiscovery/Etcd](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/service-discovery/etcd@v1.0.0` |
| **Parent type** | [Application/ServiceDiscovery](application-service-discovery.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Human-readable name for this etcd member |
| `initial_cluster` | string | Initial cluster configuration (e.g., `node1=http://host1:2380,node2=http://host2:2380`) |
| `initial_cluster_state` | string | Whether this is a `new` cluster or joining an `existing` one |
| `initial_cluster_token` | string | Token to distinguish this cluster during initialization |
| `advertise_client_urls` | array of strings | URLs this member advertises to clients |
| `listen_peer_urls` | array of strings | URLs to listen on for peer communication |
| `listen_client_urls` | array of strings | URLs to listen on for client communication |
| `auto_compaction_retention` | string | Auto compaction retention period (e.g., `1h`) |
| `snapshot_count` | integer | Number of committed transactions to trigger a snapshot |

## Example

```yaml
_type: amadla.org/entity/application/service-discovery/etcd@v1.0.0
_extends: amadla.org/entity/application/service-discovery@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 2379
  data_dir: /var/lib/etcd
  cluster_name: etcd-prod
  name: node1
  initial_cluster: node1=http://10.0.0.11:2380,node2=http://10.0.0.12:2380,node3=http://10.0.0.13:2380
  initial_cluster_state: new
  initial_cluster_token: etcd-cluster-prod
  advertise_client_urls:
    - http://10.0.0.11:2379
  listen_peer_urls:
    - http://10.0.0.11:2380
  listen_client_urls:
    - http://0.0.0.0:2379
  auto_compaction_retention: 1h
  snapshot_count: 10000
```

## Consumers

| Tool | How It Uses Application/ServiceDiscovery/Etcd |
|------|------------------------------------------------|
| [lay](../tools/lay.md) | Installs the `etcd` binary |
| [weaver](../tools/weaver.md) | Generates `/etc/etcd/etcd.conf.yml` |
| enjoin-service | Enables/starts `etcd` service |
