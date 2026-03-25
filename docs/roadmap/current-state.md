# Current State

Full inventory of every repository in the Amadla ecosystem as of March 2026.

## Summary

| Category | Total | Active | Partial | Early | Stub/Planned |
|----------|-------|--------|---------|-------|--------------|
| Core Tools | 8 | 0 | 2 | 1 | 5 |
| Libraries | 5 | 5 | 0 | 0 | 0 |
| Doorman Plugins | 16 | 1 | 0 | 0 | 15 |
| Judge Plugins | 3 | 1 | 0 | 0 | 2 |
| Weaver Plugins | 4 | 0 | 0 | 0 | 4 |
| Entity Definitions | 8 | 8 | 0 | 0 | 0 |
| Other | 8 | 4 | 0 | 0 | 4 |
| **Total** | **52** | **19** | **2** | **1** | **30** |

## Core Tools Detail

### hery (Partial)

- **Commands:** entity (get, list, validate), collection (init, list), query, compose, settings
- **All commands registered** but many have incomplete implementations
- **34 files** with TODO comments
- **Testing:** BDD with Ginkgo v2 + Gomega
- **Estimated remaining work:** ~70 hours across parsers, schema, database, caching, query, docs
- **Dependencies:** LibraryUtils, LibraryFramework

### doorman (Early)

- **Commands:** Only `settings` is functional
- **`collection` and `compose`** are commented out in source
- **`resolve` command** not yet implemented (core secret resolution via plugins)
- **Cache encryption** uses XOR placeholder (needs AES-GCM + TPM)
- **Dependencies:** LibraryUtils, LibraryFramework, Ristretto

### weaver (Partial)

- **Commands:** weave (partial), settings (working), version (working)
- **Template plugin loading** not fully implemented
- **TODO items** in weave.go and fs.go
- **Dependencies:** LibraryUtils

### judge, lay, raise, waiter, unravel (Planned)

- Repositories exist with minimal content (READMEs, some with Makefiles)
- No Go modules or code

## Entity Definitions

All entity types contain JSON Schema definitions in `schema.hery.json` at the entity type directory root:

- Entity, Application, System, Infrastructure
- ProgrammingLanguage, Container, Secret, Judge
- Template, Entities/Tools (27 schemas total across 15 top-level types and 12 sub-types)

## Plugin Stubs

41 repositories are non-Go (no go.mod) — primarily:

- 15 doorman plugin stubs (README-only or minimal Makefile)
- 2 judge plugin stubs
- 4 weaver plugin stubs
- 8 entity definition repos (JSON Schema, not Go)
- Editor plugins, templates, CI/CD workflows

## Other Repositories

| Repo | Type |
|------|------|
| `common-json-schemas` | JSON Schema definitions |
| `hery-playground` | Web app (Gin) |
| `hery-jetbrains-editor-plugin` | IDE plugin |
| `hery-code-editor-plugin` | VS Code extension |
| `template-application-golang` | Go project template |
| `GitHub-Actions` | CI/CD workflows |
| `AmadlaOrg.github.io` | GitHub Pages |
