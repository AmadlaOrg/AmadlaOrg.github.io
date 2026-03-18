# Entities Overview

Entities are the core data model of the Amadla ecosystem. Each entity type defines a **schema** for a specific kind of requirement — applications, systems, infrastructure, secrets, etc.

## What Are Entities?

In Amadla, an entity is a versioned, schema-validated YAML document that describes a requirement. Instead of writing imperative scripts ("install nginx, configure it like this"), you write declarative entities ("this application needs nginx >=1.24 with TLS").

Entity definitions live in the `Entities/` directory structure, each with a `<name>.hery.json` schema file at its root (e.g., `application.hery.json`, `package.hery.json`):

```
Entities/
├── Application/          # + DB/, IAM/, WebServer/, Timekeeping/, Logging/,
│                         #   Monitoring/, Backup/, DNSResolver/, MailRelay/, LogShipping/
├── Container/
├── Cron/
├── Infrastructure/       # + Cloud/, Container/, VM/
├── Judge/
├── OS/                   # + Preference/
├── Package/
├── ProgrammingLanguage/  # + PHP/
├── Secret/
├── Security/             # + Certificate/, Firewall/, IDS/, Network/, SELinux/
├── Service/
├── System/               # + CPU/, Filesystem/, Memory/, Network/
├── Template/
├── Tools/
└── User/
```

## Entity Types

### Top-level types

| Entity | Describes | Used By |
|--------|-----------|---------|
| [Application](application.md) | Application requirements (packages, services, healthchecks) | lay, waiter, judge |
| [Container](container.md) | Container/image definitions (Docker Compose-inspired) | lay, waiter |
| [Cron](cron.md) | Scheduled tasks (cron expressions, systemd timers) | enjoin |
| [Infrastructure](infrastructure.md) | Infrastructure requirements (provider, region, SSH) | raise |
| [Judge](judge.md) | Audit/validation rule definitions | judge |
| [OS](os.md) | Operating system identity (distro, version, arch, init) | lay, enjoin, raise, unravel |
| [Package](package.md) | System package installation (apt, yum, dnf, pacman, brew) | lay, garbage |
| [ProgrammingLanguage](programming-language.md) | Language runtime requirements | lay |
| [Secret](secret.md) | Secret references and metadata | doorman |
| [Security](security.md) | Security posture and baseline configuration | enjoin, judge |
| [Service](service.md) | Systemd service configuration | enjoin, weaver |
| [System](system.md) | System configuration (hostname, timezone, sysctl, limits) | enjoin, raise |
| [Template](template.md) | Template configuration (engine, source, output) | weaver |
| [Tools](tools.md) | Tool inventory and discovery configuration | amadla |
| [User](user.md) | System users and groups | enjoin, doorman |

### Sub-types

| Entity | Parent | Describes | Used By |
|--------|--------|-----------|---------|
| [Application/DB](application-db.md) | Application | Database engine, auth, databases to create | lay, doorman |
| [Application/DB/RDBMS](application-db-rdbms.md) | Application/DB | Migrations, replication, backup, connection pooling | lay, weaver |
| [Application/IAM](application-iam.md) | Application | Identity providers, OAuth2/OIDC clients, users | lay, doorman |
| [Application/WebServer](application-webserver.md) | Application | Virtual hosts, locations, SSL, proxying | lay, weaver |
| [Application/Timekeeping](application-timekeeping.md) | Application | Time synchronization (common: servers, pools) | lay, enjoin-service |
| [Application/Timekeeping/NTP](application-timekeeping-ntp.md) | Application/Timekeeping | ntpd configuration | lay, weaver |
| [Application/Timekeeping/Chrony](application-timekeeping-chrony.md) | Application/Timekeeping | chrony configuration | lay, weaver |
| [Application/Timekeeping/Timesyncd](application-timekeeping-timesyncd.md) | Application/Timekeeping | systemd-timesyncd configuration | enjoin |
| [Application/Timekeeping/OpenNTPD](application-timekeeping-openntpd.md) | Application/Timekeeping | OpenNTPD configuration | lay, weaver |
| [Application/Timekeeping/PTP](application-timekeeping-ptp.md) | Application/Timekeeping | Precision Time Protocol (linuxptp) | lay, weaver |
| [Application/Logging](application-logging.md) | Application | Log management (common: log_dir, retention, remote) | lay, weaver |
| [Application/Monitoring](application-monitoring.md) | Application | Monitoring agents (common: listen, interval, tags) | lay, weaver |
| [Application/Backup](application-backup.md) | Application | Backup (common: schedule, retention, encryption, paths) | lay, weaver |
| [Application/DNSResolver](application-dns-resolver.md) | Application | Local DNS resolution/caching | lay, weaver |
| [Application/MailRelay](application-mail-relay.md) | Application | System mail relay (common: relay_host, TLS, auth) | lay, weaver |
| [Application/LogShipping](application-log-shipping.md) | Application | Centralized log forwarding (common: inputs, output) | lay, weaver |
| [Infrastructure/Cloud](infrastructure-cloud.md) | Infrastructure | Cloud instances (AWS, Hetzner, DigitalOcean) | raise |
| [Infrastructure/Container](infrastructure-container.md) | Infrastructure | Container runtime setup, registry access | raise, lay |
| [Infrastructure/VM](infrastructure-vm.md) | Infrastructure | Virtual machines (libvirt, VirtualBox, VMware) | raise |
| [OS/Preference](os-preference.md) | OS | Preferred system tools per concern | lay, enjoin |
| [ProgrammingLanguage/PHP](programming-language-php.md) | ProgrammingLanguage | PHP extensions, php.ini, FPM pools, Composer | lay, weaver |
| [Security/Certificate](security-certificate.md) | Security | TLS/SSL certificate provisioning | enjoin-certificate |
| [Security/Firewall](security-firewall.md) | Security | Firewall rules, default policies, NAT, rate limiting | enjoin-firewall |
| [Security/IDS](security-ids.md) | Security | Intrusion detection/prevention (fail2ban, OSSEC) | enjoin |
| [Security/Network](security-network.md) | Security | Network security posture: TLS, isolation, hardening | enjoin-network |
| [Security/SELinux](security-selinux.md) | Security | SELinux policies, booleans, contexts | enjoin-selinux |
| [System/CPU](system-cpu.md) | System | CPU resource constraints | enjoin, raise |
| [System/Filesystem](system-filesystem.md) | System | Volumes, mounts, tmpfs | enjoin-filesystem |
| [System/Memory](system-memory.md) | System | Memory resource constraints | enjoin, raise |
| [System/Network](system-network.md) | System | Network configuration (IPAM, ports, DNS) | enjoin-network, raise |

