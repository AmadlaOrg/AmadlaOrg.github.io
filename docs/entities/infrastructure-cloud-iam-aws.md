# Infrastructure/Cloud/IAM/AWS

| Field | Value |
|-------|-------|
| **Purpose** | AWS IAM configuration — users, groups, roles, policies, instance profiles |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/IAM/AWS/AWSIAM](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/iam/aws@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/IAM](infrastructure-cloud-iam.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `users` | array of objects | IAM user definitions (`name`, `groups[]`, `policies[]`, `access_key`) |
| `groups` | array of objects | IAM group definitions (`name`, `policies[]`) |
| `roles` | array of objects | IAM role definitions (`name`, `assume_role_policy`, `managed_policies[]`, `inline_policies[]`) |
| `roles[].assume_role_policy` | object | Trust policy (`principal`, `action`, `effect`) |
| `policies` | array of objects | Standalone IAM policy definitions (`name`, `document`) |
| `policies[].document` | object | IAM policy document (`Version`, `Statement[]`) |
| `instance_profiles` | array of objects | Instance profile definitions for EC2 (`name`, `role`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/iam/aws@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/iam@v1.0.0
_body:
  roles:
    - name: web-server-role
      assume_role_policy:
        principal:
          Service: ec2.amazonaws.com
        action: sts:AssumeRole
        effect: Allow
      managed_policies:
        - arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
  instance_profiles:
    - name: web-server-profile
      role: web-server-role
  groups:
    - name: developers
      policies:
        - arn:aws:iam::aws:policy/PowerUserAccess
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/IAM/AWS |
|------|------------------------------------------|
| raise | Provisions AWS IAM resources via raise-aws plugin |
