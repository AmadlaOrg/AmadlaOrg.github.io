---
description: Definitions of Amadla-specific terminology — HERY, entities, tools, plugins, and infrastructure automation concepts.
---

# Glossary

Amadla-specific terminology and concepts.

## A

### amadla (tool)
The Amadla orchestrator CLI. Reads `.hery` entity files, builds a dependency graph (DAG) from `_requires` declarations, and executes registered tools in topologically sorted order with parallel execution of independent tiers. Written in Go but replaceable — the entities and tools are the portable parts.

### Judge Plugin
A plugin for the **judge** tool that checks whether a system's actual state matches entity requirements. Examples: judge-application, judge-system, judge-infrastructure.

## B

### Body (`_body`)
One of [HERY](../architecture/hery-concepts.md)'s five reserved YAML properties. Contains the actual entity data. Validated against the entity's JSON Schema. Optional — when omitted, defaults are inherited from `_extends` or the entity definition.

## C

### conduct
The Amadla multi-server orchestrator. Coordinates waiter/lay across distributed nodes. Handles role-based placement, replica management, and failover. Like a conductor — each server plays a different part.

## D

### Deep Merge
HERY's merge strategy: objects merge recursively (child overrides, parent-only keys preserved), arrays replace entirely, scalars use child value. Applied during `_extends` inheritance and layer composition to `_body`, `_meta`, and `_requires`.

### doorman
The Amadla secrets management CLI tool. Resolves secrets from Doorman plugins on demand via the `resolve` command.

### dryrun
A tool that safely tests settings by applying them and automatically reverting if something goes wrong (e.g., prevents SSH lockout). Currently written in Python, may move to Go.

## E

### Entity Type
A versioned schema defining a category of configuration. Analogous to a table schema. Identified by a type URI (e.g., `amadla.org/entity/application@v1.0.0`) where the version maps directly to a Git tag. Lives in a Git repo as `schema.hery.json` + default `.hery` files.

### Entity Instance
A specific `.hery` document with actual data. Analogous to a row.

### Entity Composition
The technique of nesting entity data via JSON Schema `$ref`. The schema declares which parts of `_body` correspond to other entity types. No HERY-specific markup is needed inside `_body`.

## G

### garbage
The Amadla trash/uninstall tool. Tracks and removes what's no longer needed. Commands: rm, list, restore, empty, info, settings, binary, package.

## H

### HERY
Hierarchical Entity Relational YAML. The data model and storage system at the core of the Amadla ecosystem. Extends YAML with five reserved properties (`_type`, `_extends`, `_meta`, `_body`, `_requires`) for entity management with schema validation, dependency ordering, and Git-based versioning.

### hery (tool)
The CLI tool that manages HERY data: entity operations, querying, and composition. Deep-merges entities by directory path, generates `.lock` files, caches in SQLite.

## I

### Idiomatic Go Naming
Amadla uses idiomatic Go naming: no `I` prefix on interfaces, no `S` prefix on structs. Interfaces use descriptive names (`Storage`, `Cache`, `Validator`), structs are unexported (`service`, `cacheImpl`).

## J

### judge
The Amadla validation tool. Checks that requirements across merged entities are satisfied, detects cross-entity conflicts (e.g., port collisions), and compares actual system state (via unravel) against entity declarations for drift detection.

## L

### lay
The Amadla package/application installer. Installs packages, applications, JARs, and container images (pull/build). For containers, lay handles build/pull; waiter handles deployment.

### lighthouse
The Amadla notification/alerting tool. Sends notifications via plugins (webhook, WebRTC, Twilio SMS, AWS SES, REST API). Receives entity output from any tool via UNIX pipe.

### Lock file (`hery.lock`)
A JSON file at the project root containing the merge state. Same data as the SQLite cache (`.hery.cache`) but in a portable format. Committed to Git for reproducibility. Should not be edited manually.

## M

