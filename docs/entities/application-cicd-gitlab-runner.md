# Application/CICD/GitLabRunner

| Field | Value |
|-------|-------|
| **Purpose** | GitLab Runner-specific configuration — multi-executor CI/CD runner for GitLab |
| **Repo** | [AmadlaOrg/Entities/Application/CICD/GitLabRunner](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/cicd/gitlab-runner@v1.0.0` |
| **Parent type** | [Application/CICD](application-cicd.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `executor` | string | Executor type: `shell`, `docker`, `docker+machine`, `kubernetes`, `virtualbox`, or `parallels` |
| `docker_image` | string | Default Docker image for jobs |
| `docker_volumes` | array of strings | Docker volumes to mount in job containers |
| `docker_privileged` | boolean | Whether to run Docker containers in privileged mode |
| `cache.type` | string | Cache storage type: `local`, `s3`, or `gcs` |
| `cache.path` | string | Cache path |
| `cache.shared` | boolean | Whether cache is shared between runners |
| `cache.s3.server_address` | string | S3 server address |
| `cache.s3.bucket` | string | S3 bucket name |
| `cache.s3.access_key` | string | S3 access key |
| `cache.s3.secret_key_secret` | string | Doorman secret reference for S3 secret key |
| `environment` | array of strings | Environment variables for build jobs |

## Example

```yaml
_type: amadla.org/entity/application/cicd/gitlab-runner@v1.0.0
_extends: amadla.org/entity/application/cicd@v1.0.0
_body:
  server_url: https://gitlab.example.com
  token_secret: doorman://vault/gitlab-runner/registration-token
  tags:
    - docker
    - linux
  concurrent: 4
  executor: docker
  docker_image: alpine:latest
  docker_volumes:
    - /var/run/docker.sock:/var/run/docker.sock
    - /cache:/cache
  docker_privileged: false
  cache:
    type: s3
    shared: true
    s3:
      server_address: minio.example.com:9000
      bucket: runner-cache
      access_key: minio-access
      secret_key_secret: doorman://vault/gitlab-runner/s3-secret
  environment:
    - DOCKER_TLS_CERTDIR=
```

## Consumers

| Tool | How It Uses Application/CICD/GitLabRunner |
|------|-------------------------------------------|
| lay | Installs the `gitlab-runner` package |
| weaver | Generates `config.toml` |
| enjoin-service | Enables/starts the `gitlab-runner` service |
