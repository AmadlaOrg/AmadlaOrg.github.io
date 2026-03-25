# Application/ServiceDiscovery

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all service discovery applications |
| **Repo** | [AmadlaOrg/Entities/Application/ServiceDiscovery](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/service-discovery@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the service discovery daemon listens on |
| `listen_port` | integer | Port the service discovery daemon listens on |
| `data_dir` | string | Directory for persistent data storage |
| `cluster_name` | string | Name of the service discovery cluster |

These properties are common across all service discovery implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [ServiceDiscovery/Consul](application-service-discovery-consul.md) | Consul -- service mesh, health checking, KV store |
| [ServiceDiscovery/Etcd](application-service-discovery-etcd.md) | etcd -- distributed key-value store, Kubernetes backbone |
| [ServiceDiscovery/ZooKeeper](application-service-discovery-zookeeper.md) | ZooKeeper -- coordination service for distributed systems |

## Example

```yaml
_type: amadla.org/entity/application/service-discovery@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 8500
  data_dir: /var/lib/service-discovery
  cluster_name: dc1
```

## Consumers

| Tool | How It Uses Application/ServiceDiscovery |
|------|------------------------------------------|
| [lay](../tools/lay.md) | Installs the service discovery application (consul, etcd, zookeeper) |
| [weaver](../tools/weaver.md) | Generates configuration files |
| enjoin-service | Enables/starts the service discovery daemon |
