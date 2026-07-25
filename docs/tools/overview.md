---
description: Amadla's modular CLI tools — hery, doorman, weaver, raise, lay, enjoin, judge, waiter, and more. Each handles one responsibility in the infrastructure pipeline.
---

# Tools Overview

Amadla's tools form a modular pipeline where each tool handles one responsibility. Tools communicate via JSON entities over standard I/O, following the UNIX philosophy.

## Tool Inventory

| Tool | Purpose | Input | Output |
|------|---------|-------|--------|
| [hery](hery.md) | Source of truth — entity management, deep merge, schema validation, SQLite caching | `.hery` files across layers | Merged entity JSON |
| [doorman](doorman.md) | Secrets management — resolves secret references via doorman-* plugins | Entity data with secret refs | Entity data with secrets resolved |
| [weaver](weaver.md) | Config generation — renders templates from entities (Quadlet, nginx.conf, podman-compose, k8s, CI/CD, etc.) | Entities + templates | Config files |
| [lay](lay.md) | Install — packages, applications, JARs, container image pull/build | Entity requirements | Installed software + image ref entity |
| [waiter](waiter.md) | Deployment — blue-green, canary, rolling strategies with platform plugins | Entities + rendered configs (from weaver) | Deployed application |
| [raise](raise.md) | Infrastructure provisioning — wraps IaC tools via plugin system per cloud API | Infrastructure entities | Provisioned resources |
| [unravel](unravel.md) | Discovery — discovers existing system state as entities. Wraps osquery + custom plugins | System state | "What IS" entities |
| [judge](judge.md) | Validation — compares "what IS" (unravel) vs "what SHOULD BE" (hery). Outputs judge entity (diff) | Expected + actual entities | Judge entity (diff) |
| [conduct](conduct.md) | Multi-server orchestration — coordinates waiter/lay across distributed nodes | Topology entities | Orchestrated deployment |
| [lighthouse](lighthouse.md) | Notifications/alerts — sends via plugins (webhook, WebRTC, Twilio SMS, AWS SES, REST API) | Entities from any tool | Notifications |
| [garbage](garbage.md) | Trash/uninstall — tracks and removes what's no longer needed | Entity refs | Cleanup |
| [dryrun](dryrun.md) | Safety — tests changes with auto-revert (prevents SSH lockout) | Any pipeline | Auto-reverted test |
| [amadla](amadla.md) | Orchestrator — reads `.hery` entities, builds DAG from `_requires`, executes tools in dependency order | `.hery` entity files | Tool execution (parallel tiers) |

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
amadla       (orchestrator: DAG resolution + parallel tool execution)
```

## Tool Interactions

- **lay** builds/pulls container images, **waiter** handles Quadlet unit files and deployment strategies
- **weaver** generates config files (Quadlet, nginx.conf, etc.) — config generation is weaver's job
- **unravel** wraps osquery (on-demand, stateless) — no caching, UNIX philosophy
- **judge** receives expected entity (from hery) + actual entity (from unravel), outputs diff
- Each tool handles its own rollback (waiter rollback, lay uninstall, raise destroy)
- **amadla** reads `.hery` entities, builds a DAG from `_requires`, and orchestrates tool execution with parallel tiers — but is replaceable

## Common Patterns

All tools share these characteristics:

- **Written in Go** using the standard Amadla project structure
- **CLI via Cobra** wrapped by LibraryFramework
- **Structured output** (`-o table|json|yaml`) — data to stdout, diagnostics to stderr
- **Standard exit codes** — 0 success, 1 failure, 2 usage error
- **stdin/stdout piping** between tools (UNIX philosophy)
- **`settings` command** for configuration management
- **Standard Makefile** with `build`, `test`, `lint`, `generate` targets
