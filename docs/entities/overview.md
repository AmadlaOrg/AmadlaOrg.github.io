# Entities Overview

Entities are the core data model of the Amadla ecosystem. Each entity type defines a **schema** for a specific kind of requirement — applications, systems, infrastructure, secrets, etc.

## What Are Entities?

In Amadla, an entity is a versioned, schema-validated YAML document that describes a requirement. Instead of writing imperative scripts ("install nginx, configure it like this"), you write declarative entities ("this application needs nginx >=1.24 with TLS").

Entity definitions live in dedicated repositories under `github.com/AmadlaOrg/Entity*`. Each repository contains:

```
Entity{Name}/
├── *.hery                # Entity content files
└── schema.hery.json      # JSON Schema for _body validation
```

## Entity Types

| Entity | Repo | Describes | Used By |
|--------|------|-----------|---------|
| [Entity](entity-application.md) | `Entity` | Base entity schema — common reserved properties | All tools |
| [EntityApplication](entity-application.md) | `EntityApplication` | Application requirements (packages, services) | lay, waiter, judge-application |
| [EntitySystem](entity-system.md) | `EntitySystem` | System requirements (OS, kernel, resources) | lay, judge-system |
| [EntityInfrastructure](entity-infrastructure.md) | `EntityInfrastructure` | Infrastructure requirements (servers, networks) | raise, judge-infrastructure |
| [EntityProgrammingLanguage](entity-programming-language.md) | `EntityProgrammingLanguage` | Programming language runtime requirements | lay |
| [EntityContainer](entity-container.md) | `EntityContainer` | Container/image definitions | lay, waiter |
| [EntitySecret](entity-secret.md) | `EntitySecret` | Secret references and metadata | doorman |
| [EntityJudge](entity-judge.md) | `EntityJudge` | Audit rule definitions | judge |
| [EntityTemplate](entity-template.md) | `EntityTemplate` | Template configuration (engine, path, output, supported entities) | weaver |

## How Entities Connect

Entities compose via JSON Schema `$ref`. The schema declares which parts of `_body` correspond to other entity types. No HERY-specific markup is needed inside `_body` — composition is handled at the schema level.

Entities declare dependencies using `_require` — the 5th reserved HERY property (Draft 3.4). amadla builds a dependency graph (DAG) from `_require` declarations and topologically sorts to determine execution order.

```
EntityApplication (my-web-app)
├── _require:
│   └── github.com/AmadlaOrg/Entities/Application/DB/RDBMS@^v1.0.0
└── _body:
    ├── network (via $ref to Network schema)
    ├── database (via $ref to Database schema)
    ├── secrets (via $ref to Secret schema)
    └── infrastructure (via $ref to Infrastructure schema)
```

The directory path determines merge behavior: same path = override (deep merge, child wins), different path = accumulate (new entry).

Entity identity is derived from the git path (directory position in repo), not declared in the document. One addressable element = one file — multi-document YAML is only for anonymous accumulation.

This graph is what makes Amadla **resource-centric**: each resource declares its own requirements, and those requirements flow outward to inform provisioning, configuration, deployment, and auditing.

## Schema Validation

Every entity's `_body` is validated against a JSON Schema defined in the entity's repository. This ensures:

- Consistent data structure across all instances
- Early detection of configuration errors
- Machine-readable requirement definitions

The schemas are stored in `common-json-schemas` and referenced by each entity repo.

## Entity Development

Entity types are developed alongside tools, driven by quickstart demos:

1. **nginx-hello** — static files, no container (hery, weaver, lay)
2. **nginx-container** — single container (+ waiter, Quadlet)
3. **wordpress-compose** — multi-container (+ doorman, multi-container entities)
4. **wordpress-multi** — two nodes (+ conduct, topology entity)

Each quickstart reveals which entities are actually needed — no speculative entity design.
