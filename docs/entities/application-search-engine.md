# Application/SearchEngine

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all search engine applications |
| **Repo** | [AmadlaOrg/Entities/Application/SearchEngine](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/search-engine@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Bind address for the search engine service |
| `listen_port` | integer | Port the search engine service listens on |
| `cluster_name` | string | Name of the search cluster |
| `data_dir` | string | Directory for index and data storage |
| `heap_size` | string | JVM heap or memory allocation (e.g., `1g`, `512m`) |

These properties are common across all search engine implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Use Case |
|----------|-------------|----------|
| [SearchEngine/Elasticsearch](application-search-engine-elasticsearch.md) | Elasticsearch — distributed search and analytics | Full-text search, log analytics, APM |
| [SearchEngine/OpenSearch](application-search-engine-opensearch.md) | OpenSearch — open-source Elasticsearch fork | Drop-in Elasticsearch replacement (Apache 2.0) |
| [SearchEngine/Meilisearch](application-search-engine-meilisearch.md) | Meilisearch — instant search engine | Typo-tolerant instant search, lightweight |

## Example

```yaml
_type: amadla.org/entity/application/search-engine@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 9200
  cluster_name: search-cluster
  data_dir: /var/lib/search/data
  heap_size: 1g
```

## Consumers

| Tool | How It Uses Application/SearchEngine |
|------|--------------------------------------|
| [lay](../tools/lay.md) | Installs the search engine application (elasticsearch, opensearch, meilisearch) |
| enjoin-service | Enables/starts the search engine service |
| [weaver](../tools/weaver.md) | Generates configuration files (elasticsearch.yml, opensearch.yml) |
