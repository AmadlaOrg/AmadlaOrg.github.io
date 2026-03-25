# Infrastructure/Cloud/IAM

| Field | Value |
|-------|-------|
| **Purpose** | Common cloud IAM properties — policies, roles, trust policies |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/IAM](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/iam@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `policies` | array of objects | Access policy definitions (`name`, `effect`, `actions[]`, `resources[]`) |
| `policies[].effect` | string | Whether the policy allows or denies (`allow`, `deny`) |
| `roles` | array of objects | Role definitions (`name`, `policies[]`, `trust_policy`) |

## Sub-types

| Sub-type | Provider |
|----------|----------|
| [IAM/AWS](infrastructure-cloud-iam-aws.md) | AWS Identity and Access Management |
| [IAM/GCP](infrastructure-cloud-iam-gcp.md) | GCP IAM |
| [IAM/Azure](infrastructure-cloud-iam-azure.md) | Azure Entra ID |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/iam@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  policies:
    - name: read-only-storage
      effect: allow
      actions:
        - storage:GetObject
        - storage:ListBucket
      resources:
        - "arn:aws:s3:::my-bucket/*"
  roles:
    - name: app-role
      policies:
        - read-only-storage
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/IAM |
|------|-------------------------------------|
| [raise](../tools/raise.md) | Provisions IAM resources via provider-specific plugins |
