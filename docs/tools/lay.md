# lay

| Field | Value |
|-------|-------|
| **Purpose** | Package and application installer — installs packages, applications, JARs, and container images |
| **Repo** | [AmadlaOrg/lay](https://github.com/AmadlaOrg/lay) |

## Overview

lay handles installation: packages via system package managers, applications, JAR files, and container image pull/build. For containers, lay takes care of building and pulling — waiter handles the rest (Quadlet setup, deployment strategies).

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `lay install` | Partial | Install applications from entity requirements |
| `lay settings` | Partial | Manage lay configuration |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |

## Pipeline Position

lay sits **after raise** (infrastructure provisioning). For containers, its output (image reference entity) feeds into waiter for deployment.

```
hery → doorman → raise → [lay] → waiter
                           │
                    pull/build container image
                    install packages/JARs
                    output: image ref entity
```

## Responsibility Split with waiter

| Concern | Tool |
|---------|------|
| Pull container image | **lay** |
| Build container image | **lay** |
| Install system packages | **lay** |
| Install JAR applications | **lay** |
| Deploy with strategy | **waiter** |

## Output

When pulling or building container images, lay outputs an entity with the image reference that waiter can consume:

```bash
lay pull my-app:v2 | waiter deploy --strategy canary
```

## Current Status

- 42 packages, all tests passing
- Idiomatic Go names
- JAR application support (`binary/jar/`)
- `--name` flag for targeted installation
