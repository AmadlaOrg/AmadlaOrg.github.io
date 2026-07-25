# Infrastructure/Cloud/Database

| Field | Value |
|-------|-------|
| **Purpose** | Common managed database properties — engine, version, instance class, backup retention |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Database](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/database@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud](infrastructure-cloud.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `engine` | string | Database engine (e.g., `postgres`, `mysql`, `mariadb`) |
| `engine_version` | string | Database engine version |
| `instance_class` | string | Compute instance size |
| `storage_size_gb` | integer | Allocated storage size in gigabytes |
| `multi_az` | boolean | Enable multi-AZ deployment for high availability |
| `backup_retention_days` | integer | Number of days to retain automated backups |
| `admin_username` | string | Administrator username |
| `admin_password_secret` | string | Secret reference for the administrator password |

## Sub-types

| Sub-type | Provider |
|----------|----------|
| [Database/RDS](infrastructure-cloud-database-rds.md) | AWS RDS |
| [Database/Cloud SQL](infrastructure-cloud-database-cloud-sql.md) | Google Cloud SQL |
| [Database/Azure Database](infrastructure-cloud-database-azure-database.md) | Azure Database |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/database@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud@v1.0.0
_body:
  engine: postgres
  engine_version: "16"
  instance_class: db.t3.medium
  storage_size_gb: 100
  multi_az: true
  backup_retention_days: 7
  admin_username: dbadmin
  admin_password_secret: doorman://vault/db-admin-password
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Database |
|------|------------------------------------------|
| [raise](../tools/raise.md) | Provisions managed database instances via provider-specific plugins |
