---
description: Shared Go libraries powering the Amadla ecosystem — utilities, CLI framework, and plugin frameworks for doorman, judge, and enjoin.
---

# Libraries Overview

Amadla's shared Go libraries provide common functionality used across all tools and plugins. They form a layered dependency hierarchy with LibraryUtils at the foundation.

## Library Inventory

| Library | Module | Purpose |
|---------|--------|---------|
| [LibraryUtils](library-utils.md) | `github.com/AmadlaOrg/LibraryUtils` | Foundation utilities: git, file, database, IPC, encryption |
| [LibraryFramework](library-framework.md) | `github.com/AmadlaOrg/LibraryFramework` | CLI framework wrapper around Cobra |
| [LibraryPluginFramework](library-plugin-framework.md) | `github.com/AmadlaOrg/LibraryPluginFramework` | Base plugin loading and IPC communication |
| [LibraryDoormanFramework](library-doorman-framework.md) | `github.com/AmadlaOrg/LibraryDoormanFramework` | Doorman plugin specialization for secret sources |
| [LibraryJudgeFramework](library-judge-framework.md) | `github.com/AmadlaOrg/LibraryJudgeFramework` | Judge plugin specialization for compliance checks |
| [LibraryEnjoinFramework](library-enjoin-framework.md) | `github.com/AmadlaOrg/LibraryEnjoinFramework` | Enjoin plugin specialization for system state configuration |

## Dependency Graph

![Library Dependencies](../diagrams/out/c2-library-dependencies.svg)

## Build Order

Libraries must be built bottom-up due to `replace` directives:

1. **LibraryUtils** — No Amadla dependencies
2. **LibraryFramework** — Depends on LibraryUtils
3. **LibraryPluginFramework** — Depends on LibraryUtils
4. **LibraryDoormanFramework** — Depends on LibraryUtils
5. **LibraryJudgeFramework** — Depends on LibraryUtils, LibraryFramework
6. **LibraryEnjoinFramework** — Depends on LibraryUtils, LibraryFramework

## Shared Patterns

All libraries follow these conventions:

- **Interface-based design:** Idiomatic Go naming (`Git`, `File`, `Database`)
- **Struct implementations:** Unexported structs (`gitImpl`, `fileImpl`)
- **Constructors:** `New()` functions returning interface types
- **Mock generation:** Mockery v2 configured in `.mockery.yaml`
- **Testing:** testify/assert + testify/mock (except hery which uses Ginkgo/Gomega)
- **Local references:** `replace` directives in `go.mod` for sibling directories
