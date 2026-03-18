# Tools

| Field | Value |
|-------|-------|
| **Purpose** | Declares which tools are available to the amadla orchestrator |
| **Repo** | [AmadlaOrg/Entities/Tools](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/tools@v1.0.0` |

## Schema

The Tools entity is intentionally minimal — just two properties per tool:

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `name` | string | Yes | Tool binary name. Used to find the binary in PATH. |
| `path` | string | No | Explicit path to the binary. Used when the tool is not in PATH. |

Everything else (what entity types a tool handles, its version, capabilities) comes from calling `<tool> info` at runtime. The Tools entity only answers: **what tools exist and where to find them.**

## Example

```yaml
_type: amadla.org/entity/tools@v1.0.0
_body:
  tools:
    - name: hery
    - name: lay
    - name: enjoin
    - name: weaver
    - name: doorman
    - name: judge
    - name: raise
    - name: waiter
    - name: unravel
    - name: garbage
    - name: conduct
    - name: lighthouse
    - name: dryrun
```

If a tool isn't in PATH, provide an explicit path:

```yaml
_body:
  tools:
    - name: hery
      path: /opt/amadla/bin/hery
    - name: lay
```

## How It Works

1. `amadla init` bootstraps a default `tools.hery` by scanning PATH for standard Amadla tool names
2. `amadla` reads the tools entity to get the list of tool names
3. For each tool, `amadla` resolves the binary via PATH (or uses `path` if provided)
4. `amadla` calls `<tool> info` to learn capabilities — caches the response at `~/.cache/amadla/tool-info.json` (invalidated per-tool when the binary's mtime changes)
5. Entity-to-tool routing comes from the `info` response, not from the tools entity itself

This is like `xdg-open` — the registry just maps names to binaries, the binaries self-describe.

## Consumers

| Tool | How It Uses Tools |
|------|-------------------|
| amadla | Reads tool inventory to discover, resolve, and orchestrate tools |
