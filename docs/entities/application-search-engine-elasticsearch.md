# Application/SearchEngine/Elasticsearch

| Field | Value |
|-------|-------|
| **Purpose** | Elasticsearch-specific configuration — distributed search and analytics engine |
| **Repo** | [AmadlaOrg/Entities/Application/SearchEngine/Elasticsearch](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/search-engine/elasticsearch@v1.0.0` |
| **Parent type** | [Application/SearchEngine](application-search-engine.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `node_name` | string | Name of this Elasticsearch node |
| `node_roles` | array of strings | Roles for this node (e.g., `master`, `data`, `ingest`, `ml`, `coordinating`) |
| `discovery_seed_hosts` | array of strings | Seed hosts for cluster discovery |
| `cluster_initial_master_nodes` | array of strings | Initial master-eligible nodes for cluster bootstrapping |
| `path_logs` | string | Path to the log directory |
| `xpack_security_enabled` | boolean | Enable X-Pack security features |
| `xpack_security_transport_ssl.enabled` | boolean | Enable transport SSL |
| `xpack_security_transport_ssl.keystore` | string | Path to the keystore file |
| `xpack_security_transport_ssl.truststore` | string | Path to the truststore file |

## Example

```yaml
_type: amadla.org/entity/application/search-engine/elasticsearch@v1.0.0
_extends: amadla.org/entity/application/search-engine@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 9200
  cluster_name: production
  data_dir: /var/lib/elasticsearch
  heap_size: 4g
  node_name: es-node-1
  node_roles:
    - master
    - data
    - ingest
  discovery_seed_hosts:
    - es-node-1
    - es-node-2
    - es-node-3
  cluster_initial_master_nodes:
    - es-node-1
    - es-node-2
    - es-node-3
  path_logs: /var/log/elasticsearch
  xpack_security_enabled: true
  xpack_security_transport_ssl:
    enabled: true
    keystore: /etc/elasticsearch/certs/elastic-certificates.p12
    truststore: /etc/elasticsearch/certs/elastic-certificates.p12
```

## Consumers

| Tool | How It Uses Application/SearchEngine/Elasticsearch |
|------|---------------------------------------------------|
| [lay](../tools/lay.md) | Installs the `elasticsearch` package |
| [weaver](../tools/weaver.md) | Generates `/etc/elasticsearch/elasticsearch.yml` and `/etc/elasticsearch/jvm.options` |
| enjoin-service | Enables/starts `elasticsearch` service |
