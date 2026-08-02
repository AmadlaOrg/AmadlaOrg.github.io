# waiter

| Field | Value |
|-------|-------|
| **Purpose** | Deployment tool — manages deployment strategies (blue-green, canary, rolling, restart) |
| **Repo** | [AmadlaOrg/waiter](https://github.com/AmadlaOrg/waiter) |

## Overview

waiter handles the deployment lifecycle: deploying new versions alongside old ones, health checking, traffic shifting, rollback, and cleanup. It consumes Container entities (JSON or YAML, file or stdin) — typically image references produced by lay and config rendered by weaver — and coordinates two kinds of plugins to execute a strategy.

Inspired by [kamal-deploy.org](https://kamal-deploy.org/) and the VFRMate infra scripts.

Per-command sequence diagrams: [waiter Commands](waiter-commands.md).

## Commands

| Command | Description |
|---------|-------------|
| `waiter deploy -f <file\|-> --strategy <strategy>` | Deploy an entity with a strategy (`--engine`, `--proxy`, `--name`, `--canary-weight`, `--drain-timeout`, `--health-timeout`) |
| `waiter promote <service>` | Promote a canary deployment to full traffic |
| `waiter abort <service>` | Abort a canary deployment |
| `waiter rollback <service>` | Roll back to the previous version |
| `waiter status [service]` | Show deployment state for one service or all |
| `waiter reconcile [service] [--fix]` | Detect drift between saved state and reality, optionally fix it |
| `waiter plugins` | List discovered waiter-* plugins (`-o table\|json\|yaml`, `--hery`) |

## Two-Axis Plugin Model

Every deployment coordinates two independent plugin axes, discovered as `waiter-*` binaries on PATH (names auto-prefixed with `waiter-`; auto-detected when exactly one plugin of a type is installed, otherwise `--engine`/`--proxy` is required):

**Engine plugins** (type `engine`) — run containers/services:

| Plugin | Platform |
|--------|----------|
| waiter-podman | Podman |
| waiter-docker | Docker |
| waiter-quadlet | Podman Quadlet units |
| waiter-systemd | systemd services |

**Proxy plugins** (type `proxy`) — manage traffic (register, shift, drain, remove backends):

| Plugin | Proxy |
|--------|-------|
| waiter-proxy-haproxy | HAProxy |
| waiter-proxy-kamal | kamal-proxy |

An engine plugin never touches traffic and a proxy plugin never touches containers — e.g. waiter-podman does **not** include HAProxy handling; pair it with waiter-proxy-haproxy.

## Deployment Strategies

| Strategy | Description |
|----------|-------------|
| **blue-green** | Deploy new version into the free slot, health check, switch traffic, drain and stop old |
| **canary** | Deploy alongside an existing deployment at `--canary-weight` (default 10/256), then `promote` or `abort` |
| **rolling** | Replace the running instance with drain-before-stop |
| **restart** | Stop old, deploy new, register (no zero-downtime) |

Slots use fixed ports: blue `8081`, green `8082`, canary `8083`. Per-service state is stored as JSON in `~/.local/share/waiter/<service>.json` (current/previous/canary slots, strategy, plugins).

## Dependencies

waiter is a standalone Go module — plugin discovery, state, health checking, and strategies are implemented in-repo (`plugin/`, `state/`, `health/`, `strategy/`). External deps: Cobra (CLI), tablewriter, yaml.v3.

## Pipeline Position

waiter sits **after lay and weaver**. lay pulls/builds the container image, weaver generates the config files (Quadlet, etc.), waiter deploys.

```bash
hery query --type '*/application@*' | doorman resolve | weaver render --template quadlet | waiter deploy -f - --strategy canary
```

```
lay pull → (image ref entity) → waiter deploy
weaver render → (Quadlet files) → waiter deploy
```

## Responsibility Split with lay and weaver

| Concern | Tool |
|---------|------|
| Pull container image | **lay** |
| Build container image | **lay** |
| Generate Quadlet unit file | **weaver** |
| Deploy with strategy | **waiter** (engine plugin) |
| Traffic shifting | **waiter** (proxy plugin) |
| Health checking | **waiter** |
| Rollback deployment | **waiter** |

## Example Usage

```bash
# Canary deployment (requires an existing deployment)
waiter deploy -f my-app.hery --strategy canary --canary-weight 5
waiter promote my-app

# Blue-green deployment, explicit plugins, entity from stdin
cat my-app.hery | waiter deploy -f - --strategy blue-green --engine podman --proxy proxy-haproxy

# Rollback
waiter rollback my-app

# Abort canary
waiter abort my-app

# Inspect
waiter status my-app
waiter reconcile --fix
waiter plugins -o json
```

## Current Gaps

- rolling is effectively single-instance — it behaves like blue-green at full weight; true instance-by-instance replacement is not implemented
- restart stops the old container before deploying; if the new container fails its health check, the old one is not restored (service stays down)
- promote hard-sets the service's strategy to blue-green in state, regardless of the original strategy
- deploy defines `-o/--output` but ignores it — output is always JSON (only `plugins` honors `-o`)
