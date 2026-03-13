# EntitySystem/Net

| Field | Value |
|-------|-------|
| **Purpose** | Defines network configuration — inspired by Docker Compose networking |
| **Repo** | [AmadlaOrg/Entities/System/Net](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/system/net@v1.0.0` |
| **Parent type** | [EntitySystem](entity-system.md) |

## Schema

EntitySystem/Net describes network configuration:

- Network definitions: name, driver (bridge/host/overlay/macvlan), driver options, labels
- IPAM configuration: driver, subnets, IP ranges, gateways
- Network flags: internal, IPv6, attachable
- DNS servers, options, and search domains
- Hostname and domain name
- MAC address and network mode
- Exposed ports and port mappings (short and long syntax)
- Extra hosts (/etc/hosts entries)

## Example

```yaml
_type: amadla.org/entity/system/net@v1.0.0
_body:
  network:
    name: app-network
    driver: bridge
    ipam:
      config:
        - subnet: 172.28.0.0/16
          gateway: 172.28.0.1
    internal: false
    enable_ipv6: false

  hostname: web-server
  dns:
    - 8.8.8.8
    - 8.8.4.4

  ports:
    - target: 80
      published: 8080
      protocol: tcp
    - "443:443"

  extra_hosts:
    db.local: 192.168.1.100
```

## Consumers

| Tool | How It Uses EntitySystem/Net |
|------|------------------------------|
| lay | Configures network interfaces and DNS |
| raise | Creates virtual networks for VMs/containers |
| weaver | Generates network configuration files |
| judge | Validates network configuration matches requirements |
