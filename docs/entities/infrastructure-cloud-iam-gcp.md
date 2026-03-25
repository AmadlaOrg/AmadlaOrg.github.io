# Infrastructure/Cloud/IAM/GCP

| Field | Value |
|-------|-------|
| **Purpose** | GCP IAM configuration — service accounts, policy bindings, custom roles |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/IAM/GCP/GCPIAM](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/iam/gcp@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/IAM](infrastructure-cloud-iam.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `service_accounts` | array of objects | Service account definitions (`id`, `display_name`, `roles[]`) |
| `bindings` | array of objects | IAM policy bindings (`role`, `members[]`, `condition`) |
| `bindings[].condition` | object | Optional condition for the binding (`title`, `expression` as CEL) |
| `custom_roles` | array of objects | Custom role definitions (`id`, `title`, `permissions[]`, `stage`) |
| `custom_roles[].stage` | string | Launch stage (`GA`, `BETA`, `ALPHA`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/iam/gcp@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/iam@v1.0.0
_body:
  service_accounts:
    - id: app-runner
      display_name: Application Runner
      roles:
        - roles/storage.objectViewer
        - roles/logging.logWriter
  bindings:
    - role: roles/editor
      members:
        - group:devs@example.com
      condition:
        title: weekday-only
        expression: request.time.getDayOfWeek() < 6
  custom_roles:
    - id: custom.appDeployer
      title: Application Deployer
      permissions:
        - compute.instances.start
        - compute.instances.stop
      stage: GA
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/IAM/GCP |
|------|------------------------------------------|
| [raise](../tools/raise.md) | Provisions GCP IAM resources via raise-gcp plugin |
