# Infrastructure/Cloud/Database/RDS

| Field | Value |
|-------|-------|
| **Purpose** | AWS RDS managed database configuration — instance class, storage type, subnet group, Performance Insights |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Database/AWS/RDS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/database/rds@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Database](infrastructure-cloud-database.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `db_instance_class` | string | RDS instance class (e.g., `db.t3.micro`) |
| `allocated_storage` | integer | Allocated storage in gigabytes |
| `storage_type` | string | Storage type (`gp3`, `io1`, `standard`) |
| `vpc_security_group_ids` | array of strings | VPC security group identifiers |
| `db_subnet_group_name` | string | DB subnet group name |
| `publicly_accessible` | boolean | Whether the instance is publicly accessible (default: `false`) |
| `performance_insights_enabled` | boolean | Enable Performance Insights monitoring |
| `deletion_protection` | boolean | Enable deletion protection |
| `parameter_group` | string | DB parameter group name |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/database/rds@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/database@v1.0.0
_body:
  engine: postgres
  engine_version: "16"
  db_instance_class: db.t3.medium
  allocated_storage: 100
  storage_type: gp3
  db_subnet_group_name: prod-db-subnets
  vpc_security_group_ids:
    - sg-db-access
  publicly_accessible: false
  performance_insights_enabled: true
  deletion_protection: true
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Database/RDS |
|------|----------------------------------------------|
| raise | Provisions RDS instances via raise-aws plugin |
