# weaver

| Field | Value |
|-------|-------|
| **Purpose** | Template generator — renders configuration files using HERY entities and pluggable template engines |
| **Module** | `github.com/AmadlaOrg/weaver` |
| **Status** | Partial |
| **Repo** | [AmadlaOrg/weaver](https://github.com/AmadlaOrg/weaver) |
| **Go Version** | 1.24.0 |

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

### External Dependencies

| Package | Purpose |
|---------|---------|
| `github.com/spf13/cobra` | CLI framework |
| `gopkg.in/yaml.v3` | YAML parsing |
| `github.com/olekukonko/tablewriter` | Formatted table output |

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

## Current Gaps

- `weave` command has TODO items and commented-out validation code
- Template plugin loading not fully implemented
- No direct integration with HERY entity queries yet
- Limited test coverage
- Template validation has gaps

## Key Files

| Path | Purpose |
|------|---------|
| `cmd/weave.go` | Weave command implementation |
| `cmd/template.go` | Template handling and rendering |
| `cmd/settings.go` | Settings command |
