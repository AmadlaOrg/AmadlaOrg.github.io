# Data Pipeline

The Amadla pipeline transforms application requirements into running, audited infrastructure. Each tool handles one stage, reading structured data from upstream and emitting JSON for the next stage.

## Pipeline Stages

<!-- Diagram placeholder -->

## Stage Details

### 1. hery — Define Requirements

**Input:** YAML entity files on disk (or in Git repos)
**Output:** Structured entity data as JSON

hery reads YAML files that describe what an application needs. Each file is an **entity** — a versioned, schema-validated document with references to other entities.

```bash
# Query all application entities in a collection
hery query --collection my-stack "EntityApplication"

# Get a specific entity
hery entity get --collection my-stack "github.com/AmadlaOrg/EntityApplication@v1.0.0"
```

Entities are cached in SQLite for fast querying. The source of truth remains the YAML files (optionally version-controlled via Git).

### 2. doorman — Resolve Secrets

**Input:** Entity data containing secret references
**Output:** Entity data with secrets resolved to actual values

doorman is a daemon that pulls secrets from various backends (Vault, AWS, KeePassXC, etc.) via **Clerk plugins**. Resolved secrets are held in an encrypted in-memory cache with TTL.

```bash
# Start the doorman daemon
doorman start

# Secrets are resolved via IPC when downstream tools request them
```

The cache uses platform-specific encryption:

- **Linux:** TPM-backed encryption (planned; currently AES-GCM)
- **Windows:** DPAPI

### 3. raise — Provision Infrastructure

**Input:** Infrastructure entity requirements
**Output:** Provisioned servers, networks, storage

raise reads `EntityInfrastructure` declarations and provisions the required resources. It wraps infrastructure-as-code tools (OpenTofu/Terraform) with Amadla's application-centric model.

!!! note "Planned"
    raise is not yet implemented. This describes the intended design.

### 4. lay — Install Applications

**Input:** Application and system entity requirements
**Output:** Installed packages and services

lay reads `EntityApplication` and `EntitySystem` declarations and installs the required software. It wraps package managers (apt, yum, brew) and configuration management tools (Ansible) with entity-driven requirements.

!!! note "Planned"
    lay is not yet implemented. This describes the intended design.

### 5. weaver — Generate Configuration

**Input:** Templates + entity data (with resolved secrets)
**Output:** Rendered configuration files

weaver takes template files and fills them with data from HERY entities. It supports multiple template engines via **Weaver plugins** (Jinja, Mustache, Handlebars, Qute).

```bash
# Render a template using entity data
weaver weave --template nginx.conf.j2 --collection my-stack
```

### 6. judge — Audit Compliance

**Input:** Expected state from entity requirements
**Output:** Compliance report (pass/fail per requirement)

judge runs **Auditor plugins** that check whether the actual state of a system matches the declared requirements. Each auditor handles a different domain (applications, system, infrastructure).

!!! note "Planned"
    judge is not yet implemented. This describes the intended design.

## Supporting Tools

| Tool | Role |
|------|------|
| **waiter** | Orchestrates the full pipeline — sequences stages, handles errors, manages retries |
| **unravel** | Inspects and debugs pipeline state — shows what data flows between stages |

## Data Flow Example

The following sequence diagram shows the full pipeline execution:

<!-- Diagram placeholder -->

A complete flow for deploying a web application:

```yaml
# 1. Define the application (HERY entity)
_entity: github.com/AmadlaOrg/EntityApplication@v1.0.0
_body:
  name: my-web-app
  requires:
    - _entity: github.com/AmadlaOrg/EntitySystem@v1.0.0
      _body:
        package: nginx
        version: ">=1.24"
    - _entity: github.com/AmadlaOrg/EntitySecret@v1.0.0
      _body:
        key: tls-certificate
        source: vault
        path: secret/data/my-web-app/tls
    - _entity: github.com/AmadlaOrg/EntityInfrastructure@v1.0.0
      _body:
        provider: digitalocean
        type: droplet
        size: s-1vcpu-1gb
```

```bash
# 2. Pipeline execution
hery query --collection prod "EntityApplication" \
  | doorman resolve \
  | raise provision \
  | lay install \
  | weaver weave --template-dir ./templates \
  | judge audit
```

Each `|` represents a JSON hand-off between tools.
