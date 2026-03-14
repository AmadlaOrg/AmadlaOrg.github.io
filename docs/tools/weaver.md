# weaver

| Field | Value |
|-------|-------|
| **Purpose** | Template generator — renders configuration files using [HERY](../architecture/hery-concepts.md) entities and pluggable template engines |
| **Repo** | [AmadlaOrg/weaver](https://github.com/AmadlaOrg/weaver) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `weaver weave` | Partial | Render templates with entity data |
| `weaver settings` | Working | Manage weaver configuration |
| `weaver version` | Working | Show version information |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |

## Pipeline Position

weaver sits **near the end** of the pipeline, after infrastructure is provisioned and applications installed. It generates configuration files from templates filled with entity data.

```
hery → doorman → raise → lay → [weaver] → judge
                                   │
                          ┌────────┴─────────┐
                          │ Weaver Plugins   │
                          │ (jinja, mustache,│
                          │  handlebars,     │
                          │  qute)           │
                          └──────────────────┘
```

## Architecture

### Package Structure

```
cmd/
├── weave.go            # Weave command — template rendering
├── weave_test.go       # Tests for weave command
├── template.go         # Template handling logic
└── settings.go         # Settings command
```

### Template Engines

weaver supports multiple template engines via plugins:

| Plugin | Engine | Language |
|--------|--------|----------|
| weaver-jinja | Jinja2 | Python |
| weaver-js-handlebars | Handlebars | JavaScript |
| weaver-js-mustache | Mustache | JavaScript |
| weaver-qute | Qute | Java |

### Template Entity

Weaver routing is **template-driven**, not plugin-driven. A Template entity (`.hery` file alongside the template) tells weaver which engine to use and what entities the template supports:

```yaml
_type: amadla.org/entity/template@v1.0.0
_body:
  engine: jinja                          # which weaver-* plugin to invoke
  path: ./templates/nginx.conf.j2        # relative path from entity location
  output: /etc/nginx/conf.d/myapp.conf   # where rendered file goes (absolute or relative)
  supports:                              # which entity types this template can render
    - amadla.org/entity/application@^v1.0.0
    - amadla.org/entity/infrastructure@^v1.0.0
```

Weaver queries hery for template entities, matches against the input entity type, resolves the template path, and invokes the right `weaver-*` plugin. Multiple templates can match the same entity type — weaver renders all of them, each producing its own output file.

The `output` field can be absolute (`/etc/nginx/conf.d/myapp.conf`) or relative (`./output/nginx.conf`). Downstream tools (lay, waiter) can move files if needed.

## Current Gaps

- `weave` command has TODO items and commented-out validation code
- Template plugin loading not fully implemented
- No direct integration with HERY entity queries yet
- Limited test coverage
- Template validation has gaps
- Template entity type (`amadla.org/entity/template@v1.0.0`) schema not yet defined

## Key Files

| Path | Purpose |
|------|---------|
| `cmd/weave.go` | Weave command implementation |
| `cmd/template.go` | Template handling and rendering |
| `cmd/settings.go` | Settings command |
