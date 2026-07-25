# Infrastructure/Cloud/Network

| Field | Value |
|-------|-------|
| **Purpose** | Common cloud network/VPC properties — CIDR blocks, subnets, DNS, NAT |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Network](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/network@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `cidr` | string | Primary CIDR block for the network (e.g., `10.0.0.0/16`) |
| `subnets` | array of objects | Subnet definitions (`name`, `cidr`, `zone`, `public`) |
| `enable_dns` | boolean | Whether to enable DNS resolution in the network |
| `enable_nat` | boolean | Whether to enable NAT for private subnets |

**Required:** `cidr`

## Sub-types

| Sub-type | Provider |
|----------|----------|
| [Network/AWS VPC](infrastructure-cloud-network-aws-vpc.md) | AWS Virtual Private Cloud |
| [Network/GCP VPC](infrastructure-cloud-network-gcp-vpc.md) | Google Cloud VPC |
| [Network/Azure VNet](infrastructure-cloud-network-azure-vnet.md) | Azure Virtual Network |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/network@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  cidr: 10.0.0.0/16
  subnets:
    - name: public-a
      cidr: 10.0.1.0/24
      zone: us-east-1a
      public: true
    - name: private-a
      cidr: 10.0.10.0/24
      zone: us-east-1a
      public: false
  enable_dns: true
  enable_nat: true
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Network |
|------|----------------------------------------|
| [raise](../tools/raise.md) | Provisions virtual networks via provider-specific plugins |
