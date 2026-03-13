# Plugins Overview

Amadla uses plugins to extend core tools with external integrations. Each plugin is a **standalone CLI executable** that communicates via stdin/stdout/stderr following the [Plugin Protocol](../architecture/plugin-system.md).

Plugins can be written in **any language** — Go, Python, Bash, or anything that follows the protocol. Go framework libraries are available as optional convenience wrappers.

## Plugin Categories

| Category | Host Tool | Naming | Count | Active | Stubs |
|----------|-----------|--------|-------|--------|-------|
| [Doorman Plugins](clerks.md) | doorman | `doorman-*` | 16 | 1 | 15 |
| [Judge Plugins](auditors.md) | judge | `judge-*` | 3 | 1 | 2 |
| [Weaver Plugins](weavers.md) | weaver | `weaver-*` | 4 | 0 | 4 |
| **Total** | | | **23** | **2** | **21** |

## Naming Convention

Plugins use the `<tool>-<name>` pattern, where the prefix matches the host tool name:

- `doorman-vault` — Doorman plugin for HashiCorp Vault
- `judge-application` — Judge plugin for application validation
- `weaver-jinja` — Weaver plugin for Jinja2 templates

Tools discover plugins by scanning `$PATH` for binaries matching their prefix.

## Plugin Protocol Summary

Every plugin must implement:

```bash
<plugin> info              # JSON metadata (name, version, supported entities)
<plugin> <verb> [flags]    # Business logic
```

Standard I/O:

| Channel | Purpose |
|---------|---------|
| stdin | Entity data (YAML or JSON, auto-detected) |
| stdout | Result data (`-o table|json|yaml`) |
| stderr | Diagnostics and errors |
| exit code | `0` success, `1` failure, `2` usage error |

See [Plugin System Architecture](../architecture/plugin-system.md) for the full protocol specification.

## Go Frameworks (Optional)

| Framework | For | Provides |
|-----------|-----|----------|
| LibraryDoormanFramework | Doorman plugins | Secret-fetching boilerplate, output formatting |
| LibraryJudgeFramework | Judge plugins | Validation boilerplate, pass/fail reporting |
| — | Weaver plugins | No framework yet (direct protocol implementation) |

These frameworks are **convenience wrappers** that reduce boilerplate for Go authors. They are not required — any language that implements the protocol works.

## Development Status

Most plugins are currently stubs (README-only repositories). The two active plugins serve as reference implementations:

- **doorman-keepassxc** (currently `doorman-keepassxc`) — Reference Doorman plugin (Go)
- **judge-application** (currently `judge-application`) — Reference Judge plugin (Go)

Plugin repositories will be renamed to match the new `<tool>-<name>` convention.
