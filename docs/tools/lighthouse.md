# lighthouse

| Field | Value |
|-------|-------|
| **Purpose** | Notification and alerting tool — sends notifications via plugins |
| **Repo** | [AmadlaOrg/lighthouse](https://github.com/AmadlaOrg/lighthouse) |

## Overview

lighthouse receives alerts from any tool's output and sends notifications via plugins. It runs every alert through an intelligent suppression pipeline (silencing, flap detection, deduplication, backoff, rate limiting, grouping) to prevent notification storms. Common use: pipe judge audit results to lighthouse for alerting on drift or compliance failures.

## Commands

| Command | Description |
|---------|-------------|
| `lighthouse notify` | Process an incoming alert through the suppression pipeline |
| `lighthouse resolve` | Send a resolution notification for an alert |
| `lighthouse silence` | Silence an alert by fingerprint for a duration |
| `lighthouse status` | Show stored alerts and silences |
| `lighthouse plugins` | List discovered lighthouse-* plugins |

Per-command sequence diagrams: [lighthouse Commands](lighthouse-commands.md).

## Dependencies

| Library | Purpose |
|---------|---------|
| spf13/cobra | CLI framework |
| olekukonko/tablewriter | Table output for `status` and `plugins` |
| gopkg.in/yaml.v3 | Config and alert parsing (YAML) |

Plugin discovery and execution are built in: lighthouse scans `PATH` for `lighthouse-*` binaries and invokes them via the standard plugin protocol (`info`, `send`).

## Pipeline Position

lighthouse sits **at the end of any pipeline** — it receives alert output and sends notifications.

```bash
unravel discover | judge audit | lighthouse notify -f -
waiter deploy --strategy canary my-app img:v2 | lighthouse notify -f -
```

## Plugins

Each plugin integrates lighthouse with a notification channel:

| Plugin | Channel |
|--------|---------|
| lighthouse-webhook | Webhook (HTTP POST) |
| lighthouse-slack | Slack (incoming webhooks) |
| lighthouse-email | Email (SMTP) |
| lighthouse-sms | SMS (Twilio) |
| lighthouse-webrtc | WebRTC (signaling server relay) |

Channel selection is **config-driven**, not a CLI flag. Channels are listed in `~/.config/lighthouse/config.yaml`; lighthouse tries them in order until one delivers:

```yaml
channels:
  - plugin: lighthouse-slack
    max_per_hour: 60
  - plugin: lighthouse-email
    max_per_hour: 20
```

With no channels configured, lighthouse falls back to trying every discovered `lighthouse-*` plugin on `PATH`.

## How It Works

lighthouse reads an alert (JSON or YAML) from a file or stdin, fingerprints it (SHA-256 of source, name, and sorted labels), and runs it through the suppression pipeline before delivering via a plugin:

```
Alert (stdin/file) → lighthouse notify → suppression pipeline → lighthouse-* plugin → Notification sent
```

The pipeline stages, in order:

1. **Resolved handling** — a `status: resolved` alert updates state and sends a resolution notification
2. **Silencing** — suppressed if an active silence matches the fingerprint
3. **Flap detection** — suppressed if the alert transitioned too often within the window (default 5 in 1h)
4. **Deduplication** — repeat of the same alert within the dedup window (default 5m) increments a counter, no notification
5. **Backoff** — repeats are suppressed until the exponential backoff deadline (default 5m initial, ×3, 24h max)
6. **Rate limiting** — suppressed when all channels have exhausted their `max_per_hour` token budget
7. **Grouping** — alerts are buffered per source+name group and flushed together after `group_wait` (default 30s)

State is file-based JSON under `~/.local/share/lighthouse/`: `alerts.json`, `silences.json`, `groups.json`, and `rate_limits.json`. Tuning lives in `~/.config/lighthouse/config.yaml` (`dedup_window`, `group_wait`, `backoff`, `flap_detection`, `channels`).

### Use Cases

- **Drift alerting:** Pipe [judge](judge.md) audit results to lighthouse — get notified when system state diverges from expected
- **Deployment notifications:** Pipe [waiter](waiter.md) deploy output to Slack/email
- **Health monitoring:** Combine with [unravel](unravel.md) on a cron schedule to monitor system state

### Example Usage

```bash
# Alert on drift (channel chosen from config.yaml)
unravel discover | judge audit | lighthouse notify -f -

# Send an alert from a file
lighthouse notify -f alert.yaml

# Resolve an alert
lighthouse resolve -f alert.yaml

# Silence a noisy alert during maintenance
lighthouse silence 3f2a9c1b0d4e --for 2h --reason "maintenance"

# Inspect stored alerts and silences
lighthouse status
```

## Current Gaps

- **No daemon or timer** — lighthouse is a one-shot CLI. Grouped alerts are only flushed by a *later* `notify` run, so a one-off alert buffered with the default `group_wait` (30s) can sit undelivered until something else fires
- **Re-firing alerts keep status `resolved`** — when a previously resolved alert fires again, its stored status is not reset to `firing` and no transition is recorded, which weakens flap detection
- **`group_interval` and `repeat_interval`** are parsed from config with defaults but are not used by the engine
- **No pruning** — resolved alerts and expired silences accumulate in the state files and are never cleaned up

## Planned

- A daemon or timer mode so group buffers flush on schedule instead of piggybacking on the next `notify` run
- Pruning of resolved alerts and expired silences from state
- Wiring `group_interval` / `repeat_interval` into the engine for periodic re-notification
