# Application/CICD/BuildkiteAgent

| Field | Value |
|-------|-------|
| **Purpose** | Buildkite Agent-specific configuration — hybrid CI/CD agent running on your infrastructure |
| **Repo** | [AmadlaOrg/Entities/Application/CICD/BuildkiteAgent](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/cicd/buildkite-agent@v1.0.0` |
| **Parent type** | [Application/CICD](application-cicd.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `token_secret` | string | Doorman secret reference for agent registration token |
| `name` | string | Agent name template (supports `%hostname`, `%n`) |
| `priority` | integer | Agent priority for job assignment (higher = preferred) |
| `spawn` | integer | Number of parallel agent processes to spawn |
| `build_path` | string | Directory for build checkouts |
| `hooks_path` | string | Directory for agent hook scripts |
| `plugins_path` | string | Directory for Buildkite plugins |
| `experiment` | array of strings | Experimental features to enable |

## Example

```yaml
_type: amadla.org/entity/application/cicd/buildkite-agent@v1.0.0
_extends: amadla.org/entity/application/cicd@v1.0.0
_body:
  server_url: https://agent.buildkite.com/v3
  token_secret: doorman://vault/buildkite/agent-token
  tags:
    - queue=default
    - os=linux
  name: "%hostname-%n"
  priority: 1
  spawn: 3
  build_path: /var/lib/buildkite-agent/builds
  hooks_path: /etc/buildkite-agent/hooks
  plugins_path: /etc/buildkite-agent/plugins
  experiment:
    - normalised-upload-paths
```

## Consumers

| Tool | How It Uses Application/CICD/BuildkiteAgent |
|------|----------------------------------------------|
| [lay](../tools/lay.md) | Installs the `buildkite-agent` package |
| [weaver](../tools/weaver.md) | Generates `buildkite-agent.cfg` |
| enjoin-service | Enables/starts the `buildkite-agent` service |
