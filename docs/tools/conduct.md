# conduct

| Field | Value |
|-------|-------|
| **Purpose** | Multi-server orchestrator — coordinates waiter/lay across distributed nodes |
| **Repo** | [AmadlaOrg/conduct](https://github.com/AmadlaOrg/conduct) |

## Overview

conduct is like a conductor — each server plays a different part. Not all servers are equal; conduct supports heterogeneous node roles and coordinates deployment, installation, and health checking across them.

On a single server, Podman (rootless, Quadlet) with systemd handles container restarts. conduct handles what happens when you have multiple servers.

## Commands

| Command | Description |
|---------|-------------|
| `conduct orchestrate` | Coordinate waiter/lay across nodes based on topology entity |
| `conduct status` | Show cluster-wide status |
| `conduct settings` | Manage conduct configuration |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |

## Pipeline Position

conduct sits **outside the main pipeline** — it **coordinates** the pipeline across multiple servers.

```
Server A ─── lay + waiter (web tier)
Server B ─── lay + waiter (app tier)      ← conduct coordinates
Server C ─── lay + waiter (database tier)
```

## How It Works

conduct reads topology/cluster entities that describe which servers exist, what role each plays, and how they relate. It then coordinates [lay](lay.md) and [waiter](waiter.md) across those nodes — installing software and deploying services in the right order on the right machines.

- Reads topology/cluster entities describing node roles and placement
- Orchestrates [waiter](waiter.md)/[lay](lay.md) across distributed nodes
- Handles role-based placement, replica management, failover
- Supports heterogeneous node roles (not all servers run the same thing)

### Example Usage

```bash
# Deploy across a 3-node cluster
conduct orchestrate -f cluster.yaml

# Check status of all nodes
conduct status

# Deploy only the web tier
conduct orchestrate -f cluster.yaml --role web
```

## Encouraged Infrastructure

- **Podman** (rootless, Quadlet) — single-server container management via systemd
- **HAProxy** — load balancing and traffic management
- **systemd** — restarts failed containers on a single server
- **conduct** — coordinates across servers when scaling beyond one

## Current Gaps

- Concept stage — no repository or code yet
- Topology entity type not yet defined
