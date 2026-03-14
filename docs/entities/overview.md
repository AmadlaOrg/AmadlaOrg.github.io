# Entities Overview

Entities are the core data model of the Amadla ecosystem. Each entity type defines a **schema** for a specific kind of requirement — applications, systems, infrastructure, secrets, etc.

## What Are Entities?

In Amadla, an entity is a versioned, schema-validated YAML document that describes a requirement. Instead of writing imperative scripts ("install nginx, configure it like this"), you write declarative entities ("this application needs nginx >=1.24 with TLS").

Entity definitions live in the `Entities/` directory structure, each with a `schema.hery.json` at its root:

```
Entities/
├── Application/          # + DB/, DB/RDBMS/, IAM/, WebServer/
├── Certificate/
├── Container/
├── Cron/
├── Firewall/
├── Infrastructure/       # + Cloud/, Container/, VM/
├── Judge/
├── Package/
├── ProgrammingLanguage/  # + PHP/
├── Secret/
├── Service/
├── System/               # + CPU/, Memory/, Net/, Storage/
├── Template/
├── Tools/
└── User/
```

## Entity Types

### Top-level types

| Entity | Describes | Used By |
|--------|-----------|---------|
| [Application](entity-application.md) | Application requirements (packages, services, healthchecks) | lay, waiter, judge |
| [Certificate](entity-certificate.md) | TLS/SSL certificates (ACME, self-signed, manual) | lay, doorman |
| [Container](entity-container.md) | Container/image definitions (Docker Compose-inspired) | lay, waiter |
| [Cron](entity-cron.md) | Scheduled tasks (cron expressions, systemd timers) | lay |
| [Firewall](entity-firewall.md) | Firewall rules (iptables, nftables, ufw, firewalld) | lay, judge |
| [Infrastructure](entity-infrastructure.md) | Infrastructure requirements (provider, region, SSH) | raise |
| [Judge](entity-judge.md) | Audit/validation rule definitions | judge |
| [Package](entity-package.md) | System package installation (apt, yum, dnf, pacman, brew) | lay, garbage |
| [ProgrammingLanguage](entity-programming-language.md) | Language runtime requirements | lay |
| [Secret](entity-secret.md) | Secret references and metadata | doorman |
| [Service](entity-service.md) | Systemd service configuration | lay, weaver |
| [System](entity-system.md) | System requirements (OS, kernel, resources) | lay, judge |
| [Template](entity-template.md) | Template configuration (engine, path, output) | weaver |
| [Tools](entity-tools.md) | Tool inventory and discovery configuration | amadla |
| [User](entity-user.md) | System users and groups | lay, doorman |

### Sub-types

| Entity | Parent | Describes | Used By |
|--------|--------|-----------|---------|
| [Application/DB](entity-application-db.md) | Application | Database engine, auth, databases to create | lay, doorman |
| [Application/DB/RDBMS](entity-application-db-rdbms.md) | Application/DB | Migrations, replication, backup, connection pooling | lay, weaver |
| [Application/IAM](entity-application-iam.md) | Application | Identity providers, OAuth2/OIDC clients, users | lay, doorman |
| [Application/WebServer](entity-application-webserver.md) | Application | Virtual hosts, locations, SSL, proxying | lay, weaver |
| [Infrastructure/Cloud](entity-infrastructure-cloud.md) | Infrastructure | Cloud instances (AWS, Hetzner, DigitalOcean) | raise |
| [Infrastructure/Container](entity-infrastructure-container.md) | Infrastructure | Container runtime setup, registry access | raise, lay |
| [Infrastructure/VM](entity-infrastructure-vm.md) | Infrastructure | Virtual machines (libvirt, VirtualBox, VMware) | raise |
| [ProgrammingLanguage/PHP](entity-programming-language-php.md) | ProgrammingLanguage | PHP extensions, php.ini, FPM pools, Composer | lay, weaver |
| [System/CPU](entity-system-cpu.md) | System | CPU resource constraints | lay, raise |
| [System/Memory](entity-system-memory.md) | System | Memory resource constraints | lay, raise |
| [System/Net](entity-system-net.md) | System | Network configuration (IPAM, ports, DNS) | lay, raise |
| [System/Storage](entity-system-storage.md) | System | Volumes, mounts, tmpfs | lay, raise |

## How Entities Connect

Entities compose via JSON Schema `$ref`. The schema declares which parts of `_body` correspond to other entity types. No [HERY](../architecture/hery-concepts.md)-specific markup is needed inside `_body` — composition is handled at the schema level.

Entities declare dependencies using `_requires` — the 5th reserved HERY property (Draft 3.5). amadla builds a dependency graph (DAG) from `_requires` declarations and topologically sorts to determine execution order.

```
EntityApplication (my-web-app)
├── _requires:
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
