# Infrastructure/Cloud/Compute/EC2

| Field | Value |
|-------|-------|
| **Purpose** | AWS EC2-specific compute instance properties — AMI, VPC, security groups, IMDS |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Compute/AWS/EC2](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/compute/ec2@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Compute](infrastructure-cloud-compute.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `ami` | string | Amazon Machine Image ID (e.g., `ami-0abcdef1234567890`) |
| `vpc_id` | string | VPC ID to launch the instance in |
| `subnet_id` | string | Subnet ID within the VPC |
| `security_group_ids` | array of strings | List of security group IDs |
| `iam_instance_profile` | string | IAM instance profile name or ARN |
| `ebs_optimized` | boolean | Whether to enable EBS optimization |
| `placement_group` | string | Placement group name for clustered instances |
| `tenancy` | string | Instance tenancy model (`default`, `dedicated`, `host`) |
| `metadata_options` | object | Instance metadata service (IMDS) options |
| `metadata_options.http_tokens` | string | Whether IMDSv2 tokens are required (`required`, `optional`) |
| `metadata_options.http_endpoint` | string | Whether the metadata endpoint is enabled (`enabled`, `disabled`) |

**Required:** `ami`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/compute/ec2@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/compute@v1.0.0
_body:
  ami: ami-0abcdef1234567890
  instance_type: t3.large
  vpc_id: vpc-abc123
  subnet_id: subnet-def456
  security_group_ids:
    - sg-web
    - sg-ssh
  iam_instance_profile: web-server-profile
  ebs_optimized: true
  metadata_options:
    http_tokens: required
    http_endpoint: enabled
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Compute/EC2 |
|------|---------------------------------------------|
| [raise](../tools/raise.md) | Provisions EC2 instances via raise-aws plugin |
