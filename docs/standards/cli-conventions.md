# CLI Conventions

All Amadla CLI tools and plugins follow consistent patterns for commands, flags, I/O, and exit codes. These conventions ensure UNIX composability — any tool or plugin can be used standalone or piped together.

## CLI Framework

All Go tools use [Cobra](https://github.com/spf13/cobra) wrapped by **LibraryFramework**:

```go
package main

import "github.com/AmadlaOrg/LibraryFramework/cli"

func main() {
    app := cli.New()
    // Register commands
    app.Execute()
}
```

Plugins written in other languages do not need the framework — they just need to follow the conventions below.

## Standard Commands

Every tool MUST implement:

| Command | Purpose |
|---------|---------|
| `{tool} settings` | View and modify tool configuration |
| `{tool} version` | Show version information |

Every plugin MUST implement:

| Command | Purpose |
|---------|---------|
| `{plugin} info` | Return JSON metadata (name, version, supported entities) |
| `{plugin} {verb}` | Execute the plugin's main function |

## Standard Flags

All tools and plugins MUST support:

| Flag | Purpose |
|------|---------|
| `-o, --output <format>` | Output format: `table` (default), `json`, `yaml` |
| `-f, --file <path>` | Input file (`-` for stdin, which is the default) |
| `-v, --version` | Print version |
| `-h, --help` | Print help |

## Standard I/O

Tools and plugins communicate via standard I/O streams following UNIX conventions:

| Stream | Purpose | Content |
|--------|---------|---------|
| **stdin** | Entity data input | YAML or JSON (auto-detected) |
| **stdout** | Result data output | Controlled by `-o` flag |
| **stderr** | Diagnostics and errors | Human-readable messages |

**Rules:**

- Data goes to stdout, diagnostics go to stderr — **never mix them**
- Plugins MUST accept both YAML and JSON on stdin (auto-detect: first non-whitespace char `{` = JSON, otherwise YAML)
- `-f -` or omitting `-f` entirely means "read from stdin"
- When stdout is intended for piping, use `-o json` or `-o yaml`
- Default output format is `table` (human-readable)

### Output Formats

| Format | When to use | Example |
|--------|-------------|---------|
| `table` | Interactive terminal use (default) | Formatted table with headers |
| `json` | Piping between tools | `{"status": "pass", ...}` |
| `yaml` | Human-readable structured output | YAML document |

For single-item output, `table` format uses key-value pairs instead of a table.

### Example Pipeline

```bash
# Each | is a JSON entity hand-off
hery query --type '*/application@*' -o json \
  | doorman resolve -o json \
  | weaver render -o json \
  | waiter deploy --strategy canary
```

## Exit Codes

All tools and plugins MUST use standard exit codes:

| Code | Meaning | Example |
|------|---------|---------|
| `0` | Success | Command completed, validation passed |
| `1` | Failure | Runtime error, validation failed, secret not found |
| `2` | Usage error | Bad arguments, unknown flags, missing required input |

For judge plugins specifically: `0` = pass, `1` = fail, `2` = error (couldn't validate).

This enables branching without parsing output:

```bash
if judge-application validate < entity.yaml; then
    echo "Validation passed"
else
    echo "Validation failed" >&2
fi
```

## Plugin Info Subcommand

Every plugin MUST implement an `info` subcommand that outputs JSON metadata:

```bash
doorman-vault info
```

```json
{
  "name": "doorman-vault",
  "version": "1.0.0",
  "supports": ["amadla.org/entity/secret@^v1.0.0"],
  "description": "HashiCorp Vault / OpenBao secret source"
}
```

The `supports` array declares which entity types the plugin can handle. Host tools use this for automatic routing.

## Settings Pattern

The `settings` command provides consistent configuration management:

```bash
{tool} settings              # Show all settings
{tool} settings get {key}    # Get a specific setting
{tool} settings set {key} {value}  # Set a value
```

Settings are stored using Viper (via LibraryUtils/configuration).
