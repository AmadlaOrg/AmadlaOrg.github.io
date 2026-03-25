# Application/Proxy

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all forward proxy applications |
| **Repo** | [AmadlaOrg/Entities/Application/Proxy](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/proxy@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the proxy listens on |
| `listen_port` | integer | Port the proxy listens on |
| `acl` | array of objects | Access control list definitions |
| `acl[].name` | string | ACL name (required) |
| `acl[].type` | string | ACL type: `src`, `dst`, `dstdomain`, or `url_regex` (required) |
| `acl[].values` | array of strings | ACL match values (required) |
| `allowed_ports` | array of integers | Ports allowed through the proxy |
| `auth_required` | boolean | Whether authentication is required |

These properties are common across all forward proxy implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [Proxy/Squid](application-proxy-squid.md) | Squid — full-featured caching proxy |
| [Proxy/Privoxy](application-proxy-privoxy.md) | Privoxy — privacy-enhancing filtering proxy |
| [Proxy/Tinyproxy](application-proxy-tinyproxy.md) | Tinyproxy — lightweight HTTP proxy |

## Example

```yaml
_type: amadla.org/entity/application/proxy@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 3128
  acl:
    - name: localnet
      type: src
      values:
        - 10.0.0.0/8
        - 172.16.0.0/12
        - 192.168.0.0/16
  allowed_ports:
    - 80
    - 443
  auth_required: false
```

## Consumers

| Tool | How It Uses Application/Proxy |
|------|-------------------------------|
| [lay](../tools/lay.md) | Installs the proxy application |
| enjoin-service | Enables/starts the proxy service |
| [weaver](../tools/weaver.md) | Generates proxy configuration files |
