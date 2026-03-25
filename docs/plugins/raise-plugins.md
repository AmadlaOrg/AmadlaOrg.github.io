# Raise Plugins

Raise plugins integrate with specific infrastructure providers. Each plugin knows how to provision, manage, and destroy infrastructure on one platform, translating `Infrastructure` and `Infrastructure/VM` entities into provider-specific operations.

## Plugin Inventory

### Active

| Plugin | Provider | Language | Notes |
|--------|----------|----------|-------|
| `raise-libvirt` | KVM/QEMU via libvirt | Go | Local Linux VMs, reference implementation |
| `raise-virtualbox` | VirtualBox | Go | Cross-platform local VMs |
| `raise-wsl` | Windows Subsystem for Linux | Go | WSL2 distro management |

### Planned

| Plugin | Provider | Use Case |
|--------|----------|----------|
| `raise-xen` | Xen hypervisor | Xen PVH/HVM domain images for Amadla Linux |
| `raise-oci` | OCI image builder | OCI container/system images for A/B updates |
| `raise-vmware` | VMware Workstation/Fusion | VMware local VMs |
| `raise-aws` | AWS EC2 | Cloud instances |
| `raise-hetzner` | Hetzner Cloud | Cloud instances |
| `raise-digitalocean` | DigitalOcean | Cloud instances |
| `raise-opentofu` | OpenTofu/Terraform | Generic IaC provider bridge |

## Protocol

Raise plugins follow the standard [Plugin Protocol](../architecture/plugin-system.md):

```bash
# Plugin metadata
raise-libvirt info
# {"name": "raise-libvirt", "version": "1.0.0", "engine": "libvirt",
#  "supports": ["amadla.org/entity/infrastructure@^v1.0.0", "amadla.org/entity/infrastructure/vm@^v1.0.0"], ...}

# Provision infrastructure (entity in via -f flag or stdin)
raise-libvirt up my-vm -f vm-entity.yaml

# Manage lifecycle
raise-libvirt halt my-vm
raise-libvirt destroy my-vm
raise-libvirt ssh my-vm
raise-libvirt status my-vm
raise-libvirt status              # all managed infrastructure
```

### Required Subcommands

| Command | Purpose | stdin/flag | stdout |
|---------|---------|-----------|--------|
| `info` | Plugin metadata | — | JSON metadata |
| `up [name]` | Provision infrastructure | `-f` entity file | JSON state |
| `halt <name>` | Stop infrastructure | — | — |
| `destroy <name>` | Remove infrastructure | — | — |
| `ssh <name>` | Shell into infrastructure | — | (exec replaces process) |
| `status [name]` | Query state | — | JSON state(s) |

### Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Operational failure |
| `2` | Usage error |

## raise-xen

| Field | Value |
|-------|-------|
| **Purpose** | Build and manage Xen PVH/HVM domain images for Amadla Linux |
| **Repo** | [AmadlaOrg/raise-xen](https://github.com/AmadlaOrg/raise-xen) (planned) |
| **Status** | Planned |

### What It Does

`raise-xen` creates Xen-compatible domain images from `Infrastructure/VM/Template` entities. It is the primary plugin for building the Amadla Linux distro — producing dom0 root images, domain templates (desktop-base, browser, server-base, etc.), and disposable domain images.

Unlike `raise-libvirt` (which manages running VMs), `raise-xen` focuses on **image building** — producing squashfs or ext4 images that the Xen domain manager boots at runtime.

### Supported Entities

| Entity Type | What raise-xen produces |
|-------------|------------------------|
| `Infrastructure/VM/Template` | Read-only domain template images (squashfs) |
| `Infrastructure/VM` | Domain-specific image overlays |
| `OS` | Dom0 root filesystem image |

### Commands

| Command | Description |
|---------|-------------|
| `raise-xen up [name]` | Build a domain image from entity definition |
| `raise-xen halt <name>` | Stop a running Xen domain (delegates to `xl`) |
| `raise-xen destroy <name>` | Remove a domain and its image |
| `raise-xen status [name]` | Query domain/image state |
| `raise-xen info` | Plugin metadata |

### Example Entity

```yaml
_type: amadla.org/entity/infrastructure/vm/template@v1.0.0
_body:
  name: desktop-base
  provider: xen
  base: alpine:3.20
  format: squashfs               # squashfs | ext4 | qcow2
  size_limit: 500MB
  boot_mode: pvh                 # pvh | hvm
  includes:
    - wayland-client
    - pipewire-client
    - dbus
    - mesa-dri-gallium
    - font-noto
    - xdg-utils
  hardening:
    seccomp: strict
    no_suid: true
    readonly_root: true
    capabilities: minimal
```

### Build Process

```
1. Pull base image (e.g., Alpine 3.20 rootfs)
2. Configure package manager (apk) for target
3. Install packages from entity 'includes' list
4. Apply hardening (seccomp profile, no-suid, readonly root)
5. Install Xen PV drivers (xenfs, xen-blkfront, xen-netfront)
6. Configure IPC bridge client (connection to dom0)
7. Create squashfs image (or ext4, per 'format' field)
8. Output image path and metadata as JSON to stdout
```

### Dependencies

| Dependency | Purpose |
|------------|---------|
| `mksquashfs` | Create squashfs images |
| `mkfs.ext4` | Create ext4 images (alternative format) |
| `apk` / `debootstrap` | Package installation into chroot |
| `xl` / `libxl` | Xen domain management (halt/destroy/status) |

### Architecture

```
raise-xen
├── main.go                     # Cobra CLI + entity parsing
├── xen/
│   ├── xen.go                  # Manager interface (Up/Halt/Destroy/Status)
│   ├── xen_test.go             # Unit tests
│   ├── builder.go              # Image build logic (chroot, packages, squashfs)
│   ├── builder_test.go         # Builder tests
│   ├── state.go                # StateManager (tracks built images)
│   └── state_test.go           # State persistence tests
└── test/
    └── fixtures/               # Test entity files
```

## Implementation Priority

Suggested order based on Amadla Linux distro needs:

1. **raise-xen** — Required for building the distro (domain templates, dom0 image)
2. **raise-oci** — Required for A/B update image distribution
3. **raise-aws** / **raise-hetzner** — Cloud provisioning (general Amadla use)
4. **raise-vmware** — Local VM alternative
5. **raise-opentofu** — Generic IaC bridge
