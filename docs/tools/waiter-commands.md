# waiter Commands

Sequence diagrams for each `waiter` subcommand — the C4 dynamics level of the
[waiter architecture](waiter.md). Participants are waiter's internal packages:
`cmd/` (Cobra commands), `strategy/` (blue-green, canary, rolling, restart),
`plugin/` (PATH discovery and subprocess execution), `state/` (per-service
JSON state files in `~/.local/share/waiter/`), and `health/` (status polling)
— plus the externals they talk to: engine plugin subprocesses
(`waiter-podman`, `waiter-docker`, `waiter-quadlet`, `waiter-systemd`), proxy
plugin subprocesses (`waiter-proxy-haproxy`, `waiter-proxy-kamal`), the
filesystem, and stdin.

## waiter deploy

Deploys a service from a container entity (`-f` file or `-` for stdin,
required) using `--strategy` blue-green (default), canary, rolling, or
restart. Engine and proxy plugins are named via `--engine`/`--proxy`
(auto-prefixed `waiter-`) or auto-detected from PATH — auto-detection fails
if zero or more than one plugin of that type is installed. Slots use fixed
ports: blue 8081, green 8082, canary 8083. Unreadable input exits 2; all
other failures exit 1. A failed health check stops the new container and
leaves the old one serving. The `-o/--output` flag is accepted but ignored —
the result is always indented JSON (a known gap). Rolling is currently
single-instance and behaves like blue-green except the new slot registers
directly at full weight; restart stops the old container before deploying,
so a failed restart deployment leaves the service down.

![waiter deploy](../diagrams/out/seq-waiter-deploy.svg#only-light)
![waiter deploy](../diagrams/out/seq-waiter-deploy-dark.svg#only-dark)

## waiter promote

Promotes an in-progress canary to full traffic: shifts the canary to weight
256, drains and removes the old slot (`--drain-timeout`, default 30s), stops
the old container, and re-registers the canary under the free blue/green
slot name. Only the initial shift-to-canary is error-checked — every later
plugin call is best-effort. The saved state's strategy is overwritten to
`blue-green` regardless of how the service was originally deployed. Exits 1
if the service has no state or no canary in progress.

![waiter promote](../diagrams/out/seq-waiter-promote.svg#only-light)
![waiter promote](../diagrams/out/seq-waiter-promote-dark.svg#only-dark)

## waiter abort

Cancels an in-progress canary: removes `<service>-canary` from the proxy,
stops the canary container (both best-effort — plugin failures are ignored),
and clears the canary slot from the state file. Prints a confirmation on
stderr and the updated state as JSON on stdout. Exits 1 if the service has
no state or no canary in progress.

![waiter abort](../diagrams/out/seq-waiter-abort.svg#only-light)
![waiter abort](../diagrams/out/seq-waiter-abort-dark.svg#only-dark)

## waiter rollback

Restores the previous deployment slot: starts the previous container, waits
for it to become healthy (`--health-timeout`, default 60s), registers it
with the proxy at full weight, then drains and stops the current slot
(`--drain-timeout`, default 30s) and swaps Current/Previous in the state
file. Start, health check, and proxy register are error-checked and exit 1
on failure — with no attempt to undo a partial rollback; the teardown of the
old current slot is best-effort. Requires a recorded Previous slot.

![waiter rollback](../diagrams/out/seq-waiter-rollback.svg#only-light)
![waiter rollback](../diagrams/out/seq-waiter-rollback-dark.svg#only-dark)

## waiter status

Reads deployment state only — no plugins are invoked, so it reports what
waiter last recorded, not live container status (use `reconcile` for that).
With a service argument it prints that service's state as JSON; without, it
lists every `*.json` in the state directory (unparsable files are silently
skipped). An empty state directory prints "No managed services found." on
stderr and exits 0; an unknown named service exits 1.

![waiter status](../diagrams/out/seq-waiter-status.svg#only-light)
![waiter status](../diagrams/out/seq-waiter-status-dark.svg#only-dark)

## waiter reconcile

Compares recorded state against reality: asks the engine plugin for the
current container's status and the proxy plugin for backend health, and
reports `ok`, `drifted`, or `fixed` per service — or `error` when a
service's plugin calls fail (one service, or all when run bare). `--fix`
only repairs container drift by starting the container —
proxy drift is reported but never fixed, and in the "container exists but
not running" branch the status is marked `fixed` without re-verifying
health. In all-services mode a failing service becomes a `status: "error"`
entry in the JSON array and the command still exits 0.

![waiter reconcile](../diagrams/out/seq-waiter-reconcile.svg#only-light)
![waiter reconcile](../diagrams/out/seq-waiter-reconcile-dark.svg#only-dark)

## waiter plugins

Scans every PATH directory for executable `waiter-*` binaries, then runs
`<plugin> info -o json` on each to collect type (engine or proxy), engine,
version, and description — accepting both flat JSON and HERY-enveloped
responses. Output is a table by default, or JSON/YAML via `-o`, optionally
wrapped in a HERY envelope with `--hery`; a plugin whose info call fails
still appears, with `?` fields. No plugins installed prints a notice on
stderr and exits 0.

![waiter plugins](../diagrams/out/seq-waiter-plugins.svg#only-light)
![waiter plugins](../diagrams/out/seq-waiter-plugins-dark.svg#only-dark)
