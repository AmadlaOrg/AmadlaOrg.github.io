# raise

| Field | Value |
|-------|-------|
| **Purpose** | Infrastructure provisioner — provisions servers and resources from entity requirements |
| **Repo** | [AmadlaOrg/raise](https://github.com/AmadlaOrg/raise) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `raise info` | Active | Output raise metadata as JSON (aggregates plugin entity types) |
| `raise up` | Active | Create and start infrastructure (VMs, cloud instances) |
| `raise halt` | Active | Stop running infrastructure without destroying it |
| `raise destroy` | Active | Remove infrastructure entirely |
| `raise ssh` | Active | Connect to a provisioned machine |
| `raise status` | Active | List all managed infrastructure and its state |
| `raise plugins` | Active | List discovered raise-* plugins |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |

## Pipeline Position

raise sits **after doorman** (secret resolution) and **before lay** (application installation). It provisions the infrastructure that applications will run on.

```
hery → doorman → [raise] → lay → enjoin → weaver → waiter → judge
```

## Design

raise reads Infrastructure entity declarations and provisions the required resources. It manages the full lifecycle of infrastructure — creating, starting, stopping, and destroying machines — whether they are local VMs or cloud instances. This makes raise the Amadla equivalent of Vagrant, but unified with cloud provisioning under one tool.

### Entity Type Routing

raise core declares only **Infrastructure** as its own entity type. Additional entity types are aggregated from installed plugins:

- `raise info` discovers all `raise-*` plugins on PATH and calls each plugin's `info` subcommand
- Plugin-reported entity types (e.g., `Infrastructure/VM` from raise-libvirt) are merged into raise's `info` output
- The amadla orchestrator sees the full set and routes entities accordingly
- raise reads the `provider` field from the Infrastructure entity to dispatch to the correct plugin

This means adding a new plugin (e.g., `raise-kubernetes`) automatically surfaces its entity types — raise core never needs to change.

### Provider Resolution

The `--provider` flag is optional. If omitted, raise reads the `provider` field from the entity file passed via `-f`:

```bash
raise up my-vm -f infrastructure.hery              # auto-detects provider from entity
raise up my-vm --provider libvirt -f vm.hery       # explicit provider override
```

raise uses a **plugin system** for different providers, translating entity requirements into provider-specific resource definitions.

### Plugins

| Plugin | Provider | Use Case | Status |
|--------|----------|----------|--------|
| `raise-libvirt` | KVM/QEMU | Local VMs on Linux (most native) | Active |
| `raise-virtualbox` | VirtualBox | Cross-platform local VMs | Active |
| `raise-wsl` | WSL2 | Windows Subsystem for Linux | Active |
| `raise-aws` | AWS EC2 | Cloud instances (EC2 via aws CLI) | Active |
| `raise-digitalocean` | DigitalOcean | Cloud instances (Droplets via doctl) | Active |
| `raise-quickemu` | Quickemu | Desktop VMs via quickget/quickemu | Active |
| `raise-opentofu` | OpenTofu/Terraform | Declarative IaC bridge (tofu CLI) | Active |
| [`raise-xen`](../plugins/raise-plugins.md#raise-xen-planned) | Xen hypervisor | Xen domain images for Amadla Linux | Planned |
| `raise-oci` | OCI image builder | OCI images for A/B updates | Planned |
| `raise-hetzner` | Hetzner Cloud | Cloud instances | Stub |

See [Raise Plugins](../plugins/raise-plugins.md) for the full plugin protocol and detailed specs.

### Example Usage

```bash
# Local VM workflow (like Vagrant)
raise up my-dev-vm -f infrastructure.hery    # Auto-detects provider from entity
raise ssh my-dev-vm --provider libvirt           # SSH into the VM
raise halt my-dev-vm --provider libvirt          # Stop the VM
raise destroy my-dev-vm --provider libvirt       # Remove the VM

# Cloud workflow
raise up my-prod-server -f infrastructure.hery
raise status                                 # List all managed infrastructure

# In a pipeline
amadla run --config tools.hery -f .
```

## Current Status

- Core raise tool is complete with `info` (aggregated entity types), plugin discovery, provider auto-detection, and lifecycle management
- Seven active plugins: libvirt, virtualbox, wsl, aws, digitalocean, quickemu, opentofu
- `raise-xen` and `raise-oci` planned for Amadla Linux distro building
- Hetzner plugin is a stub
