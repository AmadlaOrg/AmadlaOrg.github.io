# Entity Stories & Scenarios

This document describes real-world scenarios that the Amadla entity system must support.
Each story tests different aspects of the contract model: requirements, alternatives, overrides, cross-entity data flow, and automatic tool dispatch.

---

## Story 1: WordPress — Full-Stack Web Application

### The Base Entity (published by WordPress community)

```
github.com/SomeOrg/WordPress/
  app.hery              # WordPress itself
  php.hery              # PHP runtime requirement
  database.hery         # Database requirement (alternatives)
  webserver.hery        # HTTP server requirement (alternatives)
  network.hery          # Network requirements
  templates/
    wp-config.hery      # Template entity for wp-config.php
```

#### app.hery
```yaml
_type: amadla.org/entity/application@v1.0.0
name: wordpress
description: WordPress CMS
install:
  - method: container
    image: wordpress:6.7-php8.3-fpm
  - method: package
    packages:
      - wordpress
  - method: binary
    source: https://wordpress.org/latest.tar.gz
```

#### php.hery
```yaml
_type: amadla.org/entity/application@v1.0.0
name: php
version: ["8.3", "8.2", "8.1"]   # first = default
install:
  - method: package
    packages:
      apt: [php8.3-fpm, php8.3-mysql, php8.3-xml, php8.3-curl]
      dnf: [php-fpm, php-mysqlnd, php-xml, php-curl]
  - method: container
    image: php:8.3-fpm
```

#### database.hery
```yaml
_type: amadla.org/entity/application/db/rdbms@v1.0.0
engine: [mariadb, mysql, postgresql]   # first = default
version:
  mariadb: ["11.4", "10.11"]
  mysql: ["8.4", "8.0"]
  postgresql: ["17", "16"]
databases:
  - name: wordpress
    encoding: UTF8
authentication:
  admin_user: wp_admin
  admin_password_secret: doorman://wordpress/db-password
```

#### webserver.hery
```yaml
_type: amadla.org/entity/application/webserver@v1.0.0
server_name: localhost
listen: [80, 443]
root: /var/www/wordpress
index: [index.php, index.html]
locations:
  - path: /
    try_files: "$uri $uri/ /index.php?$args"
  - path: "~ \\.php$"
    proxy_pass: "unix:/run/php/php-fpm.sock"
install:
  - method: package
    name: [nginx, apache2, caddy]   # first = default
```

#### network.hery
```yaml
_type: amadla.org/entity/system/network@v1.0.0
ports:
  - port: 80
    protocol: tcp
    description: HTTP
  - port: 443
    protocol: tcp
    description: HTTPS
  - port: 3306
    protocol: tcp
    description: Database
    expose: false   # internal only
```

#### templates/wp-config.hery
```yaml
_type: amadla.org/entity/template@v1.0.0
engine: jinja2
source: wp-config.php.j2
output: /var/www/wordpress/wp-config.php
description: WordPress configuration file
```

### What happens when you run `amadla` on this entity

1. **amadla** reads all .hery files, stores in hery
2. **amadla** calls `<tool> info` on all discovered tools
3. Tool-entity mapping:
   - `lay` supports Application, Application/DB, Application/WebServer → gets app.hery, php.hery, database.hery, webserver.hery
   - `weaver` supports Template (learned from template .hery files) → gets templates/wp-config.hery
   - `doorman` supports secrets (referenced in database.hery via `doorman://`) → resolves db-password
   - `judge` supports Application, Network → validates post-install
4. **Unresolved choices** → amadla prompts:
   - "Database engine? [mariadb] / mysql / postgresql"
   - "Web server? [nginx] / apache2 / caddy"
   - "Install method? [container] / package / binary"
5. **Data flows**: chosen port values flow to webserver config, database config, and wp-config template
6. **Execution order**: derived from `_requires` declarations in entities — amadla builds a DAG and topologically sorts. No hardcoded phases.

### Dev creates a specific deployment

A dev creates their own entity that locks in choices:

```
github.com/MyCompany/my-wordpress/
  amadla.hery           # includes base WordPress
  database.hery         # override: lock to MariaDB
  webserver.hery        # override: lock to nginx, change port
```

