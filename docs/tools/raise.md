# raise

| Field | Value |
|-------|-------|
| **Purpose** | Infrastructure provisioner — provisions servers and resources from entity requirements |
| **Repo** | [AmadlaOrg/raise](https://github.com/AmadlaOrg/raise) |

## Commands

| Command | Description |
|---------|-------------|
| `raise up` | Create and start infrastructure (VMs, cloud instances) |
| `raise halt` | Stop running infrastructure without destroying it |
| `raise destroy` | Remove infrastructure entirely |
| `raise ssh` | Connect to a provisioned machine |
| `raise status` | List all managed infrastructure and its state |
| `raise provision` | Run provisioning scripts on existing infrastructure |
| `raise settings` | Manage raise configuration |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |

## Pipeline Position

raise sits **after doorman** (secret resolution) and **before lay** (application installation). It provisions the infrastructure that applications will run on.

```
hery → doorman → [raise] → lay → weaver → judge
```

## Entity Types

| Entity | What raise Does |
|--------|----------------|
| [Infrastructure](../entities/infrastructure.md) | Provisions the declared infrastructure resources |
| [Infrastructure/VM](../entities/infrastructure-vm.md) | Creates and manages local virtual machines |
| [Infrastructure/Cloud](../entities/infrastructure-cloud.md) | Provisions cloud resources (compute, network, storage) |
| [Infrastructure/Container](../entities/infrastructure-container.md) | Sets up container infrastructure |

## Intended Design

raise will read `Infrastructure` declarations and provision the required resources. It manages the full lifecycle of infrastructure — creating, starting, stopping, and destroying machines — whether they are local VMs or cloud instances. This makes raise the Amadla equivalent of Vagrant, but unified with cloud provisioning under one tool.

raise uses a **plugin system** for different providers, translating entity requirements into provider-specific resource definitions.

### Plugins

| Plugin | Provider | Use Case |
|--------|----------|----------|
| `raise-libvirt` | KVM/QEMU | Local VMs on Linux (most native) |
| `raise-virtualbox` | VirtualBox | Cross-platform local VMs |
| `raise-wsl` | WSL2 | Windows Subsystem for Linux |
| [`raise-xen`](../plugins/raise-plugins.md#raise-xen) | Xen hypervisor | Xen domain images for Amadla Linux |
| `raise-oci` | OCI image builder | OCI images for A/B updates |
| `raise-vmware` | VMware Workstation/Fusion | VMware local VMs |
| `raise-aws` | AWS EC2 | Cloud instances |
| `raise-hetzner` | Hetzner Cloud | Cloud instances |
| `raise-digitalocean` | DigitalOcean | Cloud instances |
| `raise-opentofu` | OpenTofu/Terraform | Generic IaC provider bridge |

See [Raise Plugins](../plugins/raise-plugins.md) for the full plugin protocol and detailed specifications.

### Example Usage

```bash
# Local VM workflow (like Vagrant)
raise up my-dev-vm                   # Create and start a local VM from entity
raise ssh my-dev-vm                  # SSH into the VM
raise halt my-dev-vm                 # Stop the VM
raise destroy my-dev-vm              # Remove the VM

# Cloud workflow
raise up my-prod-server              # Provision a cloud instance from entity
raise status                         # List all managed infrastructure

# In a pipeline
hery query --type '*/Infrastructure@*' | doorman resolve | raise up
```

## Current Gaps

- Core raise tool is functional with plugin discovery and lifecycle management
- Three active plugins: libvirt, virtualbox, wsl
- `raise-xen` and `raise-oci` planned for Amadla Linux distro building
- Cloud provider plugins are stubs
