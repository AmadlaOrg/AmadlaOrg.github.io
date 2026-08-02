# Weaver Plugins

Weaver plugins are template engine integrations for the **weaver** tool. Each plugin provides a different template rendering engine. Unlike other plugin types, weaver routing is **template-driven** — a Template entity specifies which engine to use.

## Plugin Inventory

| Plugin | Engine | Language |
|--------|--------|----------|
| `weaver-go` | Go templates | Go |
| `weaver-jinja2` | Jinja2 | Python |
| `weaver-mustache` | Mustache | Go |
| `weaver-qute` | Qute | Java (Quarkus) |
| `weaver-freemarker` | FreeMarker | Java |

## How They Work

Weaver plugins are generic template engines — they don't know about entity types. The **Template entity** drives routing:

```yaml
_type: amadla.org/entity/template@v1.0.0
_body:
  engine: jinja2                          # which weaver-* plugin to invoke
  path: ./templates/nginx.conf.j2        # relative path from entity location
  output: /etc/nginx/conf.d/myapp.conf   # rendered output path (absolute or relative)
  supports:                              # which entity types this template can render
    - amadla.org/entity/application@^v1.0.0
```

Weaver's flow:

1. Receives entity data (e.g., an Application entity)
2. Queries hery for template entities that support this entity type
3. For each matching template, invokes the specified `weaver-*` plugin
4. Each plugin renders the template and writes the result to the specified output path

Multiple templates can match the same entity type — weaver renders all of them (e.g., one for nginx.conf, another for systemd units).

## Protocol

Weaver plugins follow the standard [Plugin Protocol](../architecture/plugin-system.md):

```bash
# Plugin metadata
weaver-jinja2 info
# {"name": "weaver-jinja2", "version": "1.0.0", "supports": ["amadla.org/entity/template@^v1.0.0"], ...}

# Render a template (entity data + template path via stdin/args)
weaver-jinja2 render --template ./nginx.conf.j2 < entity.json > /etc/nginx/conf.d/myapp.conf
```

## Template Engines

### Jinja2 (weaver-jinja2)

Python-based template engine. Widely used in infrastructure automation (Ansible, Salt). Supports inheritance, macros, filters.

### Go templates (weaver-go)

Go's standard `text/template` engine. No external runtime needed — ships as a single binary like the rest of the ecosystem.

### Mustache (weaver-mustache)

Minimal logic-less template engine. Available in many languages. Simple variable substitution and sections.

### Qute (weaver-qute)

Java template engine from the Quarkus ecosystem. Type-safe, compile-time validated.

### FreeMarker (weaver-freemarker)

Java template engine widely used in the JVM ecosystem. Rich directives and built-ins for structured output.

## Framework

Weaver plugins do not yet have a dedicated Go framework library (unlike Doorman and Judge plugins). They follow the standard plugin protocol directly. A framework may be extracted if common patterns emerge.

## Implementation Priority

1. **weaver-jinja2** — Most familiar to infrastructure engineers
2. **weaver-go** — No external runtime, simplest to ship
3. **weaver-mustache** — Simplest engine, good for basic configs
4. **weaver-qute** — For Quarkus/Java ecosystem integration
5. **weaver-freemarker** — For JVM ecosystem integration
