# EntityProgrammingLanguage

| Field | Value |
|-------|-------|
| **Purpose** | Defines programming language runtime requirements — language version, runtime, build tools |
| **Repo** | [AmadlaOrg/EntityProgrammingLanguage](https://github.com/AmadlaOrg/EntityProgrammingLanguage) |
| **Entity URI** | `github.com/AmadlaOrg/EntityProgrammingLanguage@v1.0.0` |

## Schema

EntityProgrammingLanguage describes language runtime needs:

- Language name and version
- Runtime (e.g., GraalVM, Node.js, CPython)
- Build tools

## Example

```yaml
_entity: github.com/AmadlaOrg/EntityProgrammingLanguage@v1.0.0
_body:
  language: go
  version: ">=1.24"
```

## Consumers

| Tool | How It Uses EntityProgrammingLanguage |
|------|---------------------------------------|
| lay | Installs the required language runtime |
