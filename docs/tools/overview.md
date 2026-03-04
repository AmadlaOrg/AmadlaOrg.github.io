# Tools Overview

Amadla's core tools form a data pipeline where each tool handles one stage of the infrastructure automation workflow.

## Tool Inventory

| Tool | Purpose | Pipeline Stage | Status | Go Module |
|------|---------|---------------|--------|-----------|
| [hery](hery.md) | HERY data storage — entity management, schema validation, SQLite caching | Define requirements | Partial | `github.com/AmadlaOrg/hery` |
| [doorman](doorman.md) | Secrets daemon — encrypted cache, Clerk plugins | Resolve secrets | Early | `github.com/AmadlaOrg/doorman` |
| [weaver](weaver.md) | Template generator — pluggable template engines | Generate configuration | Partial | `github.com/AmadlaOrg/weaver` |
| [raise](raise.md) | Infrastructure provisioner — wraps IaC tools | Provision infrastructure | Planned | — |
| [lay](lay.md) | Package/app installer — wraps package managers | Install applications | Planned | — |
| [judge](judge.md) | Audit orchestrator — runs auditor plugins | Audit compliance | Planned | — |
| [waiter](waiter.md) | Pipeline orchestrator — sequences tool execution | Orchestration | Planned | — |
| [unravel](unravel.md) | Debug/inspection — examines pipeline state | Debugging | Planned | — |
| [dryrun](dryrun.md) | Dry run — tests settings and configuration files | Validation | Planned | — |

## Status Definitions

| Status | Meaning |
|--------|---------|
| **Active** | Fully functional, in regular use |
| **Partial** | Core functionality works, some commands stubbed or incomplete |
| **Early** | Basic structure in place, most functionality not yet implemented |
| **Planned** | Repository exists but contains only stubs or READMEs |

## Pipeline Position

```
hery → doorman → raise → lay → weaver → judge
                                          │
                              waiter (orchestrates all)
                              unravel (debugs all)
                              dryrun (validates configs)
```

## Common Patterns

All tools share these characteristics:

- **Written in Go** using the standard Amadla project structure
- **CLI via Cobra** wrapped by LibraryFramework
- **JSON output** for piping between tools
- **`settings` command** for configuration management
- **`--collection` flag** for specifying which HERY collection to operate on
- **Standard Makefile** with `build`, `test`, `lint`, `generate` targets