#### amadla.hery
```yaml
_type: github.com/SomeOrg/WordPress@v1.0.0
```
This pulls ALL element entities from the base WordPress entity.

#### database.hery
```yaml
_extends: github.com/SomeOrg/WordPress/database.hery
engine: mariadb
version: "11.4"
```
Overrides just the database element: locks engine to MariaDB 11.4. Deep merge keeps everything else (databases list, authentication).

#### webserver.hery
```yaml
_extends: github.com/SomeOrg/WordPress/webserver.hery
install:
  - method: package
    name: nginx
listen: [8080, 8443]
```
Overrides: locks to nginx, changes ports. The port change flows to network and template entities automatically.

### What amadla does now (no prompts needed)
All choices resolved → amadla runs the full pipeline without questions.

---

## Story 2: Go Microservice — Simple API Server

### The Entity

```
github.com/MyCompany/user-service/
  app.hery              # The Go service
  network.hery          # API port
  database.hery         # PostgreSQL dependency
  templates/
    config.hery         # Config file template
    systemd.hery        # Systemd unit file template
```

#### app.hery
```yaml
_type: amadla.org/entity/application@v1.0.0
name: user-service
description: User management API
install:
  - method: binary
    source: github.com/MyCompany/user-service
  - method: container
    image: mycompany/user-service:latest
command: ["/usr/local/bin/user-service", "--config", "/etc/user-service/config.yaml"]
restart_policy:
  condition: on-failure
  delay: 5s
  max_attempts: 3
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
  interval: 30s
  timeout: 5s
  retries: 3
```

#### database.hery
```yaml
_type: amadla.org/entity/application/db/rdbms@v1.0.0
engine: postgresql
version: "17"
databases:
  - name: users
    encoding: UTF8
schema_migrations:
  tool: goose
  directory: ./migrations
  auto_migrate: true
authentication:
  admin_password_secret: doorman://user-service/db-password
```

#### network.hery
```yaml
_type: amadla.org/entity/system/network@v1.0.0
ports:
  - port: 8080
    protocol: tcp
    description: API
  - port: 5432
    protocol: tcp
    description: PostgreSQL
    expose: false
```

### What's different from WordPress
- No alternatives — all choices pre-made (PostgreSQL, binary install)
- No prompts needed — amadla runs straight through
- Has systemd template → weaver renders unit file → lay can enable the service
- Schema migrations via goose — lay or a separate step runs `goose up`

---

## Story 3: Multi-Node Cluster — WordPress + Separate DB Server

### The Scenario
WordPress on Server A, MariaDB on Server B. This is where `conduct` comes in.

```
github.com/MyCompany/wp-production/
  amadla.hery
  conduct.hery          # Multi-node orchestration
  wp-node.hery          # Server A definition
  db-node.hery          # Server B definition
```

#### conduct.hery
```yaml
_type: amadla.org/entity/infrastructure@v1.0.0
nodes:
  - name: wp-server
    ref: wp-node.hery
    entities: [app.hery, php.hery, webserver.hery, network.hery]
  - name: db-server
    ref: db-node.hery
    entities: [database.hery]
```

#### wp-node.hery
```yaml
_type: amadla.org/entity/infrastructure/vm@v1.0.0
provider: libvirt
cpus: 2
memory: 4096
disk: 40G
box: ubuntu-24.04
```

### What happens
1. **amadla** sees Infrastructure entities → calls `raise` to provision VMs
2. **conduct** coordinates: runs `lay` on wp-server with WordPress entities, runs `lay` on db-server with database entity
3. Network entity ports flow to both nodes (WordPress needs to know DB server IP/port)
4. **doorman** resolves secrets on both nodes
5. **weaver** renders configs with correct cross-node addresses
6. **judge** validates both nodes post-setup

---

## Story 4: Firewall — Cross-Entity Auto-Wiring

### The Scenario
A firewall entity that automatically consumes network requirements from other entities.

```
github.com/AmadlaOrg/Entities/Firewall/
  firewall.hery
  templates/
    ufw.hery            # UFW rules template
    iptables.hery        # iptables rules template
    nftables.hery        # nftables rules template
```

