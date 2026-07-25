# Infrastructure/Cloud/Serverless

| Field | Value |
|-------|-------|
| **Purpose** | Common serverless function properties — runtime, handler, memory, timeout, environment |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Serverless](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/serverless@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `runtime` | string | Runtime environment (e.g., `python3.12`, `nodejs20.x`, `go1.x`, `java21`) |
| `handler` | string | Function entry point (e.g., `index.handler`, `main.Handle`) |
| `memory_mb` | integer | Memory allocation in megabytes |
| `timeout_seconds` | integer | Maximum execution time in seconds |
| `environment` | object | Environment variables passed to the function |
| `code_path` | string | Path to the function code or deployment package |

## Sub-types

| Sub-type | Provider |
|----------|----------|
| [Serverless/Lambda](infrastructure-cloud-serverless-lambda.md) | AWS Lambda |
| [Serverless/Cloud Functions](infrastructure-cloud-serverless-cloud-functions.md) | GCP Cloud Functions |
| [Serverless/Azure Functions](infrastructure-cloud-serverless-azure-functions.md) | Azure Functions |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/serverless@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  runtime: python3.12
  handler: main.handler
  memory_mb: 256
  timeout_seconds: 30
  environment:
    LOG_LEVEL: info
  code_path: ./functions/my-function
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Serverless |
|------|---------------------------------------------|
| [raise](../tools/raise.md) | Provisions serverless functions via provider-specific plugins |
