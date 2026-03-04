# Entities Overview

Entities are the core data model of the Amadla ecosystem. Each entity type defines a **schema** for a specific kind of requirement — applications, systems, infrastructure, secrets, etc.

## What Are Entities?

In Amadla, an entity is a versioned, schema-validated YAML document that describes a requirement. Instead of writing imperative scripts ("install nginx, configure it like this"), you write declarative entities ("this application needs nginx >=1.24 with TLS").

Entity definitions live in dedicated repositories under `github.com/AmadlaOrg/Entity*`. Each repository contains:

```
Entity{Name}/
├── amadla.yml          # Entity metadata
└── .amadla/
    ├── schema.json     # JSON Schema for _body validation
    └── tests/          # Test data for schema validation
```

## Entity Types

| Entity | Repo | Describes | Used By |
|--------|------|-----------|---------|
| [Entity](entity-application.md) | `Entity` | Base entity schema — common reserved properties | All tools |
| [EntityApplication](entity-application.md) | `EntityApplication` | Application requirements (packages, services) | lay, auditor-application |
| [EntitySystem](entity-system.md) | `EntitySystem` | System requirements (OS, kernel, resources) | lay, auditor-system |
| [EntityInfrastructure](entity-infrastructure.md) | `EntityInfrastructure` | Infrastructure requirements (servers, networks) | raise, auditor-infrastructure |
| [EntityProgrammingLanguage](entity-programming-language.md) | `EntityProgrammingLanguage` | Programming language runtime requirements | lay |
| [EntityContainer](entity-container.md) | `EntityContainer` | Container/image definitions | raise |
| [EntitySecret](entity-secret.md) | `EntitySecret` | Secret references and metadata | doorman |
| [EntityJudge](entity-judge.md) | `EntityJudge` | Audit rule definitions | judge |

## How Entities Connect

Entities reference each other via the `_id` property, forming a dependency graph:

```
EntityApplication
├── _id: EntitySystem          (what OS/packages does this app need?)
├── _id: EntitySecret          (what secrets does this app need?)
├── _id: EntityInfrastructure  (what servers does this app need?)
└── _id: EntityContainer       (what container image to use?)
```

This graph is what makes Amadla **application-centric**: the application entity is the root, and all other requirements flow from it.

## Schema Validation

Every entity's `_body` is validated against a JSON Schema defined in the entity's repository. This ensures:

- Consistent data structure across all instances
- Early detection of configuration errors
- Machine-readable requirement definitions

The schemas are stored in `common-json-schemas` and referenced by each entity repo.
