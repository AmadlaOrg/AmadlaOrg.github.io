# Application/CICD/JenkinsAgent

| Field | Value |
|-------|-------|
| **Purpose** | Jenkins Agent-specific configuration — distributed build agent connecting to a Jenkins master |
| **Repo** | [AmadlaOrg/Entities/Application/CICD/JenkinsAgent](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/cicd/jenkins-agent@v1.0.0` |
| **Parent type** | [Application/CICD](application-cicd.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `master_url` | string | Jenkins master URL |
| `agent_name` | string | Name of the Jenkins agent |
| `secret_secret` | string | Doorman secret reference for agent authentication secret |
| `labels` | array of strings | Labels assigned to this agent for job matching |
| `executors` | integer | Number of executors (concurrent build slots) |
| `remote_root_dir` | string | Root directory on the agent for builds |
| `jnlp_url` | string | JNLP connection URL for agent communication |

## Example

```yaml
_type: amadla.org/entity/application/cicd/jenkins-agent@v1.0.0
_extends: amadla.org/entity/application/cicd@v1.0.0
_body:
  server_url: https://jenkins.example.com
  token_secret: doorman://vault/jenkins/agent-token
  master_url: https://jenkins.example.com
  agent_name: build-agent-01
  secret_secret: doorman://vault/jenkins/agent-secret
  labels:
    - linux
    - java
    - maven
  executors: 2
  remote_root_dir: /var/lib/jenkins/agent
  jnlp_url: https://jenkins.example.com/computer/build-agent-01/slave-agent.jnlp
```

## Consumers

| Tool | How It Uses Application/CICD/JenkinsAgent |
|------|-------------------------------------------|
| lay | Installs the Jenkins agent JAR |
| weaver | Generates agent launch configuration |
| enjoin-service | Enables/starts the Jenkins agent service |
