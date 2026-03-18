# Application/DB

| Field | Value |
|-------|-------|
| **Purpose** | Defines database application configuration — engine, authentication, databases to create |
| **Repo** | [AmadlaOrg/Entities/Application/DB](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/db@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

Application/DB describes database requirements:

- Database engine (postgresql, mysql, mariadb, mongodb, redis, sqlite)
- Engine version
- Listening port and data directory
- Max connections
- Authentication method and admin credentials (password via doorman secret)
- Databases to create (name, owner, encoding)
- Engine-specific config overrides

## Example

```yaml
_type: amadla.org/entity/application/db@v1.0.0
_body:
  engine: postgresql
  version: "16"
  port: 5432
  data_dir: /var/lib/postgresql/16/main
  max_connections: 200
  authentication:
    method: scram-sha-256
    admin_user: postgres
    admin_password_secret: db/postgres/admin-password
  databases:
    - name: my_app
      owner: app_user
      encoding: UTF8
    - name: my_app_test
      owner: app_user
  config:
    shared_buffers: "256MB"
    work_mem: "16MB"
    max_wal_size: "1GB"
```

## Consumers

| Tool | How It Uses Application/DB |
|------|----------------------------------|
| lay | Installs and configures the database engine |
| doorman | Resolves `admin_password_secret` |
| weaver | Generates database configuration files |
| judge-application | Validates database is installed and running correctly |

## Sub-types

| Sub-type | Purpose |
|----------|---------|
| [DB/RDBMS](application-db-rdbms.md) | Relational-specific: migrations, replication, backup, connection pooling |
