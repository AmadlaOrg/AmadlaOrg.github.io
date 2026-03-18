# Infrastructure/Cloud/Kubernetes

| Field | Value |
|-------|-------|
| **Purpose** | Common managed Kubernetes properties — version, node pools, network policy, private cluster |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Kubernetes](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/kubernetes@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `kubernetes_version` | string | Kubernetes version for the cluster |
| `node_pools` | array of objects | Node pool configurations (`name`, `instance_type`, `count`, `min_count`, `max_count`, `disk_size_gb`, `labels`, `taints[]`) |
| `network_policy` | string | Network policy provider (`calico`, `cilium`, `none`) |
| `private_cluster` | boolean | Whether the cluster is private (no public endpoint) |

## Sub-types

| Sub-type | Provider | Status |
|----------|----------|--------|
| [Kubernetes/EKS](infrastructure-cloud-kubernetes-eks.md) | AWS Elastic Kubernetes Service | Stable |
| [Kubernetes/GKE](infrastructure-cloud-kubernetes-gke.md) | Google Kubernetes Engine | Stable |
| [Kubernetes/AKS](infrastructure-cloud-kubernetes-aks.md) | Azure Kubernetes Service | Stable |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/kubernetes@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  kubernetes_version: "1.29"
  node_pools:
    - name: default
      instance_type: t3.medium
      min_count: 2
      max_count: 10
      disk_size_gb: 50
      labels:
        role: worker
  network_policy: cilium
  private_cluster: true
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Kubernetes |
|------|---------------------------------------------|
| raise | Provisions managed Kubernetes clusters via provider-specific plugins |
