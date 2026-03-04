# Libraries Overview

Amadla's shared Go libraries provide common functionality used across all tools and plugins. They form a layered dependency hierarchy with LibraryUtils at the foundation.

## Library Inventory

| Library | Module | Purpose | Status |
|---------|--------|---------|--------|
| [LibraryUtils](library-utils.md) | `github.com/AmadlaOrg/LibraryUtils` | Foundation utilities: git, file, database, IPC, encryption | Active |
| [LibraryFramework](library-framework.md) | `github.com/AmadlaOrg/LibraryFramework` | CLI framework wrapper around Cobra | Active |
| [LibraryPluginFramework](library-plugin-framework.md) | `github.com/AmadlaOrg/LibraryPluginFramework` | Base plugin loading and IPC communication | Active |
| [LibraryClerkFramework](library-clerk-framework.md) | `github.com/AmadlaOrg/LibraryClerkFramework` | Clerk plugin specialization for secret sources | Active |
| [LibraryAuditFramework](library-audit-framework.md) | `github.com/AmadlaOrg/LibraryAuditFramework` | Auditor plugin specialization for compliance checks | Active |

## Dependency Graph

<!-- Diagram placeholder -->

## Build Order

Libraries must be built bottom-up due to `replace` directives:

1. **LibraryUtils** — No Amadla dependencies
2. **LibraryFramework** — Depends on LibraryUtils
3. **LibraryPluginFramework** — Depends on LibraryUtils
4. **LibraryClerkFramework** — Depends on LibraryUtils
5. **LibraryAuditFramework** — Depends on LibraryUtils, LibraryFramework

## Shared Patterns

All libraries follow these conventions:

- **Interface-based design:** `I`-prefixed interfaces (`IGit`, `IFile`, `IDatabase`)
- **Struct implementations:** `S`-prefixed structs (`SGit`, `SFile`)
- **Constructors:** `New*Service()` functions returning interface types
- **Mock generation:** Mockery v2 configured in `.mockery.yaml`
- **Testing:** testify/assert + testify/mock (except hery which uses Ginkgo/Gomega)
- **Local references:** `replace` directives in `go.mod` for sibling directories
