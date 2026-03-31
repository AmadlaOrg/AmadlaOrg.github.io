# Current State

Full inventory of every repository in the Amadla ecosystem as of March 2026.

## Summary

| Category | Total | Complete | Active/Partial | Stub/Planned |
|----------|-------|----------|---------------|--------------|
| Core Tools | 14 | 12 | 2 | 0 |
| Libraries | 6 | 6 | 0 | 0 |
| Doorman Plugins | 16 | 3 | 0 | 13 |
| Judge Plugins | 3 | 2 | 0 | 1 |
| Weaver Plugins | 5 | 5 | 0 | 0 |
| Enjoin Plugins | 10 | 10 | 0 | 0 |
| Waiter Plugins | 6 | 6 | 0 | 0 |
| Raise Plugins | 7 | 7 | 0 | 0 |
| Entity Definitions | 8 | 8 | 0 | 0 |
| Other | 8 | 4 | 0 | 4 |
| **Total** | **83** | **63** | **2** | **18** |

## Core Tools Detail

### amadla (Complete)

- Orchestrator CLI — reads `.hery` entities, builds DAG from `_requires`, executes tools in parallel tiers
- Commands: `run` (with `--dry-run`), `init`, `list`, `doctor`, `--config` flag
- DAG: DFS topological sort + Kahn's algorithm for parallel tier grouping
- InfoCache: `<tool> info` cached discovery with mtime-based invalidation
- 62 tests across cmd/, dag/, toolconfig/

### hery (Partial)

- **Commands:** entity (get, list, validate), collection (init, list), query, compose, settings
- **All commands registered** but many have incomplete implementations
- **34 files** with TODO comments
- **Testing:** BDD with Ginkgo v2 + Gomega
- **Dependencies:** LibraryUtils, LibraryFramework

### doorman (Complete)

- Core CLI + 3 plugins (vault, keepassxc, bitwarden)
- Plugin discovery via PATH scanning for `doorman-*` binaries
- Commands: `get`, `plugins`

### weaver (Complete)

- Core CLI + 5 plugins (go, jinja2, mustache, qute, freemarker)
- Plugin discovery via PATH, auto-detect engine from file extension
- Commands: `render`, `plugins`, `weave` (legacy)
- 30 E2E tests across all plugins

### judge (Complete)

- Core CLI + 2 plugins (application, network)
- Plugin discovery via PATH
- Commands: `run`, `plugins`

### lay (Complete)

- 42 packages all passing, idiomatic Go names
- Scope: installation only (Package, Application, ProgrammingLanguage, binary/compile/JAR)

### raise (Complete)

- Core + 7 plugins (libvirt, wsl, virtualbox, aws, digitalocean, quickemu, opentofu)
- Full VM lifecycle: up/halt/destroy/ssh/status
- State stored at `~/.local/share/raise/<engine>/state.json`

### waiter (Complete)

- Core + 6 plugins — 86+ tests passing
- Two-axis plugin model: engine plugins (podman, docker, quadlet) × proxy plugins (proxy-haproxy, proxy-kamal)
- Strategies: blue-green, canary, rolling, restart

### enjoin (Complete)

- Core CLI + 10 plugins (user, service, cron, network, filesystem, firewall, certificate, ids, mac, sysctl)
- Fat plugins with OS-aware backends

### unravel (Complete)

- Core complete, 11 unit tests
- Commands: discover, plugins

### conduct (Complete)

- Multi-server orchestrator — coordinates waiter/lay across distributed nodes

### lighthouse (Complete)

- Core + 4 plugins (webhook, slack, email, sms) — 65+ tests
- Intelligent suppression: dedup → silence → flap detection → backoff → rate limiting → grouping → delivery

### garbage (Complete)

- Phase 1-3 complete, 86 unit tests passing
- Commands: rm, list, restore, empty, info, settings, binary, package

### dryrun (Planned)

- Currently Python, may move to Go

## Entity Definitions

All entity types contain JSON Schema definitions as `<name>.hery.json`:

- 17 entity types + Tools, ~153 sub-types — ~170 schemas total
- Top-level: Application, Container, Infrastructure, OS, Package, ProgrammingLanguage, Secret, Security, System, Template, Tools, User, Service, Cron

## Plugin Stubs

Remaining non-Go repositories — primarily:

- 13 doorman plugin stubs (README-only or minimal Makefile)
- 1 judge plugin stub (judge-system)
- Editor plugins, templates, CI/CD workflows

## Other Repositories

| Repo | Type |
|------|------|
| `common-json-schemas` | JSON Schema definitions |
| `hery-playground` | Web app (Gin) |
| `hery-jetbrains-editor-plugin` | IDE plugin |
| `hery-code-editor-plugin` | VS Code extension |
| `template-application-golang` | Go project template |
| `GitHub-Actions` | CI/CD workflows |
| `AmadlaOrg.github.io` | GitHub Pages |
