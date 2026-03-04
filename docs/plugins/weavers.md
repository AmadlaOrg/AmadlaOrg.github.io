# Weaver Plugins

Weavers are template engine plugins for the **weaver** tool. Each plugin provides a different template rendering engine.

## Weaver Plugin Inventory

| Plugin | Engine | Language | Status |
|--------|--------|----------|--------|
| `weaver-jinja` | Jinja2 | Python | Stub |
| `weaver-js-handlebars` | Handlebars | JavaScript | Stub |
| `weaver-js-mustache` | Mustache | JavaScript | Stub |
| `weaver-qute` | Qute | Java (Quarkus) | Stub |

## How They Work

weaver receives entity data (with resolved secrets) and template files. It delegates rendering to the appropriate plugin based on the template engine:

```
Entity data + template → weaver → weaver-{engine} plugin → rendered config file
```

## Template Engines

### Jinja2 (weaver-jinja)

Python-based template engine. Widely used in infrastructure automation (Ansible, Salt). Supports inheritance, macros, filters.

### Handlebars (weaver-js-handlebars)

JavaScript template engine with logic-less philosophy plus helpers. Good for generating structured configs.

### Mustache (weaver-js-mustache)

Minimal logic-less template engine. Available in many languages. Simple variable substitution and sections.

### Qute (weaver-qute)

Java template engine from the Quarkus ecosystem. Type-safe, compile-time validated. Used in the broader SiteNetSoft ecosystem.

## Framework

Weaver plugins do not yet have a dedicated framework library (unlike Clerks and Auditors). They communicate with weaver directly. A framework may be extracted if common patterns emerge.

## Implementation Priority

1. **weaver-jinja** — Most familiar to infrastructure engineers
2. **weaver-js-mustache** — Simplest engine, good for basic configs
3. **weaver-js-handlebars** — More powerful than Mustache
4. **weaver-qute** — For Quarkus/Java ecosystem integration
