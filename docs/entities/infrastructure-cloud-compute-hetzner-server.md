# Infrastructure/Cloud/Compute/Hetzner Server

| Field | Value |
|-------|-------|
| **Purpose** | Hetzner Cloud-specific server properties — server type, location, firewalls, networks |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Compute/Hetzner/Server](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/compute/hetzner-server@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Compute](infrastructure-cloud-compute.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `server_type` | string | Hetzner server type (e.g., `cx21`, `cpx31`, `cax11`) |
| `location` | string | Hetzner datacenter location (e.g., `nbg1`, `fsn1`, `hel1`) |
| `image` | string | OS image name (e.g., `debian-12`, `ubuntu-24.04`) |
| `ssh_keys` | array of strings | SSH key names registered with Hetzner |
| `firewalls` | array of strings | Firewall IDs or names to attach |
| `networks` | array of strings | Private network IDs to attach |
| `labels` | object | Labels applied to the server |
| `user_data` | string | Cloud-init user data script |

**Required:** `server_type`, `location`, `image`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/compute/hetzner-server@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/compute@v1.0.0
_body:
  server_type: cx21
  location: nbg1
  image: debian-12
  ssh_keys:
    - deploy-key
  firewalls:
    - web-firewall
  networks:
    - internal-net
  labels:
    role: webserver
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Compute/Hetzner Server |
|------|-------------------------------------------------------|
| [raise](../tools/raise.md) | Provisions Hetzner servers via raise-hetzner plugin |
