# Infrastructure/Cloud/Network/AWS VPC

| Field | Value |
|-------|-------|
| **Purpose** | AWS VPC-specific network properties — internet gateway, NAT gateway, route tables, security groups, flow logs |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Network/AWS/VPC](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/network/aws-vpc@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Network](infrastructure-cloud-network.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `vpc_cidr` | string | VPC CIDR block (e.g., `10.0.0.0/16`) |
| `enable_dns_hostnames` | boolean | Whether to enable DNS hostnames in the VPC |
| `enable_dns_support` | boolean | Whether to enable DNS support in the VPC |
| `internet_gateway` | boolean | Whether to attach an internet gateway |
| `nat_gateway` | object | NAT gateway configuration (`enabled`, `subnet`) |
| `route_tables` | array of objects | Route table definitions (`name`, `routes[]`) |
| `security_groups` | array of objects | Security group definitions (`name`, `description`, `ingress[]`, `egress[]`) |
| `flow_logs` | object | VPC flow log configuration (`enabled`, `destination`) |

**Required:** `vpc_cidr`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/network/aws-vpc@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/network@v1.0.0
_body:
  vpc_cidr: 10.0.0.0/16
  enable_dns_hostnames: true
  enable_dns_support: true
  internet_gateway: true
  nat_gateway:
    enabled: true
    subnet: subnet-public-a
  security_groups:
    - name: web-sg
      description: Allow HTTP/HTTPS
      ingress:
        - protocol: tcp
          port: 443
          cidr: 0.0.0.0/0
  flow_logs:
    enabled: true
    destination: arn:aws:s3:::vpc-flow-logs-bucket
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Network/AWS VPC |
|------|------------------------------------------------|
| [raise](../tools/raise.md) | Provisions AWS VPCs via raise-aws plugin |
