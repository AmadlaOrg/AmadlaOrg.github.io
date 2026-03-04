# hery

| Field | Value |
|-------|-------|
| **Purpose** | HERY (Hierarchical Entity Relational YAML) data storage with schema validation, Git versioning, and SQLite caching |
| **Module** | `github.com/AmadlaOrg/hery` |
| **Status** | Partial |
| **Repo** | [AmadlaOrg/hery](https://github.com/AmadlaOrg/hery) |
| **Go Version** | 1.24.0 |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `hery collection init` | Working | Initialize a new collection |
| `hery collection list` | Working | List collections |
| `hery entity get` | Working | Retrieve a specific entity |
| `hery entity list` | Working | List entities in a collection |
| `hery entity validate` | Working | Validate entity content against JSON Schema |
| `hery query` | Working | Query entities using filter expressions |
| `hery compose` | Working | Compose multiple entities into a unified view |
| `hery settings` | Working | Manage hery configuration |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | Git operations, file system, database, configuration |
| LibraryFramework | CLI framework (Cobra wrapper) |

### External Dependencies

| Package | Purpose |
|---------|---------|
| `gopkg.in/yaml.v3` | YAML parsing |
| `github.com/santhosh-tekuri/jsonschema/v6` | JSON Schema validation |
| `github.com/mattn/go-sqlite3` | SQLite caching layer |
| `github.com/itchyny/gojq` | JQ-style query engine |
| `github.com/google/uuid` | Entity ID generation |

## Pipeline Position

hery is the **first stage** in the Amadla pipeline. It reads YAML entity files from disk (or Git repos), validates them, caches them in SQLite, and outputs structured JSON for downstream tools.

```
YAML files → [hery] → JSON entity data → doorman → ...
```

No tool feeds into hery — it is the data source.

## Architecture

<!-- Diagram placeholder -->

### Package Structure

```
cmd/                    # Cobra CLI commands
├── entity.go           # hery entity (get, list, validate)
├── collection.go       # hery collection (init, list)
├── query.go            # hery query
├── compose.go          # hery compose
└── settings.go         # hery settings

entity/                 # Core entity logic
├── build/              # Entity building from YAML
├── cmd/                # Entity subcommand implementations
├── compose/            # Multi-entity composition
├── get/                # Entity retrieval
├── query/              # Query engine
├── schema/             # JSON Schema handling
├── validation/         # Entity validation against schema
└── version/            # Semver version resolution

collection/             # Collection management
cache/                  # SQLite caching layer
├── database/           # SQLite operations
└── parser/             # Cache parsing
storage/                # Filesystem abstraction
message/                # Error types
```

### Key Design Decisions

- **Dual storage:** YAML files (source of truth) + SQLite (fast queries)
- **Git-based versioning:** Entity URIs include version tags resolved from Git
- **JSON Schema validation:** Every entity type has a schema; validation is enforced
- **Interface-based design:** `IEntity`, `ICollection`, `IStorage`, `ICache` — all mockable
- **BDD testing:** Uses Ginkgo v2 + Gomega (unlike most Amadla projects which use testify)

## Current Gaps

- 34 files contain TODO comments indicating incomplete implementations
- Cache rebuild from source YAML may have edge cases
- Query engine covers basic cases but advanced queries need work
- Entity composition (`compose`) has known limitations
- Documentation within the project is sparse
- Estimated ~70 hours of remaining work across all components

## Key Files

| Path | Purpose |
|------|---------|
| `cmd/entity.go` | Entity command registration and flag setup |
| `cmd/collection.go` | Collection command registration |
| `cmd/query.go` | Query command entry point |
| `entity/entity.go` | Core `IEntity` / `SEntity` interface and implementation |
| `cache/database/` | SQLite schema and operations |
| `entity/schema/` | JSON Schema loading and validation |
| `entity/version/` | Semver resolution from Git tags |
| `.mockery.yaml` | Mock generation configuration |
| `.schema/` | Internal schema definitions |
| `resources/sql/` | SQL resource files |
