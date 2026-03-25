# Infrastructure/Cloud/Serverless/Azure Functions

| Field | Value |
|-------|-------|
| **Purpose** | Azure Functions configuration — Function App, hosting plan SKU, site config, managed identity |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Serverless/Azure/AzureFunctions](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/serverless/azure-functions@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Serverless](infrastructure-cloud-serverless.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `function_app_name` | string | Name of the Azure Function App |
| `resource_group` | string | Azure resource group |
| `storage_account_name` | string | Storage account used by the Function App |
| `os_type` | string | Operating system type (`Linux`, `Windows`) |
| `sku` | string | Hosting plan SKU (`Consumption`, `Premium`, `Dedicated`) |
| `app_settings` | object | Application settings (key-value pairs) |
| `site_config` | object | Site configuration (`always_on`, `http2_enabled`, `minimum_tls_version`) |
| `identity` | object | Managed identity configuration (`type`: `SystemAssigned` or `UserAssigned`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/serverless/azure-functions@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/serverless@v1.0.0
_body:
  function_app_name: process-events-func
  resource_group: functions-rg
  storage_account_name: funcappstorage
  runtime: python3.12
  os_type: Linux
  sku: Consumption
  app_settings:
    LOG_LEVEL: info
  site_config:
    always_on: false
    http2_enabled: true
    minimum_tls_version: "1.2"
  identity:
    type: SystemAssigned
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Serverless/Azure Functions |
|------|-----------------------------------------------------------|
| [raise](../tools/raise.md) | Provisions Azure Functions via raise-azure plugin |
