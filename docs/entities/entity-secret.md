# EntitySecret

| Field | Value |
|-------|-------|
| **Purpose** | Defines secret references — what secrets an application needs and where to find them |
| **Repo** | [AmadlaOrg/EntitySecret](https://github.com/AmadlaOrg/EntitySecret) |
| **Entity URI** | `github.com/AmadlaOrg/EntitySecret@v1.0.0` |

## Schema

EntitySecret describes secret requirements:

- Secret key/name
- Source backend (which doorman plugin to use)
- Path within the backend
- TTL / rotation policy

## Example

```yaml
_type: amadla.org/entity/secret@v1.0.0
_body:
  key: tls-certificate
  source: vault
  path: secret/data/my-app/tls
```

## Consumers

| Tool | How It Uses EntitySecret |
|------|--------------------------|
| doorman | Resolves secret references to actual values via doorman plugins |
| weaver | Injects resolved secrets into configuration templates |