## Custom Entities

The built-in entity types listed above have direct support in Amadla's tools — each tool knows how to read and act on specific entity types via its `info` response. But you are **not locked in** to only using these types.

You can create your own entity types with your own JSON Schemas. Custom entities won't be handled by the built-in tools (they don't know about your schema), with one exception: **weaver**. Because weaver's routing is driven by the [Template](template.md) entity's `entity_types` field, you can write templates that target any entity type — including your own custom ones. Weaver doesn't care what the entity type is, only that a template declares it can render for it.

For anything beyond templating, you can write your own tools that understand your custom entities. These tools just need to follow the [plugin protocol](../architecture/plugin-system.md) (stdin/stdout, `info` subcommand, exit codes) and can be added to your [tools.hery](tools.md) so that the `amadla` orchestrator discovers and runs them alongside the built-in tools.

```yaml
# Your custom entity
_type: myorg.com/entity/monitoring@v1.0.0
_body:
  agent: datadog
  api_key_secret: monitoring/datadog/api-key
  checks:
    - name: nginx
      port: 80

# A template that targets your custom entity
_type: amadla.org/entity/template@v1.0.0
_body:
  engine: jinja2
  source: ./templates/datadog.yaml.j2
  output: /etc/datadog-agent/conf.d/nginx.yaml
  entity_types:
    - myorg.com/entity/monitoring@^v1.0.0

# Your custom tool in tools.hery
_type: amadla.org/entity/tools@v1.0.0
_body:
  tools:
    - name: hery
    - name: lay
    - name: weaver
    - name: my-monitoring-tool
      path: /opt/myorg/bin/my-monitoring-tool
```

## How Entities Connect

Entities compose via JSON Schema `$ref`. The schema declares which parts of `_body` correspond to other entity types. No [HERY](../architecture/hery-concepts.md)-specific markup is needed inside `_body` — composition is handled at the schema level.

Entities declare dependencies using `_requires` — the 5th reserved HERY property (Draft 3.5). amadla builds a dependency graph (DAG) from `_requires` declarations and topologically sorts to determine execution order.

```
Application (my-web-app)
├── _requires:
│   └── amadla.org/entity/application/db/rdbms@^v1.0.0
└── _body:
    ├── network (via $ref to Network schema)
    ├── database (via $ref to Database schema)
    ├── secrets (via $ref to Secret schema)
    └── infrastructure (via $ref to Infrastructure schema)
```

The directory path determines merge behavior: same path = override (deep merge, child wins), different path = accumulate (new entry).

Entity identity is derived from the git path (directory position in repo), not declared in the document. One addressable element = one file — multi-document YAML is only for anonymous accumulation.

This graph is what makes Amadla **resource-centric**: each resource declares its own requirements, and those requirements flow outward to inform provisioning, configuration, deployment, and auditing.

## Schema Validation

Every entity's `_body` is validated against a JSON Schema defined in the entity's repository. This ensures:

- Consistent data structure across all instances
- Early detection of configuration errors
- Machine-readable requirement definitions

## Entity Development

Entity types are developed alongside tools, driven by quickstart demos:

1. **nginx-hello** — static files, no container (hery, weaver, lay)
2. **nginx-container** — single container (+ waiter, Quadlet)
3. **wordpress-compose** — multi-container (+ doorman, multi-container entities)
4. **wordpress-multi** — two nodes (+ conduct, topology entity)

Each quickstart reveals which entities are actually needed — no speculative entity design.
