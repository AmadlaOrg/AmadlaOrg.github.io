# ProgrammingLanguage

| Field | Value |
|-------|-------|
| **Purpose** | Defines programming language runtime requirements — language version, runtime, build tools |
| **Repo** | [AmadlaOrg/Entities/ProgrammingLanguage](https://github.com/AmadlaOrg/Entities/ProgrammingLanguage) |
| **Entity URI** | `amadla.org/entity/programminglanguage@v1.0.0` |

## Schema

ProgrammingLanguage describes language runtime needs:

- Language name and version
- Runtime (e.g., GraalVM, Node.js, CPython)
- Build tools

## Example

```yaml
_type: amadla.org/entity/programming-language@v1.0.0
_body:
  language: go
  version: ">=1.24"
```

## Consumers

| Tool | How It Uses ProgrammingLanguage |
|------|---------------------------------------|
| [lay](../tools/lay.md) | Installs the required language runtime |
