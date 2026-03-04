# Current State

Full inventory of every repository in the Amadla ecosystem as of February 2026.

## Summary

| Category | Total | Active | Partial | Early | Stub/Planned |
|----------|-------|--------|---------|-------|--------------|
| Core Tools | 8 | 0 | 2 | 1 | 5 |
| Libraries | 5 | 5 | 0 | 0 | 0 |
| Clerk Plugins | 16 | 1 | 0 | 0 | 15 |
| Auditor Plugins | 3 | 1 | 0 | 0 | 2 |
| Weaver Plugins | 4 | 0 | 0 | 0 | 4 |
| Entity Definitions | 8 | 8 | 0 | 0 | 0 |
| Other | 8 | 4 | 0 | 0 | 4 |
| **Total** | **52** | **19** | **2** | **1** | **30** |

## Go Projects (with go.mod)

These 11 repositories contain actual Go code:

| Repo | Module | Go Version | Status | Has CLAUDE.md |
|------|--------|------------|--------|---------------|
| LibraryUtils | `github.com/AmadlaOrg/LibraryUtils` | 1.24.0 | Active | Yes |
| LibraryFramework | `github.com/AmadlaOrg/LibraryFramework` | 1.24.0 | Active | No |
| LibraryPluginFramework | `github.com/AmadlaOrg/LibraryPluginFramework` | 1.24.0 | Active | No |
| LibraryClerkFramework | `github.com/AmadlaOrg/LibraryClerkFramework` | 1.24.0 | Active | No |
| LibraryAuditFramework | `github.com/AmadlaOrg/LibraryAuditFramework` | 1.24.0 | Active | No |
| hery | `github.com/AmadlaOrg/hery` | 1.24.0 | Partial | Yes |
| doorman | `github.com/AmadlaOrg/doorman` | 1.24.0 | Early | Yes |
| weaver | `github.com/AmadlaOrg/weaver` | 1.24.0 | Partial | No |
| hery-playground | `github.com/AmadlaOrg/hery-playground` | 1.24.0 | Active | No |
| auditor-application | `github.com/AmadlaOrg/auditor-application` | 1.23.3 | Active | No |
| clerk-keepassxc | `github.com/AmadlaOrg/clerk-keepassxc` | 1.23.5 | Active | No |

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
- **No daemon mode** yet (start/resolve not implemented)
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

All 8 entity repos contain JSON Schema definitions in `.amadla/schema.json`:

- Entity, EntityApplication, EntitySystem, EntityInfrastructure
- EntityProgrammingLanguage, EntityContainer, EntitySecret, EntityJudge

## Plugin Stubs

41 repositories are non-Go (no go.mod) — primarily:

- 15 clerk plugin stubs (README-only or minimal Makefile)
- 2 auditor plugin stubs
- 4 weaver plugin stubs
- 8 entity definition repos (JSON Schema, not Go)
- Editor plugins, templates, CI/CD workflows

## Other Repositories

| Repo | Type | Status |
|------|------|--------|
| `common-json-schemas` | JSON Schema definitions | Active |
| `hery-playground` | Web app (Gin) | Active |
| `hery-jetbrains-editor-plugin` | IDE plugin | Stub |
| `hery-code-editor-plugin` | VS Code extension | Stub |
| `template-application-golang` | Go project template | Active |
| `GitHub-Actions` | CI/CD workflows | Active |
| `AmadlaOrg.github.io` | GitHub Pages | Minimal |
