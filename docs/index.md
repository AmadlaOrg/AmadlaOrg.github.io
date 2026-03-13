# Amadla Ecosystem

Amadla is an infrastructure automation ecosystem that simplifies provisioning of cloud and on-premise servers. Built on the **UNIX philosophy**, it consists of modular CLI tools that pipe JSON output between each other, each doing one thing well.

!!! info "Core Differentiator"
    Amadla is **resource-centric**: instead of defining environments (like Terraform or Ansible), each resource (application, service, database) carries its own schema-validated configuration. Requirements are declared explicitly — not buried in documentation — and enforced by schemas. Layers compose and merge, giving a single queryable source of truth.

## The Pipeline

![Amadla Ecosystem Context](diagrams/out/c1-ecosystem-context.svg)

Each tool in the pipeline reads structured data, does its job, and passes results downstream as JSON.

```
Define requirements (hery) → Resolve secrets (doorman) → Provision infra (raise)
    → Install apps (lay) → Generate configs (weaver) → Audit state (judge)
```

## Ecosystem at a Glance

| Category | Count | Examples |
|----------|-------|---------|
| **Core Tools** | 10 | hery, doorman, weaver, judge, lay, raise, waiter, unravel, dryrun, garbage |
| **Libraries** | 5 | LibraryUtils, LibraryFramework, LibraryPluginFramework, LibraryDoormanFramework, LibraryJudgeFramework |
| **Doorman Plugins** | 16 | doorman-vault, doorman-aws, doorman-keepassxc, doorman-keycloak, ... |
| **Judge Plugins** | 3 | judge-application, judge-system, judge-infrastructure |
| **Weaver Plugins** | 4 | weaver-jinja, weaver-js-handlebars, weaver-js-mustache, weaver-qute |
| **Entity Definitions** | 8 | Entity, EntityApplication, EntitySystem, EntityInfrastructure, ... |
| **Other** | 8+ | common-json-schemas, hery-playground, editor plugins, templates, CI/CD |

**Total: 52+ repositories** across [AmadlaOrg](https://github.com/AmadlaOrg) (public) and [AmadlaCom](https://github.com/AmadlaCom) (private).

## Sections

- [Vision & Philosophy](vision/philosophy.md) — Application-centric approach, UNIX philosophy, pipeline model
- [Architecture](architecture/ecosystem-overview.md) — Component map, data pipeline, HERY data model, plugin system
- [Tools](tools/overview.md) — Tool canvases for every CLI tool
- [Libraries](libraries/overview.md) — Shared Go libraries and dependency graph
- [Plugins](plugins/overview.md) — Doorman, judge, and weaver plugins
- [Entities](entities/overview.md) — HERY entity definitions and schemas
- [Standards](standards/go-conventions.md) — Go conventions, testing, project structure, CLI patterns
- [Roadmap](roadmap/current-state.md) — Current state, gaps, development plan, dependency graph
- [Glossary](glossary/glossary.md) — Amadla-specific terminology

## Key Technologies

HERY is **YAML-based**, entities are validated against **JSON Schema**, and versioning requires **Git**.
