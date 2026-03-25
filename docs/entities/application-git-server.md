# Application/GitServer

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all self-hosted Git server applications |
| **Repo** | [AmadlaOrg/Entities/Application/GitServer](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/git-server@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the Git server listens on |
| `listen_port` | integer | Port the Git server listens on |
| `domain` | string | Server domain name |
| `admin_user` | string | Administrator username |
| `admin_password_secret` | string | Doorman secret reference for administrator password |
| `data_dir` | string | Directory for repository storage |

These properties are common across all Git server implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [GitServer/Gitea](application-git-server-gitea.md) | Gitea — lightweight, self-hosted Git service |
| [GitServer/GitLab](application-git-server-gitlab.md) | GitLab — full DevOps platform with CI/CD |
| [GitServer/Gogs](application-git-server-gogs.md) | Gogs — painless self-hosted Git, minimal footprint |

## Example

```yaml
_type: amadla.org/entity/application/git-server@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 3000
  domain: git.example.com
  admin_user: admin
  admin_password_secret: doorman://vault/git-server/admin-password
  data_dir: /var/lib/git
```

## Consumers

| Tool | How It Uses Application/GitServer |
|------|-----------------------------------|
| [lay](../tools/lay.md) | Installs the Git server application |
| enjoin-service | Enables/starts the Git server service |
| [weaver](../tools/weaver.md) | Generates configuration files |
