# lighthouse

| Field | Value |
|-------|-------|
| **Purpose** | Notification and alerting tool — sends notifications via plugins |
| **Repo** | [AmadlaOrg/lighthouse](https://github.com/AmadlaOrg/lighthouse) |

## Overview

lighthouse grabs information from any tool's entity output and sends notifications via plugins. Common use: pipe judge audit results to lighthouse for alerting on drift or compliance failures.

## Commands

| Command | Description |
|---------|-------------|
| `lighthouse notify` | Send notification based on input entity data |
| `lighthouse settings` | Manage lighthouse configuration |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |
| LibraryPluginFramework | Plugin loading and IPC |

## Pipeline Position

lighthouse sits **at the end of any pipeline** — it receives entity output and sends notifications.

```bash
unravel discover | judge audit | lighthouse notify
waiter deploy --strategy canary my-app img:v2 | lighthouse notify
```

## Plugins

Each plugin integrates lighthouse with a notification channel:

| Plugin | Channel |
|--------|---------|
| lighthouse-webhook | Webhook (HTTP POST) |
| lighthouse-webrtc | WebRTC |
| lighthouse-twilio | Twilio SMS |
| lighthouse-ses | AWS SES (email) |
| lighthouse-rest | RESTful API calls |

## How It Works

lighthouse receives entity data via UNIX pipe (standard input), extracts relevant fields, and routes notifications through the appropriate plugin based on configuration.

```
Entity data (stdin) → lighthouse notify → lighthouse-* plugin → Notification sent
```

### Use Cases

- **Drift alerting:** Pipe [judge](judge.md) audit results to lighthouse — get notified when system state diverges from expected
- **Deployment notifications:** Pipe [waiter](waiter.md) deploy output to Slack/email
- **Health monitoring:** Combine with [unravel](unravel.md) on a cron schedule to monitor system state

### Example Usage

```bash
# Alert on drift via webhook
unravel discover | judge audit | lighthouse notify --via webhook

# Notify deployment result via SMS
waiter deploy --strategy canary my-app img:v2 | lighthouse notify --via twilio

# Email daily system audit
unravel discover | judge audit | lighthouse notify --via ses
```

## Current Gaps

- Concept stage — no repository or code yet
- Plugin framework integration not yet designed
