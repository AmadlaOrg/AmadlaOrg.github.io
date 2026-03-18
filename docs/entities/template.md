# Template

| Field | Value |
|-------|-------|
| **Purpose** | Defines template configuration — which template engine to use, where the template file lives, where to write output, and which entity types the template supports |
| **Repo** | [AmadlaOrg/Entities/Template](https://github.com/AmadlaOrg/Entities/Template) |
| **Entity URI** | `amadla.org/entity/template@v1.0.0` |

## Schema

Template describes template configuration:

- **engine** — which `weaver-*` plugin to invoke (e.g., `jinja`, `mustache`, `handlebars`, `qute`)
- **path** — relative path from the entity's location to the template file
- **output** — where the rendered file should be written (absolute or relative path)
- **supports** — list of entity type URIs this template can render

## Example

```yaml
# yaml-language-server: $schema=https://amadla.org/entity/hery/v1.0.0/schema.hery.json
---
_type: amadla.org/entity/template@v1.0.0
_meta:
  name: nginx-app-config
  description: Generates nginx configuration for application entities
_body:
  engine: jinja
  path: ./templates/nginx.conf.j2
  output: /etc/nginx/conf.d/myapp.conf
  supports:
    - amadla.org/entity/application@^v1.0.0
```

### Multiple Templates for the Same Entity Type

A directory can contain multiple template entities, each producing different output:

```yaml
# nginx-config.hery
---
_type: amadla.org/entity/template@v1.0.0
_meta:
  name: nginx-config
_body:
  engine: jinja
  path: ./templates/nginx.conf.j2
  output: /etc/nginx/conf.d/myapp.conf
  supports:
    - amadla.org/entity/application@^v1.0.0
```

```yaml
# systemd-unit.hery
---
_type: amadla.org/entity/template@v1.0.0
_meta:
  name: systemd-unit
_body:
  engine: mustache
  path: ./templates/myapp.service.mustache
  output: /etc/systemd/system/myapp.service
  supports:
    - amadla.org/entity/application@^v1.0.0
```

When weaver receives an Application entity, both templates match — weaver renders both, producing `nginx.conf` via `weaver-jinja` and `myapp.service` via `weaver-js-mustache`.

## How Weaver Uses Template

1. Weaver receives entity data (e.g., an Application entity) via stdin or hery query
2. Weaver queries hery for all Template instances
3. Weaver filters templates whose `supports` list matches the input entity type
4. For each matching template:
    - Resolves `path` relative to the template entity's git location
    - Invokes the `weaver-<engine>` plugin with the entity data on stdin and the template file
    - Writes the rendered result to the `output` path
5. If `output` is relative, it's resolved from the entity location or current working directory

## Output Path

The `output` field accepts both absolute and relative paths:

| Path | Behavior |
|------|----------|
| `/etc/nginx/conf.d/myapp.conf` | Written directly to the absolute path |
| `./output/nginx.conf` | Resolved relative to the entity location or cwd |

Downstream tools (lay, waiter) can move rendered files to their final destinations if needed.

## Consumers

| Tool | How It Uses Template |
|------|---------------------------|
| weaver | Discovers templates, matches against input entities, invokes the correct `weaver-*` plugin, writes rendered output |
