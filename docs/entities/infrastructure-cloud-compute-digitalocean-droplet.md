# Infrastructure/Cloud/Compute/DigitalOcean Droplet

| Field | Value |
|-------|-------|
| **Purpose** | DigitalOcean Droplet-specific compute instance properties — size slug, region, monitoring, backups |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Compute/DigitalOcean/Droplet](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/compute/digitalocean-droplet@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Compute](infrastructure-cloud-compute.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `size` | string | Droplet size slug (e.g., `s-1vcpu-1gb`, `s-2vcpu-4gb`) |
| `region` | string | DigitalOcean region slug (e.g., `nyc1`, `sfo3`, `ams3`) |
| `image` | string | OS image slug (e.g., `debian-12-x64`, `ubuntu-24-04-x64`) |
| `ssh_keys` | array of strings | SSH key fingerprints or IDs |
| `vpc_uuid` | string | VPC UUID to place the droplet in |
| `tags` | array of strings | Tags applied to the droplet |
| `monitoring` | boolean | Whether to enable monitoring agent |
| `backups` | boolean | Whether to enable automated backups |
| `ipv6` | boolean | Whether to enable IPv6 |

**Required:** `size`, `region`, `image`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/compute/digitalocean-droplet@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/compute@v1.0.0
_body:
  size: s-2vcpu-4gb
  region: nyc1
  image: debian-12-x64
  ssh_keys:
    - "ab:cd:ef:12:34:56:78:90"
  vpc_uuid: vpc-abc123
  monitoring: true
  backups: true
  ipv6: true
  tags:
    - web
    - production
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Compute/DigitalOcean Droplet |
|------|-------------------------------------------------------------|
| raise | Provisions Droplets via raise-digitalocean plugin |
