# HERY Concepts

HERY (Hierarchical Entity Relational YAML) is the data foundation of the Amadla ecosystem. It extends YAML with entity management capabilities, combining concepts from relational databases and package managers.

## Core Model

| HERY Term | Analogy | Description |
|-----------|---------|-------------|
| **Entity Type** | Table schema | A versioned type with a JSON Schema (e.g., `application@v1.0.0`) |
| **Entity Instance** | Row | A specific `.hery` document with actual data |

## File Format

HERY files use the `.hery` extension and are valid YAML. A file may contain multiple YAML documents separated by `---`, each representing an independent entity instance. However, if an element needs to be individually addressable via `_parent`, it must be its own file — multi-document YAML is only for anonymous accumulation (e.g., multiple firewall rules in one file).

```yaml
---
_type: amadla.org/entity/application@v1.0.0
_body:
  name: my-app
```

An optional `yaml-language-server` comment enables IDE validation (VS Code, JetBrains, Vim/Neovim). The authoritative type declaration is the `_type` property. Tooling (`hery fmt`) can auto-generate the comment.

## Reserved Properties

HERY defines five reserved properties, recognized only at the **document root**.

### `_type` — Type (required)

Declares the entity type and version. Determines which JSON Schema validates this document. hery resolves the URI to fetch the entity type (schema + defaults).

```yaml
_type: amadla.org/entity/application/webserver@v1.0.0
```

Versions follow semver. Use `@latest` for the most recent version. Both vanity URIs (`amadla.org/entity/...`) and direct Git URIs (`github.com/...`) are supported.

When used with `_parent`, `_type` and `_parent` serve different roles: `_type` declares the schema (what this entity *is*), `_parent` declares data inheritance (who it inherits from). When only `_parent` is present, `_type` is inherited from the parent. When both are present and they conflict, hery warns but allows it (e.g., for schema version upgrades).

### `_parent` — Parent (optional)

Inherit values from another entity instance of the **same type**. The parent's values are deep-merged as defaults — the child only specifies overrides. `_parent` is purely a data/merge operation — it does not imply execution ordering.

`_parent` targets specific elements using the filename as a path segment in the URI:

```yaml
_parent: github.com/SomeOrg/WordPress/database.hery
_body:
  engine: mariadb
  version: "11.4"
```

This overrides just the `database.hery` element from the WordPress entity. The filename is the element identity — one addressable element = one file.

If the parent defines `protocol: tcp` and the child doesn't override it, the merged result includes `protocol: tcp`. Parents can chain transitively. Cycles are detected and rejected.

### `_meta` — Metadata (optional)

Metadata for filtering, searching, and categorizing entities. Structure defined by the entity's schema.

```yaml
_meta:
  name: My Application
  description: Production web server configuration
  tags: [production, web]
```

### `_body` — Content (optional)

Contains the entity's data. Validated against the entity's JSON Schema.

```yaml
_body:
  server_name: localhost
  port: 443
  protocol: tcp
```

When `_body` is omitted, the entity inherits all defaults from its `_parent` (if any).

### `_require` — Dependencies (optional)

Declares hard dependencies on other entities. Used by amadla to build a dependency graph (DAG) and determine execution order via topological sort.

```yaml
_require:
  - github.com/AmadlaOrg/Entities/Application/DB/RDBMS@^v1.0.0   # any RDBMS entity
  - github.com/SomeOrg/WordPress#php.hery                          # specific element
  - #database.hery                                                  # local element (same directory)
```

`_require` references can be:

- **Entity type URIs** — "at least one entity of this type must exist and be processed before me." Supports version constraints (`@v1.0.0` exact, `@^v1.0.0` compatible range).
- **`#filename.hery`** — targets a specific element within an entity (local or remote).
- Relative paths are **sandboxed** to the entity directory (no `../` escape).

`_require` is orthogonal to `_parent`: `_parent` handles data inheritance (merge), `_require` handles execution ordering. Use both when you need inheritance AND ordering.

hery validates `_require` syntax at parse time. amadla validates that referenced entities actually exist at orchestration time.

Note: `_require` declares entity-level dependencies. Application-specific dependencies (like podman-compose `depends_on`) go in `_body` as `require` — these are handled by the relevant tool (e.g., lay), not amadla.

**Reservation rules:**

