# lay

| Field | Value |
|-------|-------|
| **Purpose** | Package and application installer — installs system packages, standalone binaries, JARs, and runs container commands |
| **Repo** | [AmadlaOrg/lay](https://github.com/AmadlaOrg/lay) |

## Overview

lay handles installation: system packages via the auto-detected package manager, pre-built binaries and JAR applications from forges or URLs, source compilation, and container commands passed through to docker/podman. For containers, lay takes care of building and pulling — waiter handles the rest (Quadlet setup, deployment strategies).

## Commands

| Command | Subcommands | Description |
|---------|-------------|-------------|
| `lay package` | `install`, `remove`, `search`, `update`, `upgrade`, `list` | Manage system packages via the auto-detected package manager (`--manager` to override) |
| `lay container` | passthrough | Run container commands via docker/podman (podman preferred; `--runtime` to override) |
| `lay binary` | `install`, `remove`, `compile`, `list`, `update` | Install pre-built binaries/JARs or compile from source (`--to`, `--name`) |
| `lay settings` | — | Show lay environment configuration |
| `lay version` | — | Show version |

Global flags: `--json`, `--quiet`, `--verbose`, `--dry-run`.

Per-command sequence diagrams: [lay Commands](lay-commands.md).

```bash
lay package install nginx
lay package --manager dnf install vim
lay container run --rm alpine echo hello
lay binary install sharkdp/fd
lay binary install ~/Downloads/tika-app-3.2.3.jar --name tika
lay binary compile --build-system golang .
```

**Package managers:** auto-detect covers apt, dnf, yum, pacman, zypper, apk, nix, snap, flatpak, brew, choco, scoop, winget; dpkg and rpm are available via `--manager` / `LAY_PACKAGE_MANAGER` only.

**Binary install** accepts GitHub/GitLab/Codeberg shorthand (`owner/repo`), direct URLs, or local JAR files (wrapped in a `java -jar` launcher script). Installed binaries are tracked in a manifest for `list`, `update`, and `remove`. `compile` supports autotools, cargo, cmake, golang, makefile, and meson build systems.

## Package Structure

| Package | Purpose |
|---------|---------|
| `cmd/` | Cobra command definitions and global flags |
| `package_manager/` | Manager interface, detection, per-OS implementations (`linux/`, `macos/`, `windows/`) |
| `binary/` | Binary install pipeline: `forge/`, `install/`, `compile/`, `jar/`, `manifest/`, `checksum/`, `target/` |
| `container/` | Runtime detection and passthrough (`docker/`, `podman/`) |
| `output/` | Output writer (normal/JSON/quiet/verbose modes) |
| `entity/` | Empty stub — reserved for entity intake (see Planned) |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryFramework | CLI framework (root command, version) |
| spf13/cobra | Command-line parsing |
| olekukonko/tablewriter | Table output (`settings`, `list`) |
| ulikunitz/xz | xz archive extraction for binary installs |

## Pipeline Position

lay sits **after raise** (infrastructure provisioning). For containers, its output (image reference entity) will feed into waiter for deployment.

```
hery → doorman → raise → [lay] → enjoin → weaver → waiter
                           │
                    pull/build container image
                    install packages/binaries/JARs
```

## Responsibility Split with waiter

| Concern | Tool |
|---------|------|
| Pull container image | **lay** |
| Build container image | **lay** |
| Install system packages | **lay** |
| Install binaries and JAR applications | **lay** |
| Deploy with strategy | **waiter** |

lay's scope is **installation only** — configuring what gets installed (users, services, cron, system state) is [enjoin](enjoin.md)'s job.

## Planned

The entity-driven mode of lay is designed but not yet built. In this design, lay consumes HERY entities via `-f` (e.g. `lay install -f app.hery && waiter deploy -f app.hery`) and routes them to lay-* plugins:

| Entity | What lay Would Do |
|--------|-------------------|
| [Package](../entities/package.md) | Install packages via the appropriate package manager |
| [Application](../entities/application.md) | Install applications, JAR files, and container images |
| [ProgrammingLanguage](../entities/programming-language.md) | Install language runtimes and version managers |
| [Container](../entities/container.md) | Pull or build container images |

The scope split holds in both modes: lay handles installation of these three entity families only, while enjoin handles system state (User, Service, Cron, System/\*, Security/\*). When pulling or building container images, lay would output an entity with the image reference that waiter can consume.

## Current Gaps

- No entity intake: no top-level `lay install`, no `-f` flag, no HERY support (`entity/` is an empty stub)
- No lay-* plugin discovery or plugin system
- No `info` command and no `--hery` envelope flag (plugin-protocol conformance pending)

## Current Status

- 43 packages, all tests passing
- Idiomatic Go names
- Full `package`/`container`/`binary` command tree with dry-run support
- JAR application support (`binary/jar/`) and `--name` flag for targeted installation
