# Best Practices

Recommended conventions for writing HERY entities and building Amadla-compatible tools. These are not enforced by the system — they are good hygiene that makes entities more discoverable, composable, and maintainable.

## `entity_types` Convention

When an entity needs to communicate which entity types it supports, targets, or operates on, use the field name **`entity_types`** in `_body`.

This is not a reserved property — it lives inside `_body` and is schema-defined. But using a consistent name across the ecosystem makes entities easier to understand and query.

### Where It's Used

| Entity | Field | Purpose |
|--------|-------|---------|
| Template | `entity_types` | Which entity types this template can render for |

### Example

```yaml
_type: amadla.org/entity/template@v1.0.0
_body:
  engine: jinja2
  source: ./templates/nginx.conf.j2
  output: /etc/nginx/conf.d/myapp.conf
  entity_types:
    - amadla.org/entity/application@^v1.0.0
    - amadla.org/entity/application/webserver@^v1.0.0
```

### Why Not a Reserved Property?

Reserved properties (`_type`, `_extends`, `_meta`, `_body`, `_requires`) are fixed — they have universal meaning across all entities. `entity_types` is domain-specific: its meaning depends on context (a template "renders for" certain types). Keeping it in `_body` means each schema defines its own semantics.

## Tools Entity: Keep It Minimal

The [Tools entity](../entities/tools.md) only has two properties per tool: `name` and optional `path`. Everything else (what entity types a tool handles, its version, capabilities) comes from calling `<tool> info` at runtime.

```yaml
_type: amadla.org/entity/tools@v1.0.0
_body:
  tools:
    - name: hery
    - name: lay
    - name: enjoin
    - name: weaver
    - name: raise
    - name: doorman
      path: /opt/secrets/bin/doorman
```

Don't put routing, descriptions, or caching config in the tools entity. The tools self-describe via their `info` subcommand — the entity is just a registry of names and locations.

## Tool Input: File Path or Stdin

All Amadla tools must accept entity data via **file path** or **stdin**:

```bash
# File path
weaver render -f ./entities/template.hery

# Stdin (UNIX piping)
cat ./entities/template.hery | weaver render

# Pipeline
hery query --type '*/template@*' -o json | weaver render
```

This is core UNIX philosophy. Tools that only accept one input method break composability.

## Keep Entities Focused

Each entity should describe **one concern**. Don't mix template configuration with package installation with security policies. Separate concerns into separate entities and use `_requires` to declare dependencies between them:

```yaml
# package.hery — what to install
_type: amadla.org/entity/package@v1.0.0
_body:
  packages:
    - nginx

# template.hery — what to render
_type: amadla.org/entity/template@v1.0.0
_requires:
  - amadla.org/entity/package@v1.0.0
_body:
  engine: go
  source: nginx.conf.tmpl
  output: /etc/nginx/nginx.conf
```

## Exit Codes

Tools should exit with standard UNIX codes:

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Failure (tool-specific error) |
| `2` | Usage error (bad arguments, missing required flags) |

The orchestrator (amadla) reads exit codes to determine pipeline flow. Don't use custom exit codes beyond these three.

## Data Flow: stdout for Data, stderr for Diagnostics

- **stdout** — structured output (JSON, YAML, rendered content)
- **stderr** — logs, warnings, progress messages, errors

This allows tools to be piped without diagnostic messages corrupting the data stream.