- `_`-prefixed keys are reserved at the **document root** only
- Inside `_body` and `_meta`, `_`-prefixed keys are regular data (e.g., `_id` for MongoDB documents)
- The five reserved properties cannot appear inside `_body` or `_meta`

## Entity Composition (via Schema)

Sub-entities are **not nested** inside `_body` with HERY markup. Instead, the entity's JSON Schema uses standard `$ref` to declare which parts of `_body` correspond to other entity types:

```yaml
_type: amadla.org/entity/application/webserver@v1.0.0
_body:
  server_name: localhost
  port: 443
  database:
    engine: postgres
    port: 5432
```

The WebServer schema declares that `database` conforms to the DB entity schema via `$ref`. Downstream tools (weaver plugins, judge) follow `$ref` to understand entity boundaries — no custom markup needed.

## Deep Merge Model

When values are merged (via `_parent` inheritance or layer composition):

- **Objects:** Merge recursively. Child values override, parent-only keys preserved.
- **Arrays:** Replace — if the child defines an array, it replaces the parent's entirely.
- **Scalars:** Child value wins.

All layers are preserved in the cache. The merged view shows the deep-merged result, but individual layers can be queried independently.

## Entity Type Definition

An entity type is a directory (typically in a Git repo) with a visible schema at its root:

```
application/
  schema.hery.json         # JSON Schema (the type definition)
  default.hery             # Default values
```

No hidden directories. The schema is the primary artifact — visible and discoverable. hery reads **all** `.hery` files in the directory. One directory = one entity type.

Entity schemas extend the base HERY schema (`amadla.org/entity/hery@v1.0.0`) which defines the five reserved properties. Schemas use `$ref` to compose sub-entity schemas, enabling downstream tools to understand nested entity boundaries.

## URI Resolution

HERY resolves `_type` and `_parent` URIs using a Go-module-inspired algorithm:

- **Known hosts** (github.com, gitlab.com): convention-based — `host/owner/repo` (3 segments) is the repo root, remainder is path within repo
- **Custom domains** (amadla.org): meta tag discovery — hery sends `GET https://host/path?hery-get=1` and reads a `<meta name="hery-import">` tag to find the actual Git repo

Example meta tag:
```html
<meta name="hery-import" content="amadla.org/entity/application git https://github.com/AmadlaOrg/EntityApplication">
```

This enables vanity URIs (`amadla.org/entity/network` → `github.com/AmadlaOrg/EntitySystem/Net`), host migration without breaking references, and can be served as static HTML.

## Storage Layout

### Project level

```
my-project/
  webserver.hery           # Entity instances (committed)
  network.hery             # Entity instances (committed)
  hery.lock                # Lock file (committed)
  .hery.cache              # SQLite cache (gitignored, derived)
```

### Global cache

```
~/.cache/hery/
  entity/                  # Resolved entity types
    amadla.org/entity/application@v1.0.0/
      schema.hery.json
      default.hery
```

Disposable — hery re-fetches from Git when needed.

## Lock Files

`hery.lock` (JSON format) at the project root:

- Same data as `.hery.cache` in a portable format
- Committed to Git for reproducibility
- Faster subsequent merges
- Should **not** be edited manually

## Querying

hery uses a two-stage query model:

1. **Selection** — CLI flags filter which entities are returned (backed by SQLite indexes)
2. **Transformation** — optional jq expressions reshape the output (via gojq, compiled in)

```bash
# All entities
hery query

# Filter by type (glob)
hery query --type 'amadla.org/entity/application@v*'

# Filter by meta tag
hery query --tag production

# Filter + extract fields with jq
hery query --type '*/network@*' --jq '.[].\_body.port'

# Combine with external tools (UNIX pipe)
hery query --type '*/application@*' | doorman inject | weaver render
```

Selection flags (`--type`, `--meta`, `--tag`) hit SQLite indexes for fast filtering. The `--jq` flag applies jq transformations without requiring jq to be installed. Users can also pipe to external `jq` directly.

Results are always JSON, designed for piping to downstream tools. All layers are preserved in the cache — use `--layers` to inspect individual layers before merge.

## Entity Versioning

Entities are versioned via Git tags. The type URI includes the version:

```
amadla.org/entity/application@v1.0.0
amadla.org/entity/application@latest
```

hery resolves `@latest` to the most recent Git tag. Version pinning ensures reproducible deployments.
