# Application/WebServer

| Field | Value |
|-------|-------|
| **Purpose** | Defines web server configuration — virtual hosts, locations, SSL, proxying |
| **Repo** | [AmadlaOrg/Entities/Application/WebServer](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/webserver@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

Application/WebServer describes web server requirements:

- Server name(s) / virtual host(s)
- Listen directives (port or address:port)
- Document root and index files
- Location blocks: URL path, proxy_pass, root, try_files, rewrite, custom headers
- SSL configuration: certificate/key paths, TLS protocol versions
- Access and error log paths
- Worker connections limit

## Example

```yaml
_type: amadla.org/entity/application/webserver@v1.0.0
_body:
  server_name: example.com
  listen:
    - 80
    - 443
  root: /var/www/example.com
  index:
    - index.html
    - index.htm
  locations:
    - path: /
      try_files: "$uri $uri/ =404"
    - path: /api
      proxy_pass: "http://127.0.0.1:3000"
      headers:
        X-Forwarded-For: "$proxy_add_x_forwarded_for"
        X-Real-IP: "$remote_addr"
  ssl:
    certificate: /etc/ssl/certs/example.com.pem
    certificate_key: /etc/ssl/private/example.com.key
    protocols:
      - TLSv1.2
      - TLSv1.3
  access_log: /var/log/nginx/example.com.access.log
  error_log: /var/log/nginx/example.com.error.log
  worker_connections: 1024
```

## Consumers

| Tool | How It Uses Application/WebServer |
|------|----------------------------------------|
| [lay](../tools/lay.md) | Installs the web server (nginx, apache, caddy) |
| [weaver](../tools/weaver.md) | Generates virtual host / server block configuration files |
| [judge-application](../plugins/judges.md) | Validates web server is running with correct configuration |
