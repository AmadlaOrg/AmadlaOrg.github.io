# Application/CICD

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all CI/CD runner applications |
| **Repo** | [AmadlaOrg/Entities/Application/CICD](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/cicd@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `server_url` | string | CI/CD server URL to connect to |
| `token_secret` | string | Doorman secret reference for registration token |
| `tags` | array of strings | Runner tags or labels for job matching |
| `concurrent` | integer | Maximum number of concurrent jobs |
| `work_dir` | string | Working directory for job execution |

These properties are common across all CI/CD runner implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application | Status |
|----------|-------------|--------|
| [CICD/GitLabRunner](application-cicd-gitlab-runner.md) | GitLab Runner — multi-executor CI/CD runner | Most common |
| [CICD/JenkinsAgent](application-cicd-jenkins-agent.md) | Jenkins Agent — distributed build agent | Enterprise |
| [CICD/DroneRunner](application-cicd-drone-runner.md) | Drone Runner — container-native CI runner | Lightweight |
| [CICD/BuildkiteAgent](application-cicd-buildkite-agent.md) | Buildkite Agent — hybrid CI/CD agent | Cloud-hybrid |

## Example

```yaml
_type: amadla.org/entity/application/cicd@v1.0.0
_body:
  server_url: https://ci.example.com
  token_secret: doorman://vault/cicd/registration-token
  tags:
    - linux
    - docker
  concurrent: 4
  work_dir: /var/lib/ci/builds
```

## Consumers

| Tool | How It Uses Application/CICD |
|------|------------------------------|
| lay | Installs the CI/CD runner application |
| enjoin-service | Enables/starts the runner service |
| weaver | Generates runner configuration files |
