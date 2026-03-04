# Glossary

Amadla-specific terminology and concepts.

## A

### Auditor
A plugin for the **judge** tool that checks whether a system's actual state matches entity requirements. Examples: auditor-application, auditor-system, auditor-infrastructure.

## B

### Body (`_body`)
One of HERY's four reserved YAML properties. Contains the actual entity data, similar to HTML `<body>`. Validated against the entity's JSON Schema.

## C

### Clerk
A plugin for **doorman** that integrates with a specific secret store (Vault, AWS, KeePassXC, etc.). Named after a hotel desk clerk who handles keys.

### Collection
A group of related HERY entities, analogous to a database in RDBMS. A collection typically represents a project or environment's full stack definition.

## D

### doorman
The Amadla secrets management daemon. Pulls secrets from Clerk plugins and stores them in an encrypted in-memory cache with TTL.

## E

### Entity
A versioned, schema-validated YAML document that describes a requirement. Analogous to a table in RDBMS. Identified by a URI with version (e.g., `github.com/AmadlaOrg/EntityApplication@v1.0.0`).

### Entity Content
A specific instance of an entity with actual data. Analogous to a row in RDBMS.

### Entity URI
The unique identifier for an entity type, including version: `github.com/AmadlaOrg/{EntityName}@{version}`.

## H

### HERY
Hierarchical Entity Relational YAML. The data model and storage system at the core of the Amadla ecosystem. Extends YAML with four reserved properties (`_meta`, `_entity`, `_id`, `_body`) for entity management with schema validation and Git-based versioning.

### hery (tool)
The CLI tool that manages HERY data: entity operations, collection management, querying, and composition.

## I

### I-prefix
Naming convention for interfaces in Amadla Go code (e.g., `IGit`, `IFile`, `ICache`).

## J

### judge
The Amadla auditing orchestrator. Runs auditor plugins against entity requirements to produce compliance reports.

## L

### lay
The Amadla package/application installer. Installs software based on entity requirements.

## M

### Meta (`_meta`)
One of HERY's four reserved YAML properties. Contains metadata about the entity instance, similar to HTML `<meta>`.

## N

### New*Service()
Constructor pattern used across all Amadla Go code. Functions like `NewGitService()` return interface types, enabling dependency injection.

## R

### raise
The Amadla infrastructure provisioner. Provisions servers and resources based on entity requirements.

### Replace Directive
Go module `replace` directive in `go.mod` that points to a sibling directory for local development (e.g., `replace github.com/AmadlaOrg/LibraryUtils => ../LibraryUtils`).

## S

### S-prefix
Naming convention for implementation structs in Amadla Go code (e.g., `SGit`, `SFile`, `SCache`).

## U

### unravel
The Amadla debugging/inspection tool for examining pipeline state and data flow.

## W

### waiter
The Amadla pipeline orchestrator. Sequences tool execution across the full pipeline.

### weaver
The Amadla template generator. Renders configuration files using HERY entities and pluggable template engines (Jinja, Mustache, Handlebars, Qute).

### Weaver Plugin
A template engine plugin for the weaver tool. Each provides a different rendering engine.

## Symbols

### `_entity`
HERY reserved property: the entity URI with version. Identifies what schema this content conforms to.

### `_id`
HERY reserved property: references to other entities, functioning like foreign keys in RDBMS.

### `_meta`
HERY reserved property: metadata about the entity instance.

### `_body`
HERY reserved property: the actual entity data content.
