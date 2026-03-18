# Infrastructure/Cloud/Serverless/Cloud Functions

| Field | Value |
|-------|-------|
| **Purpose** | GCP Cloud Functions configuration — triggers, service account, instance scaling, VPC connector, ingress |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Serverless/GCP/CloudFunctions](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/serverless/cloud-functions@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Serverless](infrastructure-cloud-serverless.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Name of the Cloud Function |
| `region` | string | GCP region where the function is deployed |
| `trigger` | object | Trigger configuration (`type`, `config`) |
| `trigger.type` | string | Trigger type (`http`, `pubsub`, `storage`, `firestore`) |
| `service_account` | string | Service account email used by the function |
| `max_instances` | integer | Maximum number of concurrent instances |
| `min_instances` | integer | Minimum number of instances to keep warm |
| `vpc_connector` | string | VPC connector for private network access |
| `ingress_settings` | string | Ingress restriction (`ALLOW_ALL`, `ALLOW_INTERNAL_ONLY`, `ALLOW_INTERNAL_AND_GCLB`) |
| `build_environment_variables` | object | Environment variables available during the build step |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/serverless/cloud-functions@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/serverless@v1.0.0
_body:
  name: process-events
  region: us-central1
  runtime: python3.12
  handler: main.handler
  memory_mb: 256
  trigger:
    type: pubsub
    config:
      topic: projects/my-project/topics/events
  service_account: cf-runner@my-project.iam.gserviceaccount.com
  max_instances: 100
  min_instances: 1
  ingress_settings: ALLOW_INTERNAL_ONLY
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Serverless/Cloud Functions |
|------|-----------------------------------------------------------|
| raise | Provisions Cloud Functions via raise-gcp plugin |
