# Ecosystem Overview

The Amadla ecosystem consists of 52+ repositories organized into seven categories. All repositories live under [github.com/AmadlaOrg](https://github.com/AmadlaOrg) (public) with private services under [github.com/AmadlaCom](https://github.com/AmadlaCom).

## Repository Map

### Core Tools

CLI applications that form the data pipeline.

| Repo | Purpose | Status |
|------|---------|--------|
| [hery](https://github.com/AmadlaOrg/hery) | [HERY](hery-concepts.md) data storage — entity management with schema validation, Git versioning, SQLite caching | Partial |
| [doorman](https://github.com/AmadlaOrg/doorman) | Secrets management CLI — resolves secrets from Doorman plugins on demand | Early |
| [weaver](https://github.com/AmadlaOrg/weaver) | Template generator — renders config files using HERY entities and pluggable template engines | Partial |
| [dryrun](https://github.com/AmadlaOrg/dryrun) | Safely tests settings with auto-revert (e.g., prevents SSH lockout). Currently Python, may move to Go | Planned |
| [judge](https://github.com/AmadlaOrg/judge) | Validates merged entity state — checks requirements, cross-entity conflicts, drift detection (with unravel) | Early |
| [lay](https://github.com/AmadlaOrg/lay) | Package/app installer — installs applications based on merged entity output | Partial |
| [raise](https://github.com/AmadlaOrg/raise) | Infrastructure provisioner — provisions cloud resources from entities via plugin system per cloud API | Planned |
| [waiter](https://github.com/AmadlaOrg/waiter) | Deployment tool — blue-green, canary, rolling strategies with platform plugins | Planned |
| [unravel](https://github.com/AmadlaOrg/unravel) | Discovery tool — discovers existing system state as entities. Wraps osquery + custom plugins (stateless, on-demand) | Planned |
| [conduct](https://github.com/AmadlaOrg/conduct) | Multi-server orchestrator — coordinates waiter/lay across distributed nodes | Planned |
| [lighthouse](https://github.com/AmadlaOrg/lighthouse) | Notification/alerting tool — sends via plugins (webhook, SMS, email, REST API) | Planned |
| [garbage](https://github.com/AmadlaOrg/garbage) | Trash/uninstall tool — tracks and removes what's no longer needed | Partial |
| [amadla](https://github.com/AmadlaOrg/amadla) | Meta-tool — executes Pipeline entities, generates D2 diagrams, tool inventory | Planned |

### Libraries

Shared Go libraries that provide common functionality.

| Repo | Purpose | Status |
|------|---------|--------|
| [LibraryUtils](https://github.com/AmadlaOrg/LibraryUtils) | Foundation utilities: git, file, database, IPC, encryption, configuration | Active |
| [LibraryFramework](https://github.com/AmadlaOrg/LibraryFramework) | CLI framework wrapper around Cobra with decorator pattern | Active |
| [LibraryPluginFramework](https://github.com/AmadlaOrg/LibraryPluginFramework) | Plugin system framework for loading and communicating with external plugins | Active |
| [LibraryDoormanFramework](https://github.com/AmadlaOrg/LibraryDoormanFramework) | Specialization of plugin framework for Doorman (secret source) plugins | Active |
| [LibraryJudgeFramework](https://github.com/AmadlaOrg/LibraryJudgeFramework) | Specialization of plugin framework for Judge plugins | Active |

### Doorman Plugins (Secret Sources)

Each plugin integrates doorman with a specific secret store.

| Repo | Integrates With | Status |
|------|----------------|--------|
| [doorman-vault](https://github.com/AmadlaOrg/doorman-vault) | HashiCorp Vault / OpenBao | Stub |
| [doorman-aws](https://github.com/AmadlaOrg/doorman-aws) | AWS Secrets Manager / SSM | Stub |
| [doorman-keepassxc](https://github.com/AmadlaOrg/doorman-keepassxc) | KeePassXC password manager | Active (Go) |
| [doorman-keycloak](https://github.com/AmadlaOrg/doorman-keycloak) | Keycloak identity server | Stub |
| [doorman-bitwarden](https://github.com/AmadlaOrg/doorman-bitwarden) | Bitwarden password manager | Stub |
| [doorman-sops](https://github.com/AmadlaOrg/doorman-sops) | Mozilla SOPS encrypted files | Stub |
| [doorman-digitalocean](https://github.com/AmadlaOrg/doorman-digitalocean) | DigitalOcean secrets | Stub |
| [doorman-linode](https://github.com/AmadlaOrg/doorman-linode) | Linode/Akamai secrets | Stub |
| [doorman-vultr](https://github.com/AmadlaOrg/doorman-vultr) | Vultr secrets | Stub |
| [doorman-ovh](https://github.com/AmadlaOrg/doorman-ovh) | OVH secrets | Stub |
| [doorman-rackspace](https://github.com/AmadlaOrg/doorman-rackspace) | Rackspace secrets | Stub |
| [doorman-chrome](https://github.com/AmadlaOrg/doorman-chrome) | Chrome browser stored passwords | Stub |
| [doorman-chromium](https://github.com/AmadlaOrg/doorman-chromium) | Chromium browser stored passwords | Stub |
| [doorman-firefox](https://github.com/AmadlaOrg/doorman-firefox) | Firefox browser stored passwords | Stub |
| [doorman-thunderbird](https://github.com/AmadlaOrg/doorman-thunderbird) | Thunderbird stored credentials | Stub |
| [doorman-gnomekeyring](https://github.com/AmadlaOrg/doorman-gnomekeyring) | GNOME Keyring | Stub |

### Judge Plugins

Each plugin checks a specific aspect of system compliance.

| Repo | Validates | Status |
|------|--------|--------|
| [judge-application](https://github.com/AmadlaOrg/judge-application) | Whether required applications/packages are installed | Active (Go) |
| [judge-system](https://github.com/AmadlaOrg/judge-system) | System-level requirements (OS, kernel, resources) | Stub |
| [judge-infrastructure](https://github.com/AmadlaOrg/judge-infrastructure) | Infrastructure-level requirements (networking, storage) | Stub |

### Weaver Plugins (Template Engines)

Each weaver plugin provides a template rendering engine.

| Repo | Engine | Status |
|------|--------|--------|
| [weaver-jinja](https://github.com/AmadlaOrg/weaver-jinja) | Jinja2 (Python-style) | Stub |
| [weaver-js-handlebars](https://github.com/AmadlaOrg/weaver-js-handlebars) | Handlebars (JavaScript) | Stub |
| [weaver-js-mustache](https://github.com/AmadlaOrg/weaver-js-mustache) | Mustache (JavaScript) | Stub |
| [weaver-qute](https://github.com/AmadlaOrg/weaver-qute) | Qute (Java/Quarkus) | Stub |

### Entity Definitions

JSON Schema definitions that describe the structure of HERY entities.

| Repo | Defines | Status |
|------|---------|--------|
| [Entity](https://github.com/AmadlaOrg/Entity) | Base HERY schema — common `_type`, `_extends`, `_meta`, `_body`, `_requires` structure | Active |
| [Application](https://github.com/AmadlaOrg/Entities/Application) | Application requirements (packages, services, configurations) | Active |
| [System](https://github.com/AmadlaOrg/Entities/System) | System requirements (OS, kernel, resources) | Active |
| [Infrastructure](https://github.com/AmadlaOrg/Entities/Infrastructure) | Infrastructure requirements (servers, networks, storage) | Active |
| [ProgrammingLanguage](https://github.com/AmadlaOrg/Entities/ProgrammingLanguage) | Programming language runtime requirements | Active |
| [Container](https://github.com/AmadlaOrg/Entities/Container) | Container/image definitions | Active |
| [Secret](https://github.com/AmadlaOrg/Entities/Secret) | Secret references and metadata | Active |
| [Judge](https://github.com/AmadlaOrg/Entities/Judge) | Audit rule definitions | Active |
| [Entities/Tools](https://github.com/AmadlaOrg/Entities) | Tool inventory and discovery configuration | Active |

### Other Repositories

| Repo | Purpose | Status |
|------|---------|--------|
| [common-json-schemas](https://github.com/AmadlaOrg/common-json-schemas) | Shared JSON Schema definitions | Active |
| [hery-playground](https://github.com/AmadlaOrg/hery-playground) | Web app for querying HERY entities (Gin + drag-drop YAML/SQLite) | Active |
| [hery-jetbrains-editor-plugin](https://github.com/AmadlaOrg/hery-jetbrains-editor-plugin) | JetBrains IDE plugin for HERY syntax | Stub |
| [hery-code-editor-plugin](https://github.com/AmadlaOrg/hery-code-editor-plugin) | VS Code extension for HERY syntax | Stub |
| [template-application-golang](https://github.com/AmadlaOrg/template-application-golang) | Go project template with standard Makefile | Active |
| [GitHub-Actions](https://github.com/AmadlaOrg/GitHub-Actions) | Shared CI/CD workflow templates | Active |
| [AmadlaOrg.github.io](https://github.com/AmadlaOrg/AmadlaOrg.github.io) | GitHub Pages site | Minimal |

## How Components Connect

![Library Dependencies](../diagrams/out/c2-library-dependencies.svg)

All Go projects use `replace` directives in `go.mod` to reference sibling directories during development:

```go
replace github.com/AmadlaOrg/LibraryUtils => ../LibraryUtils
replace github.com/AmadlaOrg/LibraryFramework => ../LibraryFramework
```
