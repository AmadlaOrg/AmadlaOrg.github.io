# Application/ServiceDiscovery/Consul

| Field | Value |
|-------|-------|
| **Purpose** | Consul-specific configuration -- service mesh, health checking, and distributed KV store |
| **Repo** | [AmadlaOrg/Entities/Application/ServiceDiscovery/Consul](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/service-discovery/consul@v1.0.0` |
| **Parent type** | [Application/ServiceDiscovery](application-service-discovery.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `datacenter` | string | Consul datacenter name |
| `server` | boolean | Whether this agent runs in server mode (`true`) or client mode (`false`) |
| `bootstrap_expect` | integer | Number of server agents expected for quorum bootstrap |
| `retry_join` | array of strings | Addresses of other agents to join on startup |
| `ui_enabled` | boolean | Whether the Consul web UI is enabled |
| `encrypt_secret` | string | Doorman secret reference for the gossip encryption key |
| `acl.enabled` | boolean | Whether ACLs are enabled |
| `acl.default_policy` | string | Default ACL policy (`allow` or `deny`) |
| `acl.tokens` | object | Token configuration (e.g., initial_management, default) |
| `connect.enabled` | boolean | Whether Consul Connect (service mesh) is enabled |
| `dns_config.allow_stale` | boolean | Whether stale reads are allowed for DNS queries |
| `dns_config.max_stale` | string | Maximum staleness allowed for DNS responses (e.g., `5s`) |

## Example

```yaml
_type: amadla.org/entity/application/service-discovery/consul@v1.0.0
_extends: amadla.org/entity/application/service-discovery@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 8500
  data_dir: /var/lib/consul
  cluster_name: dc1
  datacenter: dc1
  server: true
  bootstrap_expect: 3
  retry_join:
    - 10.0.0.11
    - 10.0.0.12
    - 10.0.0.13
  ui_enabled: true
  encrypt_secret: doorman://vault/consul/gossip-key
  acl:
    enabled: true
    default_policy: deny
  connect:
    enabled: true
  dns_config:
    allow_stale: true
    max_stale: 5s
```

## Consumers

| Tool | How It Uses Application/ServiceDiscovery/Consul |
|------|--------------------------------------------------|
| lay | Installs the `consul` binary |
| weaver | Generates `/etc/consul.d/consul.hcl` |
| enjoin-service | Enables/starts `consul` service |
