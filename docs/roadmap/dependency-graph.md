# Dependency Graph

This page documents which repositories depend on which, determining the build order for the ecosystem.

## Library Dependencies

```
LibraryUtils                          (no Amadla dependencies)
│
├── LibraryFramework                  (depends on: LibraryUtils)
│
├── LibraryPluginFramework            (depends on: LibraryUtils)
│
├── LibraryClerkFramework             (depends on: LibraryUtils)
│
└── LibraryAuditFramework             (depends on: LibraryUtils, LibraryFramework)
```

## Tool Dependencies

```
hery                                  (depends on: LibraryUtils, LibraryFramework)
doorman                               (depends on: LibraryUtils, LibraryFramework)
weaver                                (depends on: LibraryUtils)
auditor-application                   (depends on: LibraryUtils, LibraryAuditFramework)
clerk-keepassxc                       (depends on: dbus — minimal Amadla deps)
hery-playground                       (independent — uses Gin, no Amadla libs)
```

## Full Dependency Matrix

| Repo | LibraryUtils | LibraryFramework | LibraryPluginFW | LibraryClerkFW | LibraryAuditFW |
|------|:---:|:---:|:---:|:---:|:---:|
| LibraryFramework | x | — | — | — | — |
| LibraryPluginFramework | x | — | — | — | — |
| LibraryClerkFramework | x | — | — | — | — |
| LibraryAuditFramework | x | x | — | — | — |
| hery | x | x | — | — | — |
| doorman | x | x | — | — | — |
| weaver | x | — | — | — | — |
| auditor-application | x | — | — | — | x |
| clerk-keepassxc | — | — | — | — | — |

## Build Order

The ecosystem must be built in this order (each level can be built in parallel):

```
Level 0: LibraryUtils
Level 1: LibraryFramework, LibraryPluginFramework, LibraryClerkFramework
Level 2: LibraryAuditFramework, hery, doorman, weaver
Level 3: auditor-application, clerk-keepassxc
Level 4: (future tools: raise, lay, judge, waiter, unravel)
```

## go.mod Replace Directives

All inter-project dependencies use `replace` directives pointing to sibling directories:

| Project | Replace Directives |
|---------|-------------------|
| hery | `LibraryUtils => ../LibraryUtils`, `LibraryFramework => ../LibraryFramework` |
| doorman | `LibraryUtils => ../LibraryUtils`, `LibraryFramework => ../LibraryFramework` |
| weaver | `LibraryUtils => ../LibraryUtils` |
| LibraryClerkFramework | `LibraryUtils => ../LibraryUtils` |
| LibraryAuditFramework | `LibraryUtils => ../LibraryUtils`, `LibraryFramework => ../LibraryFramework` |
| auditor-application | `LibraryUtils => ../LibraryUtils`, `LibraryAuditFramework => ../LibraryAuditFramework` |

This means **all repositories must be checked out as siblings** in the same parent directory for local development to work.

## Impact Analysis

Changes to foundational libraries have cascading impact:

| Change In | Affects |
|-----------|---------|
| LibraryUtils | **Everything** — all 10 other Go projects |
| LibraryFramework | hery, doorman, LibraryAuditFramework, auditor-application |
| LibraryPluginFramework | LibraryClerkFramework, LibraryAuditFramework |
| LibraryClerkFramework | All clerk plugins |
| LibraryAuditFramework | All auditor plugins |

This is why the development plan starts bottom-up with LibraryUtils.
