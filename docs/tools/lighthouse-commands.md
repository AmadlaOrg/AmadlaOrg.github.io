# lighthouse Commands

Sequence diagrams for each `lighthouse` subcommand — the C4 dynamics level
of the [lighthouse architecture](lighthouse.md). Participants are the
internal components of the tool: `cmd/` (Cobra commands), `alert/`
(parsing and fingerprinting), `config/` (YAML config loading), `engine/`
(the suppression pipeline), `state/` (JSON state persistence under
`~/.local/share/lighthouse/`), and `plugin/` (PATH discovery and
subprocess execution) — plus the externals they talk to: the filesystem,
stdin, and `lighthouse-*` notification plugin subprocesses.

## lighthouse notify

Reads one alert (JSON or YAML; `-f -` for stdin) and runs it through the
suppression pipeline: silence → flap detection → dedup → backoff → rate
limit → grouping, with delivery via `lighthouse-* send` subprocesses as the
fall-through. The result is a JSON object on stdout whose `action` names
the branch taken (`silenced`, `flapping`, `deduplicated`, `suppressed`,
`rate_limited`, `grouped`, `delivered`, `delivery_failed`). Every `notify`
run also flushes any group buffers past their `group_wait` deadline, so a
grouped alert is only delivered by a *later* `notify` invocation — with no
follow-up traffic a buffered group stays undelivered. An unreadable `-f`
file exits 2; parse and processing errors exit 1. Note that with the
default `group_wait` of 30s, a brand-new alert is always buffered rather
than delivered immediately, and the rate-limit check is skipped for
first-time alerts.

![lighthouse notify](../diagrams/out/seq-lighthouse-notify.svg#only-light)
![lighthouse notify](../diagrams/out/seq-lighthouse-notify-dark.svg#only-dark)

## lighthouse resolve

Same input handling as `notify`, but the alert's status is forced to
`resolved` before processing. The resolved path bypasses the entire
suppression chain — no silence, dedup, backoff, rate-limit, or grouping
checks — and always attempts delivery. A known fingerprint has its state
updated (status, transition timestamp); an unknown fingerprint still gets
a resolution notification from a synthesized one-shot state that is not
persisted. Resolve does not flush pending group buffers. Exit codes match
`notify` (2 for unreadable file, 1 otherwise).

![lighthouse resolve](../diagrams/out/seq-lighthouse-resolve.svg#only-light)
![lighthouse resolve](../diagrams/out/seq-lighthouse-resolve-dark.svg#only-dark)

## lighthouse silence

Appends a silence rule for an alert fingerprint to `silences.json` and
prints a JSON confirmation. `--for` takes a Go duration (default `1h`),
`--reason` is free text. The fingerprint is not validated against stored
alerts, duplicate silences for the same fingerprint accumulate, and
expired silences are never pruned from the file — the engine simply
ignores them once `expires_at` has passed. An unparsable `--for` duration
exits 1.

![lighthouse silence](../diagrams/out/seq-lighthouse-silence.svg#only-light)
![lighthouse silence](../diagrams/out/seq-lighthouse-silence-dark.svg#only-dark)

## lighthouse status

Renders two tables from the state files: stored alerts (fingerprint
truncated to 12 chars, source, name, severity, status, count, last seen)
and silences. When both files are empty or absent it prints "No active
alerts or silences." on stderr and exits 0. The tables are labeled
"Active" but are not filtered: resolved alerts and expired silences remain
listed because state entries are never pruned.

![lighthouse status](../diagrams/out/seq-lighthouse-status.svg#only-light)
![lighthouse status](../diagrams/out/seq-lighthouse-status-dark.svg#only-dark)

## lighthouse plugins

Scans every `PATH` directory for executable `lighthouse-*` binaries, then
runs `<plugin> info -o json` on each — accepting both flat JSON and a
HERY envelope (`_type`/`_body`) — and renders plugin, channel, version,
and description. `-o table|json|yaml` selects the format and `--hery`
wraps the rows in a HERY envelope. A plugin whose `info` call fails still
appears, with `?` placeholders and the error in its description; finding
no plugins at all prints a notice on stderr and exits 0.

![lighthouse plugins](../diagrams/out/seq-lighthouse-plugins.svg#only-light)
![lighthouse plugins](../diagrams/out/seq-lighthouse-plugins-dark.svg#only-dark)
