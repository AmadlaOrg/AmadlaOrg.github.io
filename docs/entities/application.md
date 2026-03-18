# Application

| Field | Value |
|-------|-------|
| **Purpose** | Defines application requirements — what packages, services, and configurations an application needs |
| **Repo** | [AmadlaOrg/Entities/Application](https://github.com/AmadlaOrg/Entities/Application) |
| **Entity URI** | `amadla.org/entity/application@v1.0.0` |

## Schema

Application describes what an application needs to run:

- Required packages and their versions
- Service dependencies
- Configuration templates
- Secret references
- System prerequisites

## Example

```yaml
_type: amadla.org/entity/application@v1.0.0
_meta:
  description: "Web application with nginx reverse proxy"
_body:
  name: my-web-app
  install:
    - method: package
      packages:
        - nginx
  version: ">=1.24"
```

## Consumers

| Tool | How It Uses Application |
|------|------------------------------|
| lay | Reads requirements and installs packages |
| judge-application | Checks whether required apps are actually installed |
| weaver | Uses application data to fill config templates |
