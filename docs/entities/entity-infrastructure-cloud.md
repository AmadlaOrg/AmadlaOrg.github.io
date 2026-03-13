# EntityInfrastructure/Cloud

| Field | Value |
|-------|-------|
| **Purpose** | Defines cloud instance provisioning — instance type, image, networking, volumes |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud@v1.0.0` |
| **Parent type** | [EntityInfrastructure](entity-infrastructure.md) |

## Schema

EntityInfrastructure/Cloud describes cloud instance requirements:

- Instance type/size (e.g., t3.micro, cx21, s-1vcpu-1gb)
- OS image ID or name
- VPC, subnet, and security groups
- SSH key pair name
- Public IP assignment
- Attached volumes (size, type, mount point)
- Cloud-init user data
- Spot instance configuration (flag and max price)

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  instance_type: cx21
  image: debian-12
  key_name: deploy-key
  public_ip: true
  security_groups:
    - web-servers
    - ssh-access
  volumes:
    - size: 50
      type: ssd
      mount_point: /data
  user_data: |
    #!/bin/bash
    apt-get update && apt-get install -y nginx
```

### Spot instance example

```yaml
_type: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  instance_type: t3.large
  image: ami-0123456789abcdef0
  vpc: vpc-abc123
  subnet: subnet-def456
  spot: true
  max_price: "0.05"
```

## Consumers

| Tool | How It Uses EntityInfrastructure/Cloud |
|------|----------------------------------------|
| raise | Provisions cloud instances via raise-aws, raise-hetzner, raise-digitalocean plugins |
| conduct | Coordinates multi-cloud deployments |
