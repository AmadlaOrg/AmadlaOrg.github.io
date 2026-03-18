# Application/SearchEngine/Meilisearch

| Field | Value |
|-------|-------|
| **Purpose** | Meilisearch-specific configuration — instant, typo-tolerant search engine |
| **Repo** | [AmadlaOrg/Entities/Application/SearchEngine/Meilisearch](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/search-engine/meilisearch@v1.0.0` |
| **Parent type** | [Application/SearchEngine](application-search-engine.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `master_key_secret` | string | Doorman secret reference for the master key |
| `db_path` | string | Path to the database directory |
| `max_indexing_memory` | string | Maximum memory for indexing operations |
| `max_indexing_threads` | integer | Maximum number of indexing threads |
| `log_level` | string | Logging verbosity level (`ERROR`, `WARN`, `INFO`, `DEBUG`, `TRACE`) |
| `snapshot_dir` | string | Directory for snapshots |
| `schedule_snapshot` | boolean | Enable scheduled snapshots |

## Example

```yaml
_type: amadla.org/entity/application/search-engine/meilisearch@v1.0.0
_extends: amadla.org/entity/application/search-engine@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 7700
  cluster_name: meili-prod
  heap_size: 1g
  master_key_secret: doorman://vault/meilisearch/master-key
  db_path: /var/lib/meilisearch/data
  max_indexing_memory: 2g
  max_indexing_threads: 4
  log_level: INFO
  snapshot_dir: /var/lib/meilisearch/snapshots
  schedule_snapshot: true
```

## Consumers

| Tool | How It Uses Application/SearchEngine/Meilisearch |
|------|--------------------------------------------------|
| lay | Installs the `meilisearch` binary |
| weaver | Generates Meilisearch environment configuration |
| enjoin-service | Enables/starts `meilisearch` service |
