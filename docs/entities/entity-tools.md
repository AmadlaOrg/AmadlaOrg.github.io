# EntityTools

| Field | Value |
|-------|-------|
| **Purpose** | Defines the tool inventory for an Amadla project — which tools are available, how to discover them, and caching behavior |
| **Repo** | [AmadlaOrg/Entities/Tools](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/tools@v1.0.0` |

## Schema

EntityTools describes how `amadla` discovers and manages tools:

- Tool names (used for PATH resolution)
- Which entity types each tool handles (routing)
- Whether a tool is required or optional
- Caching behavior for `<tool> info` responses (mtime, TTL, or none)

## Example

```yaml
_type: amadla.org/entity/tools@v1.0.0
_body:
  tools:
    - name: hery
      description: "HERY data storage"
      required: true
      entity_types:
        - "amadla.org/entity/*"
      cache:
        enabled: true
        invalidation: mtime

    - name: lay
      description: "Package and application installer"
      entity_types:
        - "amadla.org/entity/application/*"
        - "amadla.org/entity/package"

    - name: weaver
      description: "Template and config generator"
      entity_types:
        - "amadla.org/entity/template"
```

## How It Works

1. `amadla init` generates a `tools.hery` file with default tool inventory
2. `amadla` reads the tools entity to discover available tools
3. For each tool, `amadla` resolves the binary via PATH (like `xdg-open`)
4. `amadla` calls `<tool> info` to get tool capabilities, caching the response
5. When processing entities, `amadla` routes each entity to the tool that handles its type

## Consumers

| Tool | How It Uses EntityTools |
|------|------------------------|
| amadla | Reads tool inventory to discover, route, and orchestrate tools |
