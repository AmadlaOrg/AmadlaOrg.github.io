# Infrastructure/Cloud/Compute/GCE

| Field | Value |
|-------|-------|
| **Purpose** | Google Compute Engine-specific instance properties — machine type, zone, boot disk, service account |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Compute/GCP/GCE](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/compute/gce@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Compute](infrastructure-cloud-compute.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `machine_type` | string | GCE machine type (e.g., `e2-medium`, `n2-standard-4`) |
| `zone` | string | GCP zone (e.g., `us-central1-a`) |
| `network` | string | VPC network name or self link |
| `subnetwork` | string | Subnetwork name or self link |
| `service_account` | object | Service account configuration (`email`, `scopes`) |
| `preemptible` | boolean | Whether to use a preemptible instance |
| `boot_disk` | object | Boot disk configuration (`image`, `size_gb`, `type`) |
| `boot_disk.type` | string | Persistent disk type (`pd-standard`, `pd-ssd`, `pd-balanced`) |
| `labels` | object | GCP labels applied to the instance |

**Required:** `machine_type`, `zone`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/compute/gce@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/compute@v1.0.0
_body:
  machine_type: e2-medium
  zone: us-central1-a
  network: default
  subnetwork: default
  boot_disk:
    image: debian-cloud/debian-12
    size_gb: 20
    type: pd-ssd
  service_account:
    email: compute@my-project.iam.gserviceaccount.com
    scopes:
      - https://www.googleapis.com/auth/cloud-platform
  labels:
    environment: staging
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Compute/GCE |
|------|---------------------------------------------|
| raise | Provisions GCE instances via raise-gcp plugin |