#### firewall.hery
```yaml
_type: amadla.org/entity/application@v1.0.0
name: firewall
install:
  - method: package
    name: [ufw, nftables, iptables]
```

### How auto-wiring works
When a dev includes both WordPress entity and Firewall entity in their deployment:

1. Firewall's tool (or amadla itself) sees Network entity type in the WordPress entity
2. It collects ALL port definitions from network.hery
3. Passes them to the firewall template (weaver renders UFW/iptables/nftables rules)
4. Result: firewall rules automatically allow ports 80, 443 and block 3306 (expose: false)

The dev never manually writes firewall rules — they emerge from the network contracts.

---

## Story 5: Optional Dependencies — ElasticSearch for WordPress

### The Scenario
WordPress can optionally use ElasticSearch for better search. The base entity declares it as optional.

```
github.com/SomeOrg/WordPress/
  ...existing files...
  elasticsearch.hery    # Optional search engine
```

#### elasticsearch.hery
```yaml
_type: amadla.org/entity/application@v1.0.0
name: elasticsearch
optional: true          # Not required for WordPress to function
version: ["8.17", "7.17"]
install:
  - method: container
    image: elasticsearch:8.17.0
  - method: package
    packages:
      apt: [elasticsearch]
environment:
  discovery.type: single-node
  ES_JAVA_OPTS: "-Xms512m -Xmx512m"
```

### What happens
- By default, amadla skips optional entities (or prompts: "Include ElasticSearch? [no] / yes")
- If included, lay installs it, and the WordPress wp-config template conditionally enables the search plugin
- If not included, WordPress falls back to MySQL LIKE queries (no error, just degraded search)

---

## Cross-Cutting Concerns

### Secret Resolution Flow
1. Entity references secret: `admin_password_secret: doorman://wordpress/db-password`
2. amadla detects `doorman://` URI scheme
3. Calls `doorman get wordpress/db-password --from vault` (or whichever plugin)
4. Secret value injected into template rendering context (weaver) and environment variables

### Template Data Flow
1. amadla collects all resolved values (ports, paths, secrets, chosen alternatives)
2. Passes merged data context to weaver
3. weaver renders each Template entity using the appropriate engine plugin
4. Output files placed at specified paths

### Validation Flow (judge)
1. After lay installs everything and weaver renders configs
2. amadla calls judge with Application entities → judge-application checks binaries exist
3. amadla calls judge with Network entities → judge-network checks ports are listening
4. Exit code 0 = all good, exit code 1 = report what failed

---

## Design Questions — Resolved (2026-03-12)

These scenarios surfaced questions that have now been answered:

1. **_extends targeting**: Filename as path segment — `_extends: github.com/SomeOrg/WordPress/database.hery`. The filename is the element identity, used as a literal path segment in the URI. Unambiguous and consistent with `_type` URI patterns.

2. **Multi-doc files**: One addressable element = one file. Multi-doc YAML (`---`) is only for anonymous accumulation (e.g., multiple firewall rules). If an element needs to be individually addressable via `_extends`, it must be its own file.

3. **Optional entity syntax**: `optional: true` belongs in `_body` — it's application-specific data ("WordPress works without ElasticSearch" is part of the application's contract). Each entity type schema can define `optional` as a field. Optional entities are NOT listed in `_requires`.

4. **Cross-node data flow**: Runtime values (like DB server IP) are injected by `conduct` after `raise` provisions. conduct knows node IPs from raise output and injects them into the data context before calling weaver/lay on each node. Can also be pulled from unravel. `_requires` handles entity-level ordering; node placement is conduct's `_body` concern.

5. **Execution ordering**: Derived from `_requires` declarations — amadla builds a DAG and topologically sorts. No hardcoded phases. `_requires` is the 5th reserved [HERY](../architecture/hery-concepts.md) property (Draft 3.5). Independent branches can be parallelized. True cycles are detected and reported.

6. **Install method selection**: No runtime `--prefer` flag. Everything is declared in `.hery` files (IaC). Per-entity default is the first item in the install array. Override via `_extends` to lock a choice. Source of truth is always in `.hery` files — keeps the audit trail clean.
