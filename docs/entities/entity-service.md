# EntityService

| Field | Value |
|-------|-------|
| **Purpose** | Defines system service configuration — systemd units, service state, and dependencies |
| **Repo** | [AmadlaOrg/Entities/Service](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/service@v1.0.0` |

## Schema

EntityService describes system service requirements:

- Service name and desired state (started/stopped/restarted/reloaded)
- Boot enablement and masking
- ExecStart/ExecStop/ExecReload overrides
- Working directory, user, and group
- Environment variables and environment file
- Restart policy (no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, always)
- Restart delay and timeout settings
- File descriptor limits
- Systemd ordering: After, Wants, Requires

## Example

```yaml
_type: amadla.org/entity/service@v1.0.0
_body:
  name: my-app
  state: started
  enabled: true
  exec_start: /usr/local/bin/my-app --config /etc/my-app/config.yaml
  user: my-app
  group: my-app
  working_directory: /opt/my-app
  environment:
    NODE_ENV: production
    PORT: "3000"
  restart: on-failure
  restart_sec: 5
  limit_nofile: 65535
  after:
    - network.target
    - postgresql.service
  wants:
    - network-online.target
```

## Consumers

| Tool | How It Uses EntityService |
|------|--------------------------|
| lay | Creates/manages systemd service units |
| weaver | Generates service unit files from templates |
| judge | Validates that services are in the expected state |
