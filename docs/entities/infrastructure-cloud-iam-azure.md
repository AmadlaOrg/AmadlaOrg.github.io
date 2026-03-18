# Infrastructure/Cloud/IAM/Azure

| Field | Value |
|-------|-------|
| **Purpose** | Azure Entra ID (formerly Azure AD) configuration — applications, service principals, role assignments, groups |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/IAM/Azure/EntraID](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/iam/azure@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/IAM](infrastructure-cloud-iam.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `applications` | array of objects | Application registrations (`display_name`, `identifier_uris[]`, `web`, `api`) |
| `applications[].web` | object | Web platform configuration (`redirect_uris[]`, `implicit_grant`) |
| `service_principals` | array of objects | Service principal definitions (`display_name`, `app_id`, `app_role_assignments[]`) |
| `role_assignments` | array of objects | Azure role assignments (`role_definition_name`, `principal_id`, `scope`) |
| `groups` | array of objects | Entra ID group definitions (`display_name`, `members[]`, `owners[]`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/iam/azure@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/iam@v1.0.0
_body:
  applications:
    - display_name: My Web App
      identifier_uris:
        - api://my-web-app
      web:
        redirect_uris:
          - https://myapp.example.com/auth/callback
  role_assignments:
    - role_definition_name: Contributor
      principal_id: abc-123-def
      scope: /subscriptions/sub-id/resourceGroups/prod-rg
  groups:
    - display_name: Platform Team
      members:
        - user-principal-id-1
        - user-principal-id-2
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/IAM/Azure |
|------|---------------------------------------------|
| raise | Provisions Azure Entra ID resources via raise-azure plugin |
