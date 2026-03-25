# Application/GitServer/GitLab

| Field | Value |
|-------|-------|
| **Purpose** | GitLab-specific configuration — full DevOps platform with integrated CI/CD, registry, and Pages |
| **Repo** | [AmadlaOrg/Entities/Application/GitServer/GitLab](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/git-server/gitlab@v1.0.0` |
| **Parent type** | [Application/GitServer](application-git-server.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `external_url` | string | External URL for accessing GitLab |
| `registry_enabled` | boolean | Whether the container registry is enabled |
| `pages_enabled` | boolean | Whether GitLab Pages is enabled |
| `lfs_enabled` | boolean | Whether Git LFS is enabled |
| `smtp.enabled` | boolean | Whether SMTP is enabled |
| `smtp.address` | string | SMTP server address |
| `smtp.port` | integer | SMTP server port |
| `smtp.domain` | string | HELO domain |
| `smtp.user_name` | string | SMTP authentication user |
| `smtp.password_secret` | string | Doorman secret reference for SMTP password |
| `ldap.enabled` | boolean | Whether LDAP is enabled |
| `ldap.host` | string | LDAP server host |
| `ldap.port` | integer | LDAP server port |
| `ldap.base` | string | LDAP base DN |
| `ldap.bind_dn` | string | LDAP bind DN |
| `ldap.password_secret` | string | Doorman secret reference for LDAP bind password |
| `backup.path` | string | Backup storage path |
| `backup.keep_time` | integer | Backup retention time in seconds |
| `monitoring.prometheus_enabled` | boolean | Whether Prometheus metrics are enabled |
| `monitoring.grafana_enabled` | boolean | Whether built-in Grafana is enabled |

## Example

```yaml
_type: amadla.org/entity/application/git-server/gitlab@v1.0.0
_extends: amadla.org/entity/application/git-server@v1.0.0
_body:
  listen_port: 443
  domain: gitlab.example.com
  admin_user: root
  admin_password_secret: doorman://vault/gitlab/admin-password
  data_dir: /var/opt/gitlab/git-data
  external_url: https://gitlab.example.com
  registry_enabled: true
  pages_enabled: true
  lfs_enabled: true
  smtp:
    enabled: true
    address: smtp.example.com
    port: 587
    domain: example.com
    user_name: gitlab@example.com
    password_secret: doorman://vault/gitlab/smtp-password
  ldap:
    enabled: true
    host: ldap.example.com
    port: 636
    base: dc=example,dc=com
    bind_dn: cn=gitlab,ou=services,dc=example,dc=com
    password_secret: doorman://vault/gitlab/ldap-password
  backup:
    path: /var/opt/gitlab/backups
    keep_time: 604800
  monitoring:
    prometheus_enabled: true
    grafana_enabled: false
```

## Consumers

| Tool | How It Uses Application/GitServer/GitLab |
|------|------------------------------------------|
| [lay](../tools/lay.md) | Installs the `gitlab-ce` or `gitlab-ee` package |
| [weaver](../tools/weaver.md) | Generates `gitlab.rb` configuration |
| enjoin-service | Enables/starts GitLab services via `gitlab-ctl` |
