# Infrastructure/Cloud/Database/Cloud SQL

| Field | Value |
|-------|-------|
| **Purpose** | Google Cloud SQL managed database configuration — tier, availability type, IP configuration, backup |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Database/GCP/CloudSQL](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/database/cloud-sql@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Database](infrastructure-cloud-database.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `tier` | string | Machine tier (e.g., `db-f1-micro`, `db-custom-2-8192`) |
| `database_version` | string | Database version (e.g., `POSTGRES_16`, `MYSQL_8_0`) |
| `region` | string | GCP region for the instance |
| `availability_type` | string | Availability type (`REGIONAL`, `ZONAL`) |
| `ip_configuration` | object | IP and network configuration (`ipv4_enabled`, `private_network`, `authorized_networks[]`) |
| `backup_configuration` | object | Backup configuration (`enabled`, `start_time`, `point_in_time_recovery_enabled`) |
| `flags` | array of objects | Database flags for custom configuration (`name`, `value`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/database/cloud-sql@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/database@v1.0.0
_body:
  tier: db-custom-2-8192
  database_version: POSTGRES_16
  region: us-central1
  availability_type: REGIONAL
  ip_configuration:
    ipv4_enabled: false
    private_network: projects/my-project/global/networks/default
  backup_configuration:
    enabled: true
    start_time: "03:00"
    point_in_time_recovery_enabled: true
  flags:
    - name: max_connections
      value: "200"
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Database/Cloud SQL |
|------|---------------------------------------------------|
| raise | Provisions Cloud SQL instances via raise-gcp plugin |
