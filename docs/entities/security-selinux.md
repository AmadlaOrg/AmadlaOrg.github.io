# Security/SELinux

| Field | Value |
|-------|-------|
| **Purpose** | Defines SELinux policy configuration — mode, policy type, booleans, file contexts, port labels, modules |
| **Repo** | [AmadlaOrg/Entities/Security/SELinux](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/security/selinux@v1.0.0` |
| **Parent** | [Security](security.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `mode` | string | Enforcement mode: `enforcing`, `permissive`, `disabled` (default: `enforcing`) |
| `policy_type` | string | Policy type: `targeted`, `mls`, `minimum` (default: `targeted`) |
| `booleans` | object | SELinux booleans as key-value pairs (e.g., `httpd_can_network_connect: true`) |
| `file_contexts` | array | File context label definitions |
| `file_contexts[].path` | string | File path pattern, regex (**required**) |
| `file_contexts[].context` | string | SELinux context type (e.g., `httpd_sys_content_t`) (**required**) |
| `file_contexts[].file_type` | string | File type: `all`, `file`, `dir`, `socket`, `symlink` (default: `all`) |
| `ports` | array | SELinux port label definitions |
| `ports[].port` | integer/string | Port number or range (**required**) |
| `ports[].protocol` | string | Protocol: `tcp`, `udp` (default: `tcp`) |
| `ports[].type` | string | SELinux port type (e.g., `http_port_t`) (**required**) |
| `modules` | array | Custom SELinux policy modules |
| `modules[].name` | string | Module name (**required**) |
| `modules[].source` | string | Path to `.te` or `.pp` module file |
| `modules[].state` | string | `present` or `absent` (default: `present`) |

## Example

```yaml
_type: amadla.org/entity/security/selinux@v1.0.0
_body:
  mode: enforcing
  policy_type: targeted
  booleans:
    httpd_can_network_connect: true
    httpd_can_network_connect_db: true
    httpd_use_nfs: false
  file_contexts:
    - path: "/srv/www(/.*)?"
      context: httpd_sys_content_t
      file_type: all
    - path: "/srv/www/uploads(/.*)?"
      context: httpd_sys_rw_content_t
  ports:
    - port: 8080
      protocol: tcp
      type: http_port_t
    - port: 8443
      protocol: tcp
      type: http_port_t
  modules:
    - name: my-webapp
      source: /etc/selinux/modules/my-webapp.pp
      state: present
```

## Consumers

| Tool | How It Uses Security/SELinux |
|------|-----------------------------|
| enjoin-selinux | Sets SELinux mode, applies booleans, file contexts, port labels, and installs modules |
| judge | Validates SELinux is in the declared mode with correct booleans and contexts |
