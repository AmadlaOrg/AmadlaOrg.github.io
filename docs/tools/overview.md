# Tools Overview

Amadla's tools form a modular pipeline where each tool handles one responsibility. Tools communicate via JSON entities over standard I/O, following the UNIX philosophy.

## Tool Inventory

| Tool | Purpose | Input | Output | Status |
|------|---------|-------|--------|--------|
| [hery](hery.md) | Source of truth — entity management, deep merge, schema validation, SQLite caching | `.hery` files across layers | Merged entity JSON | Partial |
| [doorman](doorman.md) | Secrets management — resolves secret references via doorman-* plugins | Entity data with secret refs | Entity data with secrets resolved | Early |
| [weaver](weaver.md) | Config generation — renders templates from entities (Quadlet, nginx.conf, podman-compose, k8s, CI/CD, etc.) | Entities + templates | Config files | Partial |
| [lay](lay.md) | Install — packages, applications, JARs, container image pull/build | Entity requirements | Installed software + image ref entity | Partial |
| [waiter](waiter.md) | Deployment — blue-green, canary, rolling strategies with platform plugins | Entities + rendered configs (from weaver) | Deployed application | Planned |
| [raise](raise.md) | Infrastructure provisioning — wraps IaC tools via plugin system per cloud API | Infrastructure entities | Provisioned resources | Planned |
| [unravel](unravel.md) | Discovery — discovers existing system state as entities. Wraps osquery + custom plugins | System state | "What IS" entities | Planned |
| [judge](judge.md) | Validation — compares "what IS" (unravel) vs "what SHOULD BE" (hery). Outputs judge entity (diff) | Expected + actual entities | Auditor entity (diff) | Early |
| [conduct](conduct.md) | Multi-server orchestration — coordinates waiter/lay across distributed nodes | Topology entities | Orchestrated deployment | Planned |
| [lighthouse](lighthouse.md) | Notifications/alerts — sends via plugins (webhook, WebRTC, Twilio SMS, AWS SES, REST API) | Entities from any tool | Notifications | Planned |
| [garbage](garbage.md) | Trash/uninstall — tracks and removes what's no longer needed | Entity refs | Cleanup | Partial |
| [dryrun](dryrun.md) | Safety — tests changes with auto-revert (prevents SSH lockout) | Any pipeline | Auto-reverted test | Planned |
| [amadla](amadla.md) | Meta-tool — executes Pipeline entities, generates D2 diagrams, tool inventory | Pipeline entities | Pipeline execution + D2 text | Planned |

## Status Definitions

| Status | Meaning |
|--------|---------|
| **Active** | Fully functional, in regular use |
| **Partial** | Core functionality works, some commands stubbed or incomplete |
| **Early** | Basic structure in place, most functionality not yet implemented |
| **Planned** | Repository exists but contains only stubs or READMEs |

## Pipeline Flow

```bash
hery query --type '*/application@*' -o json \
  | doorman resolve -o json \
  | weaver render -o json \
  | waiter deploy --strategy canary
```

```
hery → doorman → weaver → lay → waiter → judge
                                           │
                              unravel ──────┘ (drift detection)

conduct      (coordinates waiter/lay across multiple servers)
lighthouse   (notifications from any tool output)
garbage      (cleanup/uninstall)
dryrun       (safely tests settings)
amadla       (meta-tool: pipeline execution + D2 diagrams)
```

## Tool Interactions

- **lay** builds/pulls container images, **waiter** handles Quadlet unit files and deployment strategies
- **weaver** generates config files (Quadlet, nginx.conf, etc.) — config generation is weaver's job
- **unravel** wraps osquery (on-demand, stateless) — no caching, UNIX philosophy
- **judge** receives expected entity (from hery) + actual entity (from unravel), outputs diff
- Each tool handles its own rollback (waiter rollback, lay uninstall, raise destroy)
- **amadla** reads Pipeline entities and orchestrates tool execution — but is replaceable

## Common Patterns

All tools share these characteristics:

- **Written in Go** using the standard Amadla project structure
- **CLI via Cobra** wrapped by LibraryFramework
- **Structured output** (`-o table|json|yaml`) — data to stdout, diagnostics to stderr
- **Standard exit codes** — 0 success, 1 failure, 2 usage error
- **stdin/stdout piping** between tools (UNIX philosophy)
- **`settings` command** for configuration management
- **Standard Makefile** with `build`, `test`, `lint`, `generate` targets
