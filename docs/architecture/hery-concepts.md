# HERY Concepts

HERY (Hierarchical Entity Relational YAML) is the data foundation of the Amadla ecosystem. It extends YAML with entity management capabilities, combining concepts from relational databases and package managers.

## Core Model

HERY organizes data into three levels:

| HERY Component | RDBMS Analogy | Description |
|----------------|---------------|-------------|
| **Collection** | Database | A group of related entities (e.g., a project's full stack definition) |
| **Entity** | Table | A versioned schema with a URI (e.g., `EntityApplication@v1.0.0`) |
| **Entity Content** | Row | A specific instance of an entity with actual data |

## Reserved YAML Properties

HERY adds four reserved properties to YAML:

### `_entity` — Identity

The entity URI with version. Identifies what schema this content conforms to.

```yaml
_entity: github.com/AmadlaOrg/EntityApplication@v1.0.0
```

Versions follow semver. Use `@latest` to resolve the most recent version.

### `_meta` — Metadata

Metadata about the entity instance (similar to HTML `<meta>`).

```yaml
_meta:
  description: "Production web server configuration"
  tags: [production, web]
```

### `_id` — References

Links to other entities, functioning like foreign keys in a relational database.

```yaml
_id:
  - github.com/AmadlaOrg/EntitySystem@v1.0.0
  - github.com/AmadlaOrg/EntitySecret@v1.0.0
```

This creates a dependency graph between entities — an application entity can reference the system, secret, and infrastructure entities it requires.

### `_body` — Content

The actual entity data (similar to HTML `<body>`).

```yaml
_body:
  name: nginx
  version: ">=1.24"
  config_path: /etc/nginx/nginx.conf
```

The body is validated against the entity's JSON Schema.

## Complete Example

```yaml
_entity: github.com/AmadlaOrg/EntityApplication@v1.0.0
_meta:
  description: "My web application"
_id:
  - github.com/AmadlaOrg/EntitySystem@v1.0.0
_body:
  name: my-web-app
  requires:
    - _entity: github.com/AmadlaOrg/EntitySystem@v1.0.0
      _body:
        package: nginx
        version: ">=1.24"
```

## Schema Validation

Every entity type has a JSON Schema that validates `_body` content. Schemas are stored in the entity definition repositories (e.g., `EntityApplication` contains a `schema.json`).

```
EntityApplication/
├── amadla.yml          # Entity metadata
└── .amadla/
    ├── schema.json     # JSON Schema for _body validation
    └── tests/          # Test data for schema validation
```

hery validates entity content against its schema on write and can re-validate on query.

## Collections

A collection groups related entities — typically all the entities needed to define a project or environment.

```bash
# Initialize a new collection
hery collection init my-stack

# List entities in a collection
hery collection list --collection my-stack
```

Collections are stored on the filesystem and cached in SQLite for fast querying.

## Entity Versioning

Entities are versioned via Git. The entity URI includes the version:

```
github.com/AmadlaOrg/EntityApplication@v1.0.0
github.com/AmadlaOrg/EntityApplication@v2.0.0
github.com/AmadlaOrg/EntityApplication@latest
```

hery resolves `@latest` to the most recent Git tag. Version pinning ensures reproducible deployments.

## Querying

hery provides a query engine for searching entity content:

```bash
# Query entities in a collection
hery query --collection my-stack "EntityApplication"

# Compose multiple entities into a unified view
hery compose --collection my-stack
```

Queries run against the SQLite cache for performance. The cache is rebuilt from source YAML files when needed.

## Storage Architecture

```
Collection (filesystem)
    │
    ├── YAML files (source of truth)
    │   └── Versioned via Git
    │
    └── SQLite cache (fast queries)
        └── Rebuilt from YAML on demand
```

The dual storage model means:

- **YAML files** are human-readable, version-controlled, and portable
- **SQLite cache** provides fast structured queries without parsing YAML on every access