### Merge discriminator
The entity's directory path (derived from its git repo position) determines merge behavior: same path = override (deep merge, last-writer-wins), different path = accumulate (new entry).

### Meta (`_meta`)
One of HERY's five reserved YAML properties. Contains metadata for filtering and search. Structure defined by the entity's schema. Optional.

### Meta tag resolution
URI resolution mechanism for custom domains. hery sends `GET https://host/path?hery-get=1` and reads a `<meta name="hery-import">` tag to discover the actual Git repo. Enables vanity URIs and host migration.

## N

### New()
Constructor pattern used across all Amadla Go code. `New()` returns an interface type when there is one primary type per package, enabling dependency injection.

## P

### Extends (`_extends`)
One of HERY's five reserved YAML properties. A URI pointing to another entity instance of the same type. Purely a data/merge operation — no execution ordering implied. The extended entity's `_body`, `_meta`, and `_requires` are deep-merged as defaults — the child only specifies overrides. `_type` is never merged. Targets specific elements via filename path segment (e.g., `github.com/SomeOrg/WordPress/database.hery`). Extends chains can cascade transitively. Cycles are detected and rejected.

## R

### raise
The Amadla infrastructure provisioner. Provisions cloud resources from entities using a plugin system for different cloud service APIs.

### Replace Directive
Go module `replace` directive in `go.mod` that points to a sibling directory for local development (e.g., `replace github.com/AmadlaOrg/LibraryUtils => ../LibraryUtils`).

## S

## R

### Requires (`_requires`)
One of HERY's five reserved YAML properties. Declares hard dependencies on other entities for execution ordering. amadla builds a DAG from `_requires` declarations and topologically sorts. Supports three reference forms: local file paths (`./file.hery`), external file paths with version (`github.com/org/repo/file.hery@v1.0.0`), and type URIs (`amadla.org/entity/type@v1.0.0`). Orthogonal to `_extends` (which handles data merge, not ordering).

## T

### Type (`_type`)
One of HERY's five reserved YAML properties (the only required one). A URI declaring the entity's schema/type and version (e.g., `amadla.org/entity/Network@v1.0.0`). Determines which JSON Schema validates the document. When used with `_extends`, `_type` declares the schema while `_extends` declares data inheritance — both can be present simultaneously.

## U

### unravel
The Amadla discovery tool. Wraps osquery (on-demand, stateless) + custom plugins to discover existing system state and output it as entities. No caching — follows UNIX philosophy. Combined with judge for drift detection (`unravel discover | judge audit`).

## W

### waiter
The Amadla deployment tool. Manages deployment strategies (blue-green, canary, rolling) with platform plugins (waiter-podman, waiter-docker, waiter-systemd). Consumes image refs from lay and config files from weaver.

### weaver
The Amadla template/config generator. Renders configuration files (Quadlet, nginx.conf, podman-compose, k8s, CI/CD, or any text file) using HERY entities and pluggable template engines (Jinja, Mustache, Handlebars, Qute). ETL-like: transforms entity data into any text output.

### Weaver Plugin
A template engine plugin for the weaver tool. Each provides a different rendering engine.

## Symbols

### `_type`
HERY reserved property (required): the schema/type URI with version. Determines validation and entity type. Can be inherited from `_extends` when not explicitly set.

### `_extends`
HERY reserved property (optional): URI to another instance of the same type. Enables deep merge inheritance of `_body`, `_meta`, and `_requires`. Purely a data/merge operation — does not imply execution ordering. Targets specific elements via filename path segment.

### `_meta`
HERY reserved property (optional): metadata for filtering and search.

### `_body`
HERY reserved property (optional): the actual entity data content. Validated against the entity's JSON Schema.

### `_requires`
HERY reserved property (optional): declares hard dependencies on other entities. Used by amadla to build a DAG and determine execution order. Three forms: local file path (`./file.hery`), external file path (`github.com/org/repo/file.hery@v1.0.0`), type URI (`amadla.org/entity/type@v1.0.0`).
