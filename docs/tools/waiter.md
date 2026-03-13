# waiter

| Field | Value |
|-------|-------|
| **Purpose** | Deployment tool — manages deployment strategies (blue-green, canary, rolling) |
| **Module** | — |
| **Status** | Planned |
| **Repo** | [AmadlaOrg/waiter](https://github.com/AmadlaOrg/waiter) |

## Overview

waiter handles the deployment lifecycle: deploying new versions alongside old ones, health checking, traffic shifting, rollback, and cleanup. It consumes container image references from lay and rendered config files from weaver.

Inspired by [kamal-deploy.org](https://kamal-deploy.org/) and the VFRMate infra scripts.

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `waiter deploy --strategy <strategy>` | Planned | Deploy with a specific strategy |
| `waiter promote` | Planned | Promote a canary deployment to full traffic |
| `waiter abort` | Planned | Abort a canary deployment |
| `waiter rollback` | Planned | Roll back to the previous version |
| `waiter settings` | Planned | Manage waiter configuration |

## Deployment Strategies

| Strategy | Description |
|----------|-------------|
| **blue-green** | Deploy new version alongside old, switch traffic atomically |
| **canary** | Route a percentage of traffic to new version, promote or abort |
| **rolling** | Replace instances one at a time |

## Platform Plugins

| Plugin | Platform | Includes |
|--------|----------|----------|
| waiter-podman | Podman (rootless, Quadlet) | HAProxy traffic management |
| waiter-docker | Docker | — |
| waiter-systemd | systemd services | — |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |
| LibraryPluginFramework | Platform plugin loading |

## Pipeline Position

waiter sits **after lay and weaver**. lay pulls/builds the container image, weaver generates the config files (Quadlet, etc.), waiter deploys.

```bash
hery query --type '*/application@*' | doorman resolve | weaver render --template quadlet | waiter deploy --strategy canary
```

```
lay pull → (image ref entity) → waiter deploy
weaver render → (Quadlet files) → waiter deploy
```

## Responsibility Split with lay

| Concern | Tool |
|---------|------|
| Pull container image | **lay** |
| Build container image | **lay** |
| Generate Quadlet unit file | **weaver** |
| Deploy with strategy | **waiter** |
| Traffic shifting (HAProxy) | **waiter** (platform plugin) |
| Health checking | **waiter** |
| Rollback deployment | **waiter** |

## Example Usage

```bash
# Canary deployment
waiter deploy --strategy canary --weight 5 my-app registry.example.com/app:v2.0.0
waiter promote my-app

# Blue-green deployment
waiter deploy --strategy blue-green my-app registry.example.com/app:v2.0.0

# Rollback
waiter rollback my-app

# Abort canary
waiter abort my-app
```

## Current Gaps

- Concept stage — based on VFRMate infra scripts (may be ported to Go)
- Platform plugins not yet implemented
- No Go module definition
