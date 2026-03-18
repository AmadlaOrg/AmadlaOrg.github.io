# Infrastructure/Cloud/Compute

| Field | Value |
|-------|-------|
| **Purpose** | Common cloud compute instance properties — instance type, image, volumes, spot |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Compute](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/compute@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `instance_type` | string | Instance size/type (e.g., `t3.micro`, `cx21`, `s-1vcpu-1gb`) |
| `image` | string | OS image ID or name |
| `key_name` | string | SSH key pair name registered with the provider |
| `public_ip` | boolean | Whether to assign a public IP address (default: `true`) |
| `volumes` | array of objects | Attached storage volumes (`size`, `type`, `mount_point`) |
| `user_data` | string | Cloud-init user data script or path |
| `spot` | boolean | Whether to use spot/preemptible instances (default: `false`) |
| `max_price` | string | Maximum hourly price for spot instances |

**Required:** `instance_type`, `image`

## Sub-types

| Sub-type | Provider | Status |
|----------|----------|--------|
| [Compute/EC2](infrastructure-cloud-compute-ec2.md) | AWS EC2 | Stable |
| [Compute/GCE](infrastructure-cloud-compute-gce.md) | Google Compute Engine | Stable |
| [Compute/Azure VM](infrastructure-cloud-compute-azure-vm.md) | Azure Virtual Machines | Stable |
| [Compute/Hetzner Server](infrastructure-cloud-compute-hetzner-server.md) | Hetzner Cloud | Stable |
| [Compute/DigitalOcean Droplet](infrastructure-cloud-compute-digitalocean-droplet.md) | DigitalOcean | Stable |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/compute@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  instance_type: cx21
  image: debian-12
  key_name: deploy-key
  public_ip: true
  volumes:
    - size: 50
      type: ssd
      mount_point: /data
  user_data: |
    #!/bin/bash
    apt-get update && apt-get install -y nginx
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Compute |
|------|----------------------------------------|
| raise | Provisions compute instances via raise-aws, raise-hetzner, raise-digitalocean plugins |
