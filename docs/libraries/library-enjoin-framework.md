# LibraryEnjoinFramework

| Field | Value |
|-------|-------|
| **Purpose** | Enjoin plugin framework — specialization for system state configuration plugins used by enjoin |
| **Module** | `github.com/AmadlaOrg/LibraryEnjoinFramework` |
| **Status** | Active |
| **Repo** | [AmadlaOrg/LibraryEnjoinFramework](https://github.com/AmadlaOrg/LibraryEnjoinFramework) |

## What It Provides

LibraryEnjoinFramework provides convenience wrappers for Go-based enjoin plugin authors:

- `apply` subcommand — applies system state changes from entity input
- `validate` subcommand — dry-run validation without making changes
- `info` subcommand — outputs plugin metadata as JSON
- Entity input handling (`--entity/-e` flag or stdin)
- JSON result output with status and details
- Display formatting (`-o table|json|yaml`)
- UNIX exit code protocol (0=success, 1=failure, 2=usage error)

## Usage

Plugin authors provide two callbacks:

```go
package main

import "github.com/AmadlaOrg/LibraryEnjoinFramework/enjoin"

func main() {
    enjoin.New(
        "enjoin-user",
        "Enjoin User",
        "1.0.0",
        []string{"amadla.org/entity/user@^v1.0.0"},
        "Manages system users, groups, and sudoers",
        applyFunc,    // RunApply callback
        validateFunc, // RunValidate callback
    )
}
```

## Callback Types

```go
// RunApply applies system state and returns success + details.
type RunApply func(*io.Reader) (bool, map[string]any)

// RunValidate dry-run checks without making changes.
type RunValidate func(*io.Reader) (bool, map[string]any)
```

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | Foundation utilities |
| LibraryFramework | CLI framework |

## Consumers

- enjoin-user
- enjoin-service
- enjoin-firewall
- enjoin-cron (planned)
- enjoin-network (planned)
- enjoin-filesystem (planned)
- enjoin-certificate (planned)
- enjoin-selinux (planned)
- enjoin-apparmor (planned)
- enjoin-sysctl (planned)

## Package Structure

```
LibraryEnjoinFramework/
├── enjoin/                          # Public API
│   └── enjoin.go                    # New(), RunApply, RunValidate exports
├── internal/command/
│   ├── service.go                   # PluginMeta, subcommand wiring
│   └── enjoin/
│       ├── enjoin.go                # Core logic, entity input, exit codes
│       └── service.go               # Cobra command constructors
└── display/
    ├── display.go                   # table/json/yaml rendering
    └── service.go                   # New(), NewWithWriter()
```

## Development Notes

- Follows the same pattern as LibraryJudgeFramework and LibraryDoormanFramework
- Plugins can also be written in any language — just implement the [plugin protocol](../architecture/plugin-system.md)
