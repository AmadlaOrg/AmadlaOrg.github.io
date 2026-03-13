# EntityApplication/DB/RDBMS

| Field | Value |
|-------|-------|
| **Purpose** | Defines relational database-specific configuration — migrations, replication, backup, connection pooling |
| **Repo** | [AmadlaOrg/Entities/Application/DB/RDBMS](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/db/rdbms@v1.0.0` |
| **Parent type** | [EntityApplication/DB](entity-application-db.md) |

## Schema

EntityApplication/DB/RDBMS extends the DB entity with relational-specific features:

- Schema migrations: tool (flyway, liquibase, goose, alembic), directory, auto-migrate flag
- Replication: role (primary/replica/standby), primary host, synchronous mode
- Backup: enabled flag, cron schedule, retention days, destination path/URI
- Connection pooling: tool (pgbouncer, proxysql), max pool size, mode (session/transaction/statement)

## Example

```yaml
_type: amadla.org/entity/application/db/rdbms@v1.0.0
_body:
  schema_migrations:
    tool: goose
    directory: /opt/my-app/migrations
    auto_migrate: true

  replication:
    role: primary
    synchronous: false

  backup:
    enabled: true
    schedule: "0 3 * * *"
    retention_days: 14
    destination: s3://my-backups/postgres/

  connection_pooling:
    enabled: true
    tool: pgbouncer
    max_pool_size: 50
    mode: transaction
```

## Consumers

| Tool | How It Uses EntityApplication/DB/RDBMS |
|------|----------------------------------------|
| lay | Installs migration tools, poolers, backup agents |
| weaver | Generates replication and pooler configuration |
| judge-application | Validates replication status and backup schedule |
