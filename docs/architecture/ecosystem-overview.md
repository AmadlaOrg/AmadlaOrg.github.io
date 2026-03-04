# Ecosystem Overview

The Amadla ecosystem consists of 52+ repositories organized into six categories. All repositories live under [github.com/AmadlaOrg](https://github.com/AmadlaOrg) (public) with private services under [github.com/AmadlaCom](https://github.com/AmadlaCom).

## Repository Map

### Core Tools

CLI applications that form the data pipeline.

| Repo | Module | Purpose | Status |
|------|--------|---------|--------|
| [hery](https://github.com/AmadlaOrg/hery) | `github.com/AmadlaOrg/hery` | HERY data storage — entity management with schema validation, Git versioning, SQLite caching | Partial |
| [doorman](https://github.com/AmadlaOrg/doorman) | `github.com/AmadlaOrg/doorman` | Secrets daemon — pulls secrets from Clerk plugins, encrypted in-memory cache | Early |
| [weaver](https://github.com/AmadlaOrg/weaver) | `github.com/AmadlaOrg/weaver` | Template generator — renders config files using HERY entities and pluggable template engines | Partial |
| [dryrun](https://github.com/AmadlaOrg/dryrun) | — | Dry run tool — tests settings and configuration files | Planned |
| [judge](https://github.com/AmadlaOrg/judge) | — | Auditing orchestrator — runs auditor plugins against entity requirements | Planned |
| [lay](https://github.com/AmadlaOrg/lay) | — | Package/app installer — installs applications based on entity requirements | Planned |
| [raise](https://github.com/AmadlaOrg/raise) | — | Infrastructure provisioner — provisions servers/resources from entity requirements | Planned |
| [waiter](https://github.com/AmadlaOrg/waiter) | — | Pipeline orchestrator — sequences tool execution | Planned |
| [unravel](https://github.com/AmadlaOrg/unravel) | — | Debug/inspection tool — examines pipeline state | Planned |

### Libraries

Shared Go libraries that provide common functionality.

| Repo | Module | Purpose | Status |
|------|--------|---------|--------|
| [LibraryUtils](https://github.com/AmadlaOrg/LibraryUtils) | `github.com/AmadlaOrg/LibraryUtils` | Foundation utilities: git, file, database, IPC, encryption, configuration | Active |
| [LibraryFramework](https://github.com/AmadlaOrg/LibraryFramework) | `github.com/AmadlaOrg/LibraryFramework` | CLI framework wrapper around Cobra with decorator pattern | Active |
| [LibraryPluginFramework](https://github.com/AmadlaOrg/LibraryPluginFramework) | `github.com/AmadlaOrg/LibraryPluginFramework` | Plugin system framework for loading and communicating with external plugins | Active |
| [LibraryClerkFramework](https://github.com/AmadlaOrg/LibraryClerkFramework) | `github.com/AmadlaOrg/LibraryClerkFramework` | Specialization of plugin framework for Clerk (secret source) plugins | Active |
| [LibraryAuditFramework](https://github.com/AmadlaOrg/LibraryAuditFramework) | `github.com/AmadlaOrg/LibraryAuditFramework` | Specialization of plugin framework for Auditor plugins | Active |

### Clerk Plugins (Secret Sources)

Each clerk integrates doorman with a specific secret store.

| Repo | Module | Integrates With | Status |
|------|--------|----------------|--------|
| [clerk-vault](https://github.com/AmadlaOrg/clerk-vault) | — | HashiCorp Vault / OpenBao | Stub |
| [clerk-aws](https://github.com/AmadlaOrg/clerk-aws) | — | AWS Secrets Manager / SSM | Stub |
| [clerk-keepassxc](https://github.com/AmadlaOrg/clerk-keepassxc) | `github.com/AmadlaOrg/clerk-keepassxc` | KeePassXC password manager | Active (Go) |
| [clerk-keycloak](https://github.com/AmadlaOrg/clerk-keycloak) | — | Keycloak identity server | Stub |
| [clerk-bitwarden](https://github.com/AmadlaOrg/clerk-bitwarden) | — | Bitwarden password manager | Stub |
| [clerk-sops](https://github.com/AmadlaOrg/clerk-sops) | — | Mozilla SOPS encrypted files | Stub |
| [clerk-digitalocean](https://github.com/AmadlaOrg/clerk-digitalocean) | — | DigitalOcean secrets | Stub |
| [clerk-linode](https://github.com/AmadlaOrg/clerk-linode) | — | Linode/Akamai secrets | Stub |
| [clerk-vultr](https://github.com/AmadlaOrg/clerk-vultr) | — | Vultr secrets | Stub |
| [clerk-ovh](https://github.com/AmadlaOrg/clerk-ovh) | — | OVH secrets | Stub |
| [clerk-rackspace](https://github.com/AmadlaOrg/clerk-rackspace) | — | Rackspace secrets | Stub |
| [clerk-chrome](https://github.com/AmadlaOrg/clerk-chrome) | — | Chrome browser stored passwords | Stub |
| [clerk-chromium](https://github.com/AmadlaOrg/clerk-chromium) | — | Chromium browser stored passwords | Stub |
| [clerk-firefox](https://github.com/AmadlaOrg/clerk-firefox) | — | Firefox browser stored passwords | Stub |
| [clerk-thunderbird](https://github.com/AmadlaOrg/clerk-thunderbird) | — | Thunderbird stored credentials | Stub |
| [clerk-gnomekeyring](https://github.com/AmadlaOrg/clerk-gnomekeyring) | — | GNOME Keyring | Stub |

### Auditor Plugins

Each auditor checks a specific aspect of system compliance.

| Repo | Module | Audits | Status |
|------|--------|--------|--------|
| [auditor-application](https://github.com/AmadlaOrg/auditor-application) | `github.com/AmadlaOrg/auditor-application` | Whether required applications/packages are installed | Active (Go) |
| [auditor-system](https://github.com/AmadlaOrg/auditor-system) | — | System-level requirements (OS, kernel, resources) | Stub |
| [auditor-infrastructure](https://github.com/AmadlaOrg/auditor-infrastructure) | — | Infrastructure-level requirements (networking, storage) | Stub |

### Weaver Plugins (Template Engines)

Each weaver plugin provides a template rendering engine.

| Repo | Module | Engine | Status |
|------|--------|--------|--------|
| [weaver-jinja](https://github.com/AmadlaOrg/weaver-jinja) | — | Jinja2 (Python-style) | Stub |
| [weaver-js-handlebars](https://github.com/AmadlaOrg/weaver-js-handlebars) | — | Handlebars (JavaScript) | Stub |
| [weaver-js-mustache](https://github.com/AmadlaOrg/weaver-js-mustache) | — | Mustache (JavaScript) | Stub |
| [weaver-qute](https://github.com/AmadlaOrg/weaver-qute) | — | Qute (Java/Quarkus) | Stub |

### Entity Definitions

JSON Schema definitions that describe the structure of HERY entities.

| Repo | Module | Defines | Status |
|------|--------|---------|--------|
| [Entity](https://github.com/AmadlaOrg/Entity) | — | Base entity schema — common `_meta`, `_entity`, `_id`, `_body` structure | Active |
| [EntityApplication](https://github.com/AmadlaOrg/EntityApplication) | — | Application requirements (packages, services, configurations) | Active |
| [EntitySystem](https://github.com/AmadlaOrg/EntitySystem) | — | System requirements (OS, kernel, resources) | Active |
| [EntityInfrastructure](https://github.com/AmadlaOrg/EntityInfrastructure) | — | Infrastructure requirements (servers, networks, storage) | Active |
| [EntityProgrammingLanguage](https://github.com/AmadlaOrg/EntityProgrammingLanguage) | — | Programming language runtime requirements | Active |
| [EntityContainer](https://github.com/AmadlaOrg/EntityContainer) | — | Container/image definitions | Active |
| [EntitySecret](https://github.com/AmadlaOrg/EntitySecret) | — | Secret references and metadata | Active |
| [EntityJudge](https://github.com/AmadlaOrg/EntityJudge) | — | Audit rule definitions | Active |

### Other Repositories

| Repo | Module | Purpose | Status |
|------|--------|---------|--------|
| [common-json-schemas](https://github.com/AmadlaOrg/common-json-schemas) | — | Shared JSON Schema definitions | Active |
| [hery-playground](https://github.com/AmadlaOrg/hery-playground) | — | Web app for querying HERY entities (Gin + drag-drop YAML/SQLite) | Active |
| [hery-jetbrains-editor-plugin](https://github.com/AmadlaOrg/hery-jetbrains-editor-plugin) | — | JetBrains IDE plugin for HERY syntax | Stub |
| [hery-code-editor-plugin](https://github.com/AmadlaOrg/hery-code-editor-plugin) | — | VS Code extension for HERY syntax | Stub |
| [template-application-golang](https://github.com/AmadlaOrg/template-application-golang) | — | Go project template with standard Makefile | Active |
| [GitHub-Actions](https://github.com/AmadlaOrg/GitHub-Actions) | — | Shared CI/CD workflow templates | Active |
| [AmadlaOrg.github.io](https://github.com/AmadlaOrg/AmadlaOrg.github.io) | — | GitHub Pages site | Minimal |

## How Components Connect

<!-- Diagram placeholder -->

All Go projects use `replace` directives in `go.mod` to reference sibling directories during development:

```go
replace github.com/AmadlaOrg/LibraryUtils => ../LibraryUtils
replace github.com/AmadlaOrg/LibraryFramework => ../LibraryFramework
```
