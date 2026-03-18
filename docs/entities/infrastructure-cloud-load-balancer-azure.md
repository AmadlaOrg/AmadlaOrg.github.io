# Infrastructure/Cloud/LoadBalancer/Azure

| Field | Value |
|-------|-------|
| **Purpose** | Azure Load Balancer configuration — SKU, frontend IPs, backend pools, probes, rules |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/LoadBalancer/Azure/AzureLB](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/load-balancer/azure@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/LoadBalancer](infrastructure-cloud-load-balancer.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `name` | string | Name of the Azure Load Balancer |
| `resource_group` | string | Azure resource group |
| `sku` | string | SKU tier (`Basic`, `Standard`) |
| `frontend_ip_configurations` | array of objects | Frontend IP configurations (`name`, `public_ip_address_id`, `subnet_id`) |
| `backend_address_pools` | array of objects | Backend address pool definitions (`name`) |
| `probes` | array of objects | Health probe configurations (`name`, `protocol`, `port`, `request_path`, `interval_in_seconds`) |
| `rules` | array of objects | Load balancing rules (`name`, `protocol`, `frontend_port`, `backend_port`, `frontend_ip_configuration_name`, `backend_address_pool_name`, `probe_name`) |

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/load-balancer/azure@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/load-balancer@v1.0.0
_body:
  name: web-lb
  resource_group: prod-rg
  sku: Standard
  frontend_ip_configurations:
    - name: web-frontend
      public_ip_address_id: /subscriptions/.../web-pip
  backend_address_pools:
    - name: web-pool
  probes:
    - name: web-probe
      protocol: HTTP
      port: 8080
      request_path: /health
      interval_in_seconds: 15
  rules:
    - name: web-rule
      protocol: Tcp
      frontend_port: 443
      backend_port: 8080
      frontend_ip_configuration_name: web-frontend
      backend_address_pool_name: web-pool
      probe_name: web-probe
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/LoadBalancer/Azure |
|------|---------------------------------------------------|
| raise | Provisions Azure Load Balancers via raise-azure plugin |
