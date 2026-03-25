# Infrastructure/Cloud/Network/GCP VPC

| Field | Value |
|-------|-------|
| **Purpose** | GCP VPC-specific network properties — auto subnetworks, routing mode, firewall rules, Cloud NAT |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Network/GCP/VPC](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/network/gcp-vpc@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Network](infrastructure-cloud-network.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `auto_create_subnetworks` | boolean | Whether to automatically create subnetworks in each region |
| `routing_mode` | string | VPC routing mode (`REGIONAL`, `GLOBAL`) |
| `firewall_rules` | array of objects | VPC firewall rule definitions (`name`, `direction`, `action`, `protocols[]`, `source_ranges[]`, `target_tags[]`) |
| `cloud_nat` | object | Cloud NAT configuration (`enabled`, `router_name`, `region`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/network/gcp-vpc@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/network@v1.0.0
_body:
  auto_create_subnetworks: false
  routing_mode: GLOBAL
  firewall_rules:
    - name: allow-https
      direction: INGRESS
      action: allow
      protocols:
        - protocol: tcp
          ports: ["443"]
      source_ranges:
        - 0.0.0.0/0
      target_tags:
        - web
  cloud_nat:
    enabled: true
    router_name: nat-router
    region: us-central1
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Network/GCP VPC |
|------|------------------------------------------------|
| [raise](../tools/raise.md) | Provisions GCP VPC networks via raise-gcp plugin |
