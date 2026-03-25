# ProgrammingLanguage/Ruby

| Field | Value |
|-------|-------|
| **Purpose** | Ruby-specific configuration — gem, Bundler, and Rails settings |
| **Repo** | [AmadlaOrg/Entities/ProgrammingLanguage/Ruby](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/programming-language/ruby@v1.0.0` |
| **Parent type** | [ProgrammingLanguage](programming-language.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `gems` | array of strings | Global gems to install |
| `bundler_version` | string | Bundler version to install |
| `gem_sources` | array of strings | Gem source URLs |
| `gemrc.no_document` | boolean | Skip documentation generation when installing gems |
| `gemrc.verbose` | boolean | Enable verbose output for gem operations |
| `rails_env` | string | Default RAILS_ENV value |

## Example

```yaml
_type: amadla.org/entity/programming-language/ruby@v1.0.0
_extends: amadla.org/entity/programming-language@v1.0.0
_body:
  language: ruby
  version: "3.3"
  version_manager: rbenv
  gems:
    - rails
    - puma
    - sidekiq
  bundler_version: "2.5.6"
  gem_sources:
    - https://rubygems.org
  gemrc:
    no_document: true
    verbose: false
  rails_env: production
```

## Consumers

| Tool | How It Uses ProgrammingLanguage/Ruby |
|------|--------------------------------------|
| [lay](../tools/lay.md) | Installs Ruby runtime, Bundler, and global gems |
