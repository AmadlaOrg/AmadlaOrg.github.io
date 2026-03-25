# Infrastructure/Cloud/Serverless/Lambda

| Field | Value |
|-------|-------|
| **Purpose** | AWS Lambda function configuration — IAM role, layers, VPC config, event source mappings, tracing |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Serverless/AWS/Lambda](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/serverless/lambda@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Serverless](infrastructure-cloud-serverless.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `function_name` | string | Name of the Lambda function |
| `role_arn` | string | ARN of the IAM execution role |
| `layers` | array of strings | Lambda layer ARNs to attach |
| `vpc_config` | object | VPC configuration (`subnet_ids[]`, `security_group_ids[]`) |
| `reserved_concurrent_executions` | integer | Number of reserved concurrent executions |
| `tracing_config` | string | X-Ray tracing mode (`Active`, `PassThrough`) |
| `dead_letter_config` | object | Dead letter queue configuration (`target_arn`) |
| `event_source_mappings` | array of objects | Event source mappings (`source_arn`, `batch_size`, `starting_position`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/serverless/lambda@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/serverless@v1.0.0
_body:
  function_name: process-orders
  runtime: python3.12
  handler: main.handler
  memory_mb: 512
  timeout_seconds: 60
  role_arn: arn:aws:iam::123456789012:role/lambda-exec
  layers:
    - arn:aws:lambda:us-east-1:123456789012:layer:common-utils:3
  tracing_config: Active
  dead_letter_config:
    target_arn: arn:aws:sqs:us-east-1:123456789012:dlq
  event_source_mappings:
    - source_arn: arn:aws:sqs:us-east-1:123456789012:orders
      batch_size: 10
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Serverless/Lambda |
|------|---------------------------------------------------|
| [raise](../tools/raise.md) | Provisions Lambda functions via raise-aws plugin |
