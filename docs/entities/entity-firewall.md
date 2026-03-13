# EntityFirewall

| Field | Value |
|-------|-------|
| **Purpose** | Defines firewall rules — iptables, nftables, ufw, or firewalld |
| **Repo** | [AmadlaOrg/Entities/Firewall](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/firewall@v1.0.0` |

## Schema

EntityFirewall describes firewall configuration:

- Backend selection: iptables, nftables, ufw, firewalld (auto-detected if omitted)
- Default policies for input, forward, and output chains
- Rules: chain, action (accept/drop/reject/log), protocol, port/range, source/destination CIDR, interface, connection state, comment
- NAT rules: SNAT, DNAT, masquerade with source/destination/interface

## Example

```yaml
_type: amadla.org/entity/firewall@v1.0.0
_body:
  backend: nftables
  default_policy:
    input: drop
    forward: drop
    output: accept
  rules:
    - name: allow-ssh
      action: accept
      protocol: tcp
      port: 22
      comment: "SSH access"

    - name: allow-http
      action: accept
      protocol: tcp
      port: 80

    - name: allow-https
      action: accept
      protocol: tcp
      port: 443

    - name: allow-established
      action: accept
      state: established

  nat:
    - type: masquerade
      interface: eth0
```

## Consumers

| Tool | How It Uses EntityFirewall |
|------|---------------------------|
| lay | Configures firewall rules using the detected or specified backend |
| judge | Validates that firewall rules match requirements |
