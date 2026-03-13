# EntityApplication

| Field | Value |
|-------|-------|
| **Purpose** | Defines application requirements — what packages, services, and configurations an application needs |
| **Repo** | [AmadlaOrg/EntityApplication](https://github.com/AmadlaOrg/EntityApplication) |
| **Entity URI** | `github.com/AmadlaOrg/EntityApplication@v1.0.0` |

## Schema

EntityApplication describes what an application needs to run:

- Required packages and their versions
- Service dependencies
- Configuration templates
- Secret references
- System prerequisites

## Example

```yaml
_entity: github.com/AmadlaOrg/EntityApplication@v1.0.0
_meta:
  description: "Web application with nginx reverse proxy"
_id:
  - github.com/AmadlaOrg/EntitySystem@v1.0.0
  - github.com/AmadlaOrg/EntitySecret@v1.0.0
_body:
  name: my-web-app
  requires:
    - _entity: github.com/AmadlaOrg/EntitySystem@v1.0.0
      _body:
        package: nginx
        version: ">=1.24"
```

## Consumers

| Tool | How It Uses EntityApplication |
|------|------------------------------|
| lay | Reads requirements and installs packages |
| judge-application | Checks whether required apps are actually installed |
| weaver | Uses application data to fill config templates |
