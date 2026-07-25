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

[Read the longer introduction](what-is-amadla.md) for the ideas behind it, the full pipeline, and the ecosystem at a glance.

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

Extend tools with plugins for secret sources (doorman-*), infrastructure providers (raise-*), template engines (weaver-*), system configuration (enjoin-*), and validation (judge-*).

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

`hery` &rarr; `doorman` &rarr; `raise` &rarr; `lay` &rarr; `enjoin` &rarr; `weaver` &rarr; `judge`

</div>

| Stage | Tool | What it does |
|-------|------|-------------|
| **Define** | [hery](tools/hery.md) | Manage YAML entities with schema validation and SQLite caching |
| **Secrets** | [doorman](tools/doorman.md) | Resolve secrets from any source via doorman plugins |
| **Provision** | [raise](tools/raise.md) | Provision VMs and cloud instances via raise plugins |
| **Install** | [lay](tools/lay.md) | Install packages, applications, and language runtimes |
| **Configure** | [enjoin](tools/enjoin.md) | Set system state — users, services, cron, security |
| **Generate** | [weaver](tools/weaver.md) | Generate config files from templates + entity data |
| **Audit** | [judge](tools/judge.md) | Verify state and compliance via judge plugins |

<div class="amadla-links" markdown>
[What is Amadla?](what-is-amadla.md){ .secondary }
[Architecture](architecture/ecosystem-overview.md){ .secondary }
[Tools](tools/overview.md){ .secondary }
[Roadmap](roadmap/current-state.md){ .secondary }
</div>
