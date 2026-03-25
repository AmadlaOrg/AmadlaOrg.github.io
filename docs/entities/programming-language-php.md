# ProgrammingLanguage/PHP

| Field | Value |
|-------|-------|
| **Purpose** | Defines PHP runtime configuration — extensions, php.ini, FPM pools, Composer |
| **Repo** | [AmadlaOrg/Entities/ProgrammingLanguage/PHP](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/programming-language/php@v1.0.0` |
| **Parent type** | [ProgrammingLanguage](programming-language.md) |

## Schema

ProgrammingLanguage/PHP extends the ProgrammingLanguage entity with PHP-specific features:

- PHP extensions to install (e.g., pdo_mysql, gd, redis, xdebug)
- php.ini directives as key-value pairs
- PHP-FPM configuration: enabled flag, pool definitions (name, user, group, listen socket, process manager settings)
- Composer: install flag, global packages
- SAPIs to install: cli, fpm, apache2, cgi

## Example

```yaml
_type: amadla.org/entity/programming-language/php@v1.0.0
_body:
  extensions:
    - pdo_mysql
    - gd
    - redis
    - opcache
    - intl
  ini:
    memory_limit: 256M
    upload_max_filesize: 64M
    post_max_size: 64M
    max_execution_time: 30
    opcache.enable: 1
    opcache.memory_consumption: 128
  fpm:
    enabled: true
    pools:
      - name: www
        user: www-data
        group: www-data
        listen: /run/php/php-fpm.sock
        pm: dynamic
        pm_max_children: 10
        pm_start_servers: 3
        pm_min_spare_servers: 2
        pm_max_spare_servers: 5
        pm_max_requests: 1000
  composer:
    install: true
    global_packages:
      - laravel/installer
  sapi:
    - cli
    - fpm
```

## Consumers

| Tool | How It Uses ProgrammingLanguage/PHP |
|------|-------------------------------------------|
| [lay](../tools/lay.md) | Installs PHP, extensions, SAPIs, and Composer |
| [weaver](../tools/weaver.md) | Generates php.ini and FPM pool configuration files |
| [judge-application](../plugins/judges.md) | Validates PHP version, extensions, and FPM configuration |
