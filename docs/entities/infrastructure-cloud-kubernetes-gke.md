# Infrastructure/Cloud/Kubernetes/GKE

| Field | Value |
|-------|-------|
| **Purpose** | Google Kubernetes Engine cluster configuration — release channel, Workload Identity, Binary Authorization |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Kubernetes/GCP/GKE](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/kubernetes/gke@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Kubernetes](infrastructure-cloud-kubernetes.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `cluster_name` | string | GKE cluster name |
| `location` | string | Cluster location (region or zone) |
| `network` | string | VPC network for the cluster |
| `subnetwork` | string | VPC subnetwork for the cluster |
| `release_channel` | string | Release channel for automatic upgrades (`RAPID`, `REGULAR`, `STABLE`) |
| `workload_identity` | object | Workload Identity configuration (`enabled`) |
| `binary_authorization` | object | Binary Authorization configuration (`evaluation_mode`) |
| `vertical_pod_autoscaling` | boolean | Enable vertical pod autoscaling |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/kubernetes/gke@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/kubernetes@v1.0.0
_body:
  cluster_name: prod-cluster
  location: us-central1
  network: prod-vpc
  subnetwork: gke-subnet
  release_channel: STABLE
  workload_identity:
    enabled: true
  vertical_pod_autoscaling: true
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Kubernetes/GKE |
|------|------------------------------------------------|
| raise | Provisions GKE clusters via raise-gcp plugin |
