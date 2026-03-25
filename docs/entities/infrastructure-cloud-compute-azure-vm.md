# Infrastructure/Cloud/Compute/Azure VM

| Field | Value |
|-------|-------|
| **Purpose** | Azure VM-specific compute instance properties — VM size, resource group, OS disk, image reference |
| **Repo** | [AmadlaOrg/Entities/Infrastructure/Cloud/Compute/Azure/VM](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/infrastructure/cloud/compute/azure-vm@v1.0.0` |
| **Parent type** | [Infrastructure/Cloud/Compute](infrastructure-cloud-compute.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `vm_size` | string | Azure VM size (e.g., `Standard_B2s`, `Standard_D4s_v3`) |
| `resource_group` | string | Azure resource group name |
| `vnet_name` | string | Virtual network name |
| `subnet_name` | string | Subnet name within the virtual network |
| `nsg_name` | string | Network security group name |
| `os_disk` | object | OS disk configuration |
| `os_disk.caching` | string | OS disk caching mode (e.g., `ReadWrite`, `ReadOnly`, `None`) |
| `os_disk.storage_account_type` | string | Managed disk type (`Standard_LRS`, `Premium_LRS`, `StandardSSD_LRS`) |
| `source_image_reference` | object | Source image reference (`publisher`, `offer`, `sku`, `version`) |
| `admin_username` | string | Administrator username for the VM |
| `admin_ssh_key` | string | SSH public key for admin authentication |

**Required:** `vm_size`, `resource_group`

## Example

```yaml
_type: amadla.org/entity/infrastructure/cloud/compute/azure-vm@v1.0.0
_extends: amadla.org/entity/infrastructure/cloud/compute@v1.0.0
_body:
  vm_size: Standard_B2s
  resource_group: prod-rg
  vnet_name: prod-vnet
  subnet_name: web-subnet
  nsg_name: web-nsg
  os_disk:
    caching: ReadWrite
    storage_account_type: Premium_LRS
  source_image_reference:
    publisher: Canonical
    offer: 0001-com-ubuntu-server-jammy
    sku: 22_04-lts
    version: latest
  admin_username: azureuser
```

## Consumers

| Tool | How It Uses Infrastructure/Cloud/Compute/Azure VM |
|------|--------------------------------------------------|
| [raise](../tools/raise.md) | Provisions Azure VMs via raise-azure plugin |
