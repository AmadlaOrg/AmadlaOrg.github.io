# CLI Conventions

All Amadla CLI tools follow consistent patterns for commands, flags, and output.

## CLI Framework

All tools use [Cobra](https://github.com/spf13/cobra) wrapped by **LibraryFramework**:

```go
package main

import "github.com/AmadlaOrg/LibraryFramework/cli"

func main() {
    app := cli.New()
    // Register commands
    app.Execute()
}
```

## Standard Commands

Every tool should implement:

| Command | Purpose |
|---------|---------|
| `{tool} settings` | View and modify tool configuration |
| `{tool} version` | Show version information |

## Common Flags

| Flag | Scope | Purpose |
|------|-------|---------|
| `--collection` | Entity-related commands | Specify which HERY collection to operate on |
| `--output` | Query commands | Output format (json, table, yaml) |

## JSON Piping

Tools communicate via JSON on stdout. Each tool:

1. Reads structured input from stdin (or from HERY directly)
2. Processes the data
3. Emits JSON on stdout for the next tool

```bash
hery query --collection prod "EntityApplication" \
  | doorman resolve \
  | weaver weave --template-dir ./templates
```

## Error Output

- Errors go to stderr, never stdout
- Error format should be consistent (structured JSON when `--output json` is set)
- Exit codes: 0 for success, 1 for general errors, 2 for usage errors

## Settings Pattern

The `settings` command provides consistent configuration management:

```bash
{tool} settings              # Show all settings
{tool} settings get {key}    # Get a specific setting
{tool} settings set {key} {value}  # Set a value
```

Settings are stored using Viper (via LibraryUtils/configuration).
