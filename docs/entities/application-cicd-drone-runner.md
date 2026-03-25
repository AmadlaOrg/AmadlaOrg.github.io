# Application/CICD/DroneRunner

| Field | Value |
|-------|-------|
| **Purpose** | Drone Runner-specific configuration — container-native CI runner for Drone CI |
| **Repo** | [AmadlaOrg/Entities/Application/CICD/DroneRunner](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/cicd/drone-runner@v1.0.0` |
| **Parent type** | [Application/CICD](application-cicd.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `protocol` | string | Protocol for connecting to the Drone server: `http` or `https` |
| `host` | string | Drone server host |
| `secret_secret` | string | Doorman secret reference for RPC secret |
| `runner_capacity` | integer | Maximum number of concurrent pipelines |
| `runner_name` | string | Name of this runner instance |
| `runner_env` | object | Environment variables injected into pipeline steps |

## Example

```yaml
_type: amadla.org/entity/application/cicd/drone-runner@v1.0.0
_extends: amadla.org/entity/application/cicd@v1.0.0
_body:
  server_url: https://drone.example.com
  token_secret: doorman://vault/drone/registration-token
  protocol: https
  host: drone.example.com
  secret_secret: doorman://vault/drone/rpc-secret
  runner_capacity: 2
  runner_name: runner-01
  runner_env:
    DRONE_RUNNER_LABELS: "platform:linux/amd64"
```

## Consumers

| Tool | How It Uses Application/CICD/DroneRunner |
|------|------------------------------------------|
| [lay](../tools/lay.md) | Installs the `drone-runner-docker` binary |
| [weaver](../tools/weaver.md) | Generates runner environment configuration |
| enjoin-service | Enables/starts the drone runner service |
