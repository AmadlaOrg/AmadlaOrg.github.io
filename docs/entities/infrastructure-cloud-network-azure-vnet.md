# Infrastructure/Cloud/Network/Azure VNet

| Field | Value |
|-------|-------|
| **Purpose** | Azure VNet-specific network properties — address space, NSG rules, peerings, service endpoints |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Network/Azure/VNet](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/network/azure-vnet@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Network](infrastructure-cloud-network.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `address_space` | array of strings | Address space CIDR blocks (e.g., `["10.0.0.0/16"]`) |
| `subnets` | array of objects | Subnet definitions (`name`, `address_prefix`, `service_endpoints[]`, `delegation`) |
| `nsg_rules` | array of objects | Network security group rules (`name`, `priority`, `direction`, `access`, `protocol`, port/address fields) |
| `peerings` | array of objects | VNet peering configurations (`name`, `remote_vnet_id`, `allow_forwarded_traffic`) |

**Required:** `address_space`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/network/azure-vnet@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/network@v1.0.0
_body:
  address_space:
    - 10.0.0.0/16
  subnets:
    - name: web-subnet
      address_prefix: 10.0.1.0/24
      service_endpoints:
        - Microsoft.Storage
    - name: db-subnet
      address_prefix: 10.0.2.0/24
  nsg_rules:
    - name: allow-https
      priority: 100
      direction: Inbound
      access: Allow
      protocol: Tcp
      destination_port_range: "443"
      source_address_prefix: "*"
      destination_address_prefix: "*"
      source_port_range: "*"
  peerings:
    - name: hub-peering
      remote_vnet_id: /subscriptions/.../hub-vnet
      allow_forwarded_traffic: true
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Network/Azure VNet |
|------|---------------------------------------------------|
| [raise](../tools/raise.md) | Provisions Azure VNets via raise-azure plugin |
