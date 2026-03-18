# Infrastructure/Container

| Field | Value |
|-------|-------|
| **Purpose** | Defines container runtime infrastructure — runtime engine, image building, registry access |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Container](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/container@v1.0.0` |
| **Parent type** | [Infrastructure](infrastructure.md) |

## Schema

Infrastructure/Container describes container infrastructure requirements:

- Container runtime: docker, podman, containerd, lxc
- Image reference
- Build configuration: context, dockerfile, build args, target stage
- Registry access: URL, username, password secret (resolved by doorman)
- Security: privileged mode, capability add/drop

## Example

```yaml
_type: amadla.org/entity/infrastructure/container@v1.0.0
_body:
  runtime: podman
  image: my-app:latest
  build:
    context: .
    dockerfile: Dockerfile.prod
    args:
      GO_VERSION: "1.26"
    target: production
  registry:
    url: https://ghcr.io
    username: deploy-bot
    password_secret: registry/ghcr-token
  cap_drop:
    - ALL
  cap_add:
    - NET_BIND_SERVICE
```

## Consumers

| Tool | How It Uses Infrastructure/Container |
|------|---------------------------------------------|
| raise | Sets up container runtime environment |
| lay | Builds/pulls container images |
| doorman | Resolves `password_secret` for registry auth |
