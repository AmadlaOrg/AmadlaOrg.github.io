# Application/SearchEngine/OpenSearch

| Field | Value |
|-------|-------|
| **Purpose** | OpenSearch-specific configuration — open-source search and analytics suite |
| **Repo** | [AmadlaOrg/Entities/Application/SearchEngine/OpenSearch](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/search-engine/opensearch@v1.0.0` |
| **Parent type** | [Application/SearchEngine](application-search-engine.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `node_name` | string | Name of this OpenSearch node |
| `node_roles` | array of strings | Roles for this node |
| `discovery_seed_hosts` | array of strings | Seed hosts for cluster discovery |
| `cluster_initial_master_nodes` | array of strings | Initial master-eligible nodes for cluster bootstrapping |
| `plugins_security_disabled` | boolean | Disable the OpenSearch security plugin |
| `compatibility_mode` | boolean | Enable Elasticsearch compatibility mode |

## Example

```yaml
_type: amadla.org/entity/application/search-engine/opensearch@v1.0.0
_extends: amadla.org/entity/application/search-engine@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 9200
  cluster_name: opensearch-cluster
  data_dir: /var/lib/opensearch
  heap_size: 2g
  node_name: os-node-1
  node_roles:
    - cluster_manager
    - data
    - ingest
  discovery_seed_hosts:
    - os-node-1
    - os-node-2
  cluster_initial_master_nodes:
    - os-node-1
    - os-node-2
  plugins_security_disabled: false
  compatibility_mode: true
```

## Consumers

| Tool | How It Uses Application/SearchEngine/OpenSearch |
|------|-------------------------------------------------|
| lay | Installs the `opensearch` package |
| weaver | Generates `/etc/opensearch/opensearch.yml` and `/etc/opensearch/jvm.options` |
| enjoin-service | Enables/starts `opensearch` service |
