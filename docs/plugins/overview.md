---
description: Amadla's plugin ecosystem — raise, doorman, judge, weaver, and enjoin plugins that extend tools with provider-specific functionality.
---

# Plugins Overview

Amadla uses plugins to extend core tools with external integrations. Each plugin is a **standalone CLI executable** that communicates via stdin/stdout/stderr following the [Plugin Protocol](../architecture/plugin-system.md).

Plugins can be written in **any language** — Go, Python, Bash, or anything that follows the protocol. Go framework libraries are available as optional convenience wrappers.

## Plugin Categories

| Category | Host Tool | Naming | Count | Active | Planned/Stubs |
|----------|-----------|--------|-------|--------|---------------|
| [Raise Plugins](raise-plugins.md) | raise | `raise-*` | 10 | 7 | 3 |
| [Doorman Plugins](doorman-plugins.md) | doorman | `doorman-*` | 16 | 3 | 13 |
| [Judge Plugins](judges.md) | judge | `judge-*` | 4 | 3 | 1 |
| [Weaver Plugins](weavers.md) | weaver | `weaver-*` | 5 | 5 | 0 |
| [Enjoin Plugins](enjoin-plugins.md) | enjoin | `enjoin-*` | 10 | 10 | 0 |
| [Waiter Plugins](../tools/waiter.md) | waiter | `waiter-*` | 6 | 6 | 0 |
| [Lighthouse Plugins](../tools/lighthouse.md) | lighthouse | `lighthouse-*` | 5 | 5 | 0 |
| **Total** | | | **56** | **39** | **17** |

## Naming Convention

Plugins use the `<tool>-<name>` pattern, where the prefix matches the host tool name:

- `doorman-vault` — Doorman plugin for HashiCorp Vault
- `judge-application` — Judge plugin for application validation
- `weaver-jinja2` — Weaver plugin for Jinja2 templates

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
| LibraryEnjoinFramework | Enjoin plugins | Apply/validate boilerplate, output formatting |
| — | Weaver plugins | No framework yet (direct protocol implementation) |

These frameworks are **convenience wrappers** that reduce boilerplate for Go authors. They are not required — any language that implements the protocol works.

## Development Status

Active plugins serve as reference implementations:

- **raise-libvirt** — Reference Raise plugin (Go) — local KVM/QEMU VMs
- **raise-virtualbox** — Raise plugin for VirtualBox (Go)
- **raise-wsl** — Raise plugin for WSL2 (Go)
- **raise-quickemu** — Raise plugin for Quickemu (Go)
- **raise-aws** — Raise plugin for AWS EC2 (Go)
- **raise-digitalocean** — Raise plugin for DigitalOcean droplets (Go)
- **raise-opentofu** — Raise plugin for OpenTofu-managed infrastructure (Go)
- **doorman-keepassxc** — Reference Doorman plugin (Go)
- **judge-application** — Reference Judge plugin (Go)

`raise-xen` is the next planned plugin — required for building the Amadla Linux distro.
