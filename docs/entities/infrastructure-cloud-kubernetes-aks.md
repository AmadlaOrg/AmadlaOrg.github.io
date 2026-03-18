# Infrastructure/Cloud/Kubernetes/AKS

| Field | Value |
|-------|-------|
| **Purpose** | Azure Kubernetes Service cluster configuration — resource group, network profile, managed identity, monitoring |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Kubernetes/Azure/AKS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/kubernetes/aks@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Kubernetes](infrastructure-cloud-kubernetes.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `cluster_name` | string | AKS cluster name |
| `resource_group` | string | Azure resource group |
| `dns_prefix` | string | DNS prefix for the cluster |
| `network_profile` | object | Network profile configuration (`network_plugin`, `service_cidr`, `dns_service_ip`, `pod_cidr`) |
| `network_profile.network_plugin` | string | Network plugin (`azure`, `kubenet`) |
| `identity` | object | Managed identity configuration (`type`: `SystemAssigned` or `UserAssigned`) |
| `azure_policy_enabled` | boolean | Enable Azure Policy integration |
| `oms_agent` | object | OMS agent for Container Insights monitoring (`enabled`, `log_analytics_workspace_id`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/kubernetes/aks@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/kubernetes@v1.0.0
_body:
  cluster_name: prod-aks
  resource_group: k8s-rg
  dns_prefix: prod-aks
  network_profile:
    network_plugin: azure
    service_cidr: 10.1.0.0/16
    dns_service_ip: 10.1.0.10
  identity:
    type: SystemAssigned
  azure_policy_enabled: true
  oms_agent:
    enabled: true
    log_analytics_workspace_id: /subscriptions/.../workspace
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Kubernetes/AKS |
|------|------------------------------------------------|
| raise | Provisions AKS clusters via raise-azure plugin |
