# Weaver Plugins

Weaver plugins are template engine integrations for the **weaver** tool. Each plugin provides a different template rendering engine. Unlike other plugin types, weaver routing is **template-driven** — a Template entity specifies which engine to use.

## Plugin Inventory

| Plugin | Engine | Language |
|--------|--------|----------|
| `weaver-jinja` | Jinja2 | Python |
| `weaver-js-handlebars` | Handlebars | JavaScript |
| `weaver-js-mustache` | Mustache | JavaScript |
| `weaver-qute` | Qute | Java (Quarkus) |

## How They Work

Weaver plugins are generic template engines — they don't know about entity types. The **Template entity** drives routing:

```yaml
_type: amadla.org/entity/template@v1.0.0
_body:
  engine: jinja                          # which weaver-* plugin to invoke
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
weaver-jinja info
# {"name": "weaver-jinja", "version": "1.0.0", "supports": ["amadla.org/entity/template@^v1.0.0"], ...}

# Render a template (entity data + template path via stdin/args)
weaver-jinja render --template ./nginx.conf.j2 < entity.json > /etc/nginx/conf.d/myapp.conf
```

## Template Engines

### Jinja2 (weaver-jinja)

Python-based template engine. Widely used in infrastructure automation (Ansible, Salt). Supports inheritance, macros, filters.

### Handlebars (weaver-js-handlebars)

JavaScript template engine with logic-less philosophy plus helpers. Good for generating structured configs.

### Mustache (weaver-js-mustache)

Minimal logic-less template engine. Available in many languages. Simple variable substitution and sections.

### Qute (weaver-qute)

Java template engine from the Quarkus ecosystem. Type-safe, compile-time validated.

## Framework

Weaver plugins do not yet have a dedicated Go framework library (unlike Doorman and Judge plugins). They follow the standard plugin protocol directly. A framework may be extracted if common patterns emerge.

## Implementation Priority

1. **weaver-jinja** — Most familiar to infrastructure engineers
2. **weaver-js-mustache** — Simplest engine, good for basic configs
3. **weaver-js-handlebars** — More powerful than Mustache
4. **weaver-qute** — For Quarkus/Java ecosystem integration
