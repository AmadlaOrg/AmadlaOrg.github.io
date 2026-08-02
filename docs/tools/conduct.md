# conduct

| Field | Value |
|-------|-------|
| **Purpose** | Multi-server orchestrator — runs Amadla tools across distributed nodes in dependency order |
| **Repo** | [AmadlaOrg/conduct](https://github.com/AmadlaOrg/conduct) |

## Overview

conduct is like a conductor — each server plays a different part. Not all servers are equal; conduct supports heterogeneous node roles: it reads a topology file describing which servers exist and what each one runs, then executes the assigned tools on each node over SSH in dependency order.

On a single server, Podman (rootless, Quadlet) with systemd handles container restarts. conduct handles what happens when you have multiple servers.

Per-command sequence diagrams: [conduct Commands](conduct-commands.md).

## Commands

| Command | Description |
|---------|-------------|
| `conduct deploy -f <topology>` | Parse a topology file (YAML or JSON, `-` for stdin), build an execution plan, and run each node's tools sequentially over SSH in topological order. `--dry-run` prints the plan without executing |
| `conduct status [deployment]` | List all deployments, or show per-node status for one |
| `conduct exec <deployment> <node> -- <command...>` | Run an arbitrary command on a node via SSH |
| `conduct destroy <deployment>` | Remove the local deployment record only — does **not** tear anything down on the remote nodes |

## Dependencies

| Library | Purpose |
|---------|---------|
| spf13/cobra | CLI framework |
| olekukonko/tablewriter | Status table output |
| gopkg.in/yaml.v3 | Topology parsing |

## Pipeline Position

conduct sits **outside the main pipeline** — it **coordinates** the pipeline across multiple servers.

```
Server A ─── lay + waiter (web tier)
Server B ─── lay + waiter (app tier)      ← conduct coordinates
Server C ─── lay + waiter (database tier)
```

## How It Works

`conduct deploy` runs in three stages:

1. **Topology** — parses and validates the topology file (unique node names, valid `depends_on` references, no self-dependencies), defaulting `user` to `root` and `port` to `22`.
2. **Plan** — topologically sorts nodes by `depends_on` (rejecting cycles) and flattens each node's roles into one ordered step per role. Node `vars` are interpolated: `{{ node-name.host }}` resolves to that node's host.
3. **Execute** — for each step in order, shells out to the system `ssh` client and runs the role's tool on the node (`vars` are exported as environment variables first). Any non-zero exit stops the deployment.

Deployment state is written to `~/.local/share/conduct/<name>.json` — deployment status plus per-node name, host, and status (`pending`/`ready`/`failed`). This record is what `status`, `exec`, and `destroy` operate on.

### Topology Example

```yaml
name: webapp
nodes:
  - name: db
    host: 10.0.0.10
    user: admin                  # optional, defaults to root
    port: 22                     # optional, defaults to 22
    key: /home/me/.ssh/id_ed25519  # optional SSH identity file
    roles:
      - tool: lay
        args: ["up", "-f", "postgres.hery"]
  - name: web
    host: 10.0.0.11
    depends_on: [db]
    vars:
      DB_HOST: "{{ db.host }}"   # interpolated, exported as env var on the node
    roles:
      - tool: waiter
        args: ["deploy", "-f", "webapp.yaml"]
```

### Example Usage

```bash
# Preview the execution plan
conduct deploy -f cluster.yaml --dry-run

# Deploy across the cluster (sequential, dependency order)
conduct deploy -f cluster.yaml

# Check status of all deployments, then one in detail
conduct status
conduct status webapp

# Run a command on one node
conduct exec webapp db -- systemctl status postgresql

# Forget the deployment (local record only)
conduct destroy webapp
```

## Encouraged Infrastructure

- **Podman** (rootless, Quadlet) — single-server container management via systemd
- **HAProxy** — load balancing and traffic management
- **systemd** — restarts failed containers on a single server
- **conduct** — coordinates across servers when scaling beyond one

## Current Gaps

- Execution is strictly sequential — independent branches of the dependency graph do not run in parallel
- `exec` always connects as `root@host:22` with no key — the topology's per-node `user`/`port`/`key` are not persisted into state
- `destroy` only deletes the local state file; there is no remote teardown
- SSH runs with `StrictHostKeyChecking=no` and a null known-hosts file — no host-key verification
- `roles[].entities` (entity type/file references) are parsed but unused — plans are built from `tool` + `args` only
- Cross-node value injection is limited to `{{ node-name.host }}` — one node's outputs cannot flow into another

## Planned

- **Cross-node value injection** — conduct is the architectural home for passing values between nodes (e.g. a database node's generated credentials into an app node's config), beyond the current host-only interpolation
- **Pipeline driving** — routing full `raise` → `lay` → `enjoin` → `weaver` → `waiter` runs per node from entity types, rather than explicit tool/args
- **Parallel execution** of independent dependency-graph branches
- **Topology as a HERY entity** — validated schema instead of a free-standing YAML file
- Replica management, failover, and cluster-wide health checking
