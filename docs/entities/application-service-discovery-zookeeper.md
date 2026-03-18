# Application/ServiceDiscovery/ZooKeeper

| Field | Value |
|-------|-------|
| **Purpose** | ZooKeeper-specific configuration -- coordination service for distributed systems (Kafka, Hadoop) |
| **Repo** | [AmadlaOrg/Entities/Application/ServiceDiscovery/ZooKeeper](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/service-discovery/zookeeper@v1.0.0` |
| **Parent type** | [Application/ServiceDiscovery](application-service-discovery.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `tick_time` | integer | Length of a single tick in milliseconds (basic time unit) |
| `init_limit` | integer | Number of ticks allowed for initial synchronization |
| `sync_limit` | integer | Number of ticks allowed for followers to sync with the leader |
| `client_port` | integer | Port for client connections (default: `2181`) |
| `max_client_cnxns` | integer | Maximum number of concurrent client connections per IP |
| `autopurge.snap_retain_count` | integer | Number of snapshots to retain |
| `autopurge.purge_interval` | integer | Purge interval in hours (`0` to disable) |
| `servers` | array of objects | ZooKeeper ensemble server definitions |
| `servers[].id` | integer | Unique server ID (myid) |
| `servers[].host` | string | Server hostname or address |
| `servers[].peer_port` | integer | Port for peer communication (default `2888`) |
| `servers[].election_port` | integer | Port for leader election (default `3888`) |

## Example

```yaml
_type: amadla.org/entity/application/service-discovery/zookeeper@v1.0.0
_extends: amadla.org/entity/application/service-discovery@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 2181
  data_dir: /var/lib/zookeeper
  cluster_name: zk-prod
  tick_time: 2000
  init_limit: 10
  sync_limit: 5
  client_port: 2181
  max_client_cnxns: 60
  autopurge:
    snap_retain_count: 3
    purge_interval: 1
  servers:
    - id: 1
      host: 10.0.0.11
      peer_port: 2888
      election_port: 3888
    - id: 2
      host: 10.0.0.12
      peer_port: 2888
      election_port: 3888
    - id: 3
      host: 10.0.0.13
      peer_port: 2888
      election_port: 3888
```

## Consumers

| Tool | How It Uses Application/ServiceDiscovery/ZooKeeper |
|------|-----------------------------------------------------|
| lay | Installs the `zookeeper` package |
| weaver | Generates `/etc/zookeeper/zoo.cfg` and `myid` file |
| enjoin-service | Enables/starts `zookeeper` service |
