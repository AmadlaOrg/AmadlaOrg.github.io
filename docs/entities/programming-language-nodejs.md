# ProgrammingLanguage/NodeJS

| Field | Value |
|-------|-------|
| **Purpose** | Node.js specific configuration — npm/yarn/pnpm, registry, and Corepack settings |
| **Repo** | [AmadlaOrg/Entities/ProgrammingLanguage/NodeJS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/programming-language/nodejs@v1.0.0` |
| **Parent type** | [ProgrammingLanguage](programming-language.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `package_manager` | string | Preferred package manager (`npm`, `yarn`, `pnpm`) |
| `global_packages` | array of strings | Globally installed npm/yarn/pnpm packages |
| `registry` | string | Custom npm registry URL |
| `corepack_enabled` | boolean | Enable Corepack for transparent package manager management |
| `engine_strict` | boolean | Enforce engine version constraints in package.json |

## Example

```yaml
_type: amadla.org/entity/programming-language/nodejs@v1.0.0
_extends: amadla.org/entity/programming-language@v1.0.0
_body:
  language: node
  version: "20"
  version_manager: nvm
  package_manager: pnpm
  global_packages:
    - typescript
    - tsx
    - turbo
  registry: https://registry.npmjs.org
  corepack_enabled: true
  engine_strict: true
```

## Consumers

| Tool | How It Uses ProgrammingLanguage/NodeJS |
|------|----------------------------------------|
| [lay](../tools/lay.md) | Installs Node.js runtime, package manager, and global packages |
