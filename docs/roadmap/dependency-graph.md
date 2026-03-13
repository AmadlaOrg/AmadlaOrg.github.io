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
├── LibraryDoormanFramework             (depends on: LibraryUtils)
│
└── LibraryJudgeFramework             (depends on: LibraryUtils, LibraryFramework)
```

## Tool Dependencies

```
hery                                  (depends on: LibraryUtils, LibraryFramework)
doorman                               (depends on: LibraryUtils, LibraryFramework)
weaver                                (depends on: LibraryUtils)
judge-application                   (depends on: LibraryUtils, LibraryJudgeFramework)
doorman-keepassxc                       (depends on: dbus — minimal Amadla deps)
hery-playground                       (independent — uses Gin, no Amadla libs)
```

## Full Dependency Matrix

| Repo | LibraryUtils | LibraryFramework | LibraryPluginFW | LibraryClerkFW | LibraryAuditFW |
|------|:---:|:---:|:---:|:---:|:---:|
| LibraryFramework | x | — | — | — | — |
| LibraryPluginFramework | x | — | — | — | — |
| LibraryDoormanFramework | x | — | — | — | — |
| LibraryJudgeFramework | x | x | — | — | — |
| hery | x | x | — | — | — |
| doorman | x | x | — | — | — |
| weaver | x | — | — | — | — |
| judge-application | x | — | — | — | x |
| doorman-keepassxc | — | — | — | — | — |

## Build Order

The ecosystem must be built in this order (each level can be built in parallel):

```
Level 0: LibraryUtils
Level 1: LibraryFramework, LibraryPluginFramework, LibraryDoormanFramework
Level 2: LibraryJudgeFramework, hery, doorman, weaver
Level 3: judge-application, doorman-keepassxc
Level 4: (future tools: raise, lay, judge, waiter, unravel)
```

## go.mod Replace Directives

All inter-project dependencies use `replace` directives pointing to sibling directories:

| Project | Replace Directives |
|---------|-------------------|
| hery | `LibraryUtils => ../LibraryUtils`, `LibraryFramework => ../LibraryFramework` |
| doorman | `LibraryUtils => ../LibraryUtils`, `LibraryFramework => ../LibraryFramework` |
| weaver | `LibraryUtils => ../LibraryUtils` |
| LibraryDoormanFramework | `LibraryUtils => ../LibraryUtils` |
| LibraryJudgeFramework | `LibraryUtils => ../LibraryUtils`, `LibraryFramework => ../LibraryFramework` |
| judge-application | `LibraryUtils => ../LibraryUtils`, `LibraryJudgeFramework => ../LibraryJudgeFramework` |

This means **all repositories must be checked out as siblings** in the same parent directory for local development to work.

## Impact Analysis

Changes to foundational libraries have cascading impact:

| Change In | Affects |
|-----------|---------|
| LibraryUtils | **Everything** — all 10 other Go projects |
| LibraryFramework | hery, doorman, LibraryJudgeFramework, judge-application |
| LibraryPluginFramework | LibraryDoormanFramework, LibraryJudgeFramework |
| LibraryDoormanFramework | All doorman plugins |
| LibraryJudgeFramework | All judge plugins |

This is why the development plan starts bottom-up with LibraryUtils.
