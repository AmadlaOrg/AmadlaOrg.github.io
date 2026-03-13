---
hide:
  - navigation
  - toc
---

<div class="amadla-hero" markdown>

![Amadla Logo](assets/logo.svg)

# Amadla

<p class="amadla-tagline">Application-centric infrastructure automation</p>

<div class="amadla-links" markdown>
[Get Started](vision/philosophy.md){ .primary }
[View on GitHub](https://github.com/AmadlaOrg){ .secondary }
</div>

</div>

---

## What is Amadla?

**Amadla** is an infrastructure automation ecosystem built on the UNIX philosophy. Instead of describing environments, you describe what your applications *need* — and those requirements flow through a pipeline of modular CLI tools that each do one thing well.

<div class="amadla-features" markdown>

<div class="amadla-feature" markdown>

### Application-Centric

Define what an application requires — dependencies, secrets, configuration — and let the tools figure out how to provision it.

</div>

<div class="amadla-feature" markdown>

### UNIX Philosophy

Small, composable CLI tools that pipe JSON between each other. Use them independently or chain them in a pipeline.

</div>

<div class="amadla-feature" markdown>

### HERY Data Model

Hierarchical Entity Relational YAML — a structured way to define application requirements with schema validation and Git versioning.

</div>

<div class="amadla-feature" markdown>

### Plugin Architecture

Extend tools with plugins for secret sources (Clerks), template engines (Weavers), and compliance auditing (Auditors).

</div>

<div class="amadla-feature" markdown>

### Secrets Management

Doorman daemon resolves secrets from any source — Vault, AWS, KeePassXC, Keycloak — via encrypted in-memory cache.

</div>

<div class="amadla-feature" markdown>

### Template Generation

Weaver generates configuration files using pluggable template engines: Jinja, Mustache, Handlebars, and Qute.

</div>

</div>

## The Pipeline

Each tool reads structured data, does its job, and passes results downstream as JSON.

<div class="amadla-pipeline" markdown>

`hery` &rarr; `doorman` &rarr; `raise` &rarr; `lay` &rarr; `weaver` &rarr; `judge`

</div>

| Stage | Tool | What it does |
|-------|------|-------------|
| **Define** | [hery](tools/hery.md) | Manage YAML entities with schema validation and SQLite caching |
| **Secrets** | [doorman](tools/doorman.md) | Resolve secrets from any source via Doorman plugins |
| **Provision** | [raise](tools/raise.md) | Provision infrastructure using IaC wrappers |
| **Install** | [lay](tools/lay.md) | Install applications via package managers |
| **Configure** | [weaver](tools/weaver.md) | Generate config files from templates + entity data |
| **Audit** | [judge](tools/judge.md) | Verify compliance via Judge plugins |

## Ecosystem at a Glance

| Category | Count | Examples |
|----------|-------|---------|
| **Core Tools** | 8 | hery, doorman, weaver, judge, lay, raise, waiter, unravel |
| **Libraries** | 5 | LibraryUtils, LibraryFramework, LibraryPluginFramework, ... |
| **Doorman Plugins** | 16 | doorman-vault, doorman-aws, doorman-keepassxc, doorman-keycloak, ... |
| **Judge Plugins** | 3 | judge-application, judge-system, judge-infrastructure |
| **Weaver Plugins** | 4 | weaver-jinja, weaver-js-handlebars, weaver-js-mustache, weaver-qute |
| **Entity Definitions** | 8 | Entity, EntityApplication, EntitySystem, EntityInfrastructure, ... |

**Total: 52+ repositories** across [AmadlaOrg](https://github.com/AmadlaOrg) and AmadlaCom.

## Technology

All tools and libraries are written in **Go**. The ecosystem uses:

| Concern | Technology |
|---------|-----------|
| Language | Go 1.24+ |
| CLI Framework | Cobra (wrapped by LibraryFramework) |
| Data Storage | YAML + SQLite caching (HERY) |
| Schema Validation | JSON Schema |
| Entity Versioning | Git |
| Secrets | Encrypted in-memory cache (Doorman) |
| Template Engines | Jinja, Mustache, Handlebars, Qute (via plugins) |

<div class="amadla-links" markdown>
[Architecture](architecture/ecosystem-overview.md){ .secondary }
[Tools](tools/overview.md){ .secondary }
[Roadmap](roadmap/current-state.md){ .secondary }
</div>
