# Application/LoadBalancer/Traefik

| Field | Value |
|-------|-------|
| **Purpose** | Traefik-specific configuration — cloud-native reverse proxy with auto-discovery |
| **Repo** | [AmadlaOrg/Entities/Application/LoadBalancer/Traefik](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/load-balancer/traefik@v1.0.0` |
| **Parent type** | [Application/LoadBalancer](application-load-balancer.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `entrypoints` | object | Named entrypoints, each with an `address` (e.g., `:80`, `:443`) |
| `providers.docker.endpoint` | string | Docker daemon endpoint (e.g., `unix:///var/run/docker.sock`) |
| `providers.docker.exposedByDefault` | boolean | Whether containers are exposed by default |
| `providers.file.directory` | string | Directory to watch for dynamic configuration files |
| `providers.file.watch` | boolean | Whether to watch the directory for changes |
| `certificatesResolvers` | object | ACME certificate resolvers (`email`, `storage`, challenge config) |
| `api.dashboard` | boolean | Whether the dashboard is enabled |
| `api.insecure` | boolean | Whether the API is accessible without TLS |
| `log.level` | string | Log level (e.g., `DEBUG`, `INFO`, `WARN`, `ERROR`) |
| `log.filePath` | string | Path to log file |
| `accessLog.filePath` | string | Path to access log file |
| `accessLog.format` | string | Access log format (e.g., `common`, `json`) |

## Example

```yaml
_type: amadla.org/entity/application/load-balancer/traefik@v1.0.0
_extends: amadla.org/entity/application/load-balancer@v1.0.0
_body:
  listen_address: 0.0.0.0
  algorithm: roundrobin
  entrypoints:
    web:
      address: ":80"
    websecure:
      address: ":443"
  providers:
    docker:
      endpoint: unix:///var/run/docker.sock
      exposedByDefault: false
    file:
      directory: /etc/traefik/dynamic
      watch: true
  certificatesResolvers:
    letsencrypt:
      email: admin@example.com
      storage: /etc/traefik/acme.json
      httpChallenge:
        entryPoint: web
  api:
    dashboard: true
    insecure: false
  log:
    level: INFO
    filePath: /var/log/traefik/traefik.log
  accessLog:
    filePath: /var/log/traefik/access.log
    format: json
```

## Consumers

| Tool | How It Uses Application/LoadBalancer/Traefik |
|------|----------------------------------------------|
| lay | Installs the `traefik` binary |
| weaver | Generates `/etc/traefik/traefik.yml` and dynamic configuration files |
| enjoin-service | Enables/starts `traefik` service |
