# lighthouse

| Field | Value |
|-------|-------|
| **Purpose** | Notification and alerting tool — sends notifications via plugins |
| **Module** | — |
| **Status** | Planned |
| **Repo** | [AmadlaOrg/lighthouse](https://github.com/AmadlaOrg/lighthouse) |

## Overview

lighthouse grabs information from any tool's entity output and sends notifications via plugins. Common use: pipe judge audit results to lighthouse for alerting on drift or compliance failures.

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `lighthouse notify` | Planned | Send notification based on input entity data |
| `lighthouse settings` | Planned | Manage lighthouse configuration |

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

| Plugin | Channel | Status |
|--------|---------|--------|
| lighthouse-webhook | Webhook (HTTP POST) | Planned |
| lighthouse-webrtc | WebRTC | Planned |
| lighthouse-twilio | Twilio SMS | Planned |
| lighthouse-ses | AWS SES (email) | Planned |
| lighthouse-rest | RESTful API calls | Planned |

## Intended Design

- Receives entity data via UNIX pipe (standard input)
- Plugin system for different notification channels
- Entity-aware: can extract relevant fields from any entity type for notification content

## Current Gaps

- Concept stage — no repository or code yet
- Plugin framework integration not yet designed
