# Stack Comparison

How does Amadla's encouraged stack compare to the mainstream approaches for running production workloads with high availability?

!!! note "This stack is a proposition, not a requirement"
    Amadla is a series of independent, composable tools — not a monolithic platform. You are free to use any stack you want. The tools work with Kubernetes, HashiCorp Nomad, Ansible, or any other infrastructure you already have. The stack presented here is simply the one we recommend for simplicity and efficiency.

## The Stacks

| Stack | Components |
|-------|------------|
| **Amadla** | Podman (rootless, Quadlet) + HAProxy + PostgreSQL (Patroni + etcd/Raft) + OpenBao + systemd + [conduct](../tools/conduct.md) |
| **Kubernetes** | K8s + Ingress Controller + etcd + Vault/Secrets Manager + Container Runtime |
| **K3s** | K3s + Traefik + SQLite/etcd + Vault/Secrets Manager |
| **HashiCorp** | Nomad + Consul + Vault + Docker/Podman |
| **Ansible** | Ansible + Docker/Podman + HAProxy/Nginx + manual orchestration |

## Comparison Matrix

| Concern | Amadla | Kubernetes | K3s | HashiCorp | Ansible |
|---------|--------|------------|-----|-----------|---------|
| **Container runtime** | Podman (rootless) | containerd/CRI-O | containerd | Docker/Podman | Docker/Podman |
| **Rootless by default** | Yes | No | No | No | No |
| **Service management** | systemd (Quadlet) | kubelet | kubelet | Nomad client | systemd (manual) |
| **Load balancing** | HAProxy | kube-proxy + Ingress | Traefik + kube-proxy | Consul + Fabio/Traefik | HAProxy/Nginx (manual) |
| **Service discovery** | HAProxy + DNS | CoreDNS + kube-proxy | CoreDNS | Consul | Manual/DNS |
| **Secrets** | OpenBao ([doorman](../tools/doorman.md)) | Secrets resource + CSI | Secrets resource | Vault | Ansible Vault / files |
| **HA database** | Patroni + etcd/Raft | etcd (control plane) | Embedded etcd/SQLite | Consul (Raft) | Manual replication |
| **Multi-server orchestration** | [conduct](../tools/conduct.md) | Control plane | Control plane | Nomad server | Playbooks |
| **Deployment strategies** | [waiter](../tools/waiter.md) (blue-green, canary, rolling) | Deployment controller | Deployment controller | Nomad job update | Rolling (manual) |
| **Drift detection** | [unravel](../tools/unravel.md) + [judge](../tools/judge.md) | Controller reconciliation | Controller reconciliation | Consul checks | Ansible --check |
| **Config generation** | [weaver](../tools/weaver.md) (templates) | Helm/Kustomize | Helm/Kustomize | HCL templates | Jinja2 templates |
| **Min nodes for HA** | 2-3 | 3+ (control plane) | 2-3 | 3+ (Consul quorum) | 2+ (manual) |
| **Daemon tax** | 0 (systemd manages) | kubelet, kube-proxy, CoreDNS, etcd, API server, controller, scheduler | k3s agent | Nomad, Consul, Vault agents | 0 (push-based) |
| **RAM overhead (idle)** | ~50 MB (HAProxy + Podman) | ~500-800 MB | ~200-400 MB | ~300-500 MB | 0 (runs on demand) |
| **Learning curve** | Moderate (UNIX skills transfer) | Steep | Moderate | Moderate-Steep | Low-Moderate |
| **YAML complexity** | 4 reserved properties | 50+ resource types, deep nesting | Same as K8s | HCL (different language) | Playbook YAML |
| **Smallest useful deployment** | 1 server, 1 container | 1 node (kind/minikube) | 1 node | 1 node | 1 server |
| **Scales to** | Hundreds of nodes ([conduct](../tools/conduct.md)) | Thousands of nodes | Hundreds of nodes | Thousands of nodes | Hundreds (with effort) |

## What You Don't Need

With Amadla's stack, several layers that Kubernetes/Nomad require become unnecessary:

| K8s/Nomad Concept | Amadla Equivalent | Why It's Simpler |
|-------------------|-------------------|------------------|
| Control plane (API server, scheduler, controller) | systemd + [conduct](../tools/conduct.md) | systemd already manages processes. [conduct](../tools/conduct.md) coordinates across servers. No always-on control plane |
| etcd cluster (for K8s state) | etcd only for Patroni (database HA) | etcd serves one purpose, not the entire platform |
| Container runtime interface (CRI) | Podman directly | No shim layer[^shim] between orchestrator and containers |
| kubelet | Quadlet + systemd | systemd is the init system — it already knows how to manage services |
| kube-proxy / iptables rules | HAProxy | In Kubernetes, kube-proxy silently rewrites iptables rules to route traffic between services — these auto-generated rules are hard to inspect and debug. HAProxy uses a single, readable config file for the same job. Note: this is about *service routing*, not firewalls. A host firewall (nftables, firewalld, etc.) is still recommended regardless of stack |
| Ingress controller | HAProxy | One tool for both internal and external traffic |
| Helm/Kustomize | [weaver](../tools/weaver.md) | Same concept (templates + values), simpler model |
| kubectl | [amadla](../tools/amadla.md) + individual tools | Each tool does one thing; [amadla](../tools/amadla.md) orchestrates |
| Operators / CRDs | [Entity types](../entities/overview.md) + tool [plugins](../plugins/overview.md) | Schema-validated entities instead of custom controllers |
| Pod / ReplicaSet / Deployment | Quadlet unit + [waiter](../tools/waiter.md) | Fewer abstraction layers between you and the container |
| Namespace isolation | Podman rootless + systemd user units | OS-level isolation instead of API-level isolation |
| Secrets CSI driver | [doorman](../tools/doorman.md) + [doorman plugins](../plugins/clerks.md) | Direct secret injection, no mounted volumes |

## raise vs Vagrant

[raise](../tools/raise.md) fills the same role as Vagrant — managing VM lifecycles — but extends to cloud provisioning under the same interface.

| Concern | raise | Vagrant |
|---------|-------|---------|
| **Local VMs** | Plugin-based (libvirt, VirtualBox, VMware) | Provider-based (VirtualBox, libvirt, VMware) |
| **Cloud instances** | Plugin-based (AWS, Hetzner, DigitalOcean) | Limited (community plugins, not core focus) |
| **VM definition** | HERY entity (`EntityInfrastructure`) | Vagrantfile (Ruby DSL) |
| **Provisioning** | Pipeline: raise → [lay](../tools/lay.md) → [weaver](../tools/weaver.md) | Built-in: shell, Ansible, Puppet, Chef |
| **Multi-machine** | [conduct](../tools/conduct.md) orchestrates across machines | Multi-machine Vagrantfile |
| **Secret injection** | [doorman](../tools/doorman.md) (separate tool, UNIX philosophy) | Vault (HashiCorp integration) |
| **Config generation** | [weaver](../tools/weaver.md) (separate tool) | Embedded in Vagrantfile |
| **Language** | Go (entity-driven, no code in config) | Ruby DSL (code in config) |
| **License** | Open source | BSL (Business Source License) since 2023 — not open source |
| **Integration** | Part of Amadla pipeline (hery → raise → lay → weaver) | Standalone or with Terraform/Packer |

The key difference: Vagrant is a standalone VM manager with provisioning bolted on. raise is one tool in a composable pipeline — it creates the machine, then hands off to [lay](../tools/lay.md) (install), [weaver](../tools/weaver.md) (configure), and [waiter](../tools/waiter.md) (deploy). The same entity that defines a VM also drives every other tool in the chain.

## Where Amadla Shines

### Simplicity Without Sacrificing HA

A highly available web application with database:

**Amadla (2 servers):**

```
Server A                          Server B
├── HAProxy (active)              ├── HAProxy (standby)
├── app container (Quadlet)       ├── app container (Quadlet)
├── PostgreSQL (Patroni primary)  ├── PostgreSQL (Patroni replica)
└── systemd manages all           └── systemd manages all
```

- [conduct](../tools/conduct.md) coordinates across both servers
- [waiter](../tools/waiter.md) handles blue-green deploys
- systemd restarts any failed container
- Patroni handles database failover via Raft

**Kubernetes (3+ servers):**

```
Server A (control plane)     Server B (control plane)     Server C (control plane)
├── etcd                     ├── etcd                     ├── etcd
├── kube-apiserver           ├── kube-apiserver           ├── kube-apiserver
├── kube-scheduler           ├── kube-scheduler           ├── kube-scheduler
├── kube-controller          ├── kube-controller          ├── kube-controller
├── kubelet                  ├── kubelet                  ├── kubelet
├── kube-proxy               ├── kube-proxy               ├── kube-proxy
├── CoreDNS                  ├── app pod                  ├── app pod
├── Ingress controller       ├── PostgreSQL pod           ├── PostgreSQL pod
└── app pod                  └── ...                      └── ...

Plus: PV provisioner, CSI driver, cert-manager, metrics-server...
```

### Security by Default

- **Podman rootless**: containers never run as root. No privilege escalation path
- **No daemon**: Podman has no long-running daemon (unlike Docker). Smaller attack surface
- **systemd integration**: standard Linux security (cgroups, namespaces, SELinux/AppArmor) without custom abstractions
- **OpenBao**: open-source secrets management (fork of Vault) without licensing concerns

### Operational Transparency

- **No black boxes**: every component is a standard Linux tool with man pages
- **HAProxy stats**: real-time traffic visibility without Prometheus/Grafana stack
- **systemd journal**: standard logging, no Fluentd/Loki pipeline needed for basic use
- **[judge](../tools/judge.md) + [unravel](../tools/unravel.md)**: drift detection using osquery — query your infrastructure with SQL

### Cost Efficiency

| Metric | Amadla (2 servers) | K8s (3 servers) | Difference |
|--------|-------------------|-----------------|------------|
| Min servers for HA | 2 | 3 | 33% fewer servers |
| Idle RAM overhead | ~50 MB | ~800 MB | 16x less overhead |
| Processes running | ~5 | ~15+ | 3x fewer processes |
| Certificates to manage | HAProxy TLS | etcd, API server, kubelet, webhook, SA | 5x fewer certs |
| Config files | Quadlet units + HAProxy | Dozens of YAML manifests | Significantly fewer |

## Where Kubernetes Wins

Amadla is not trying to replace Kubernetes for every use case:

| Scenario | Better Choice | Why |
|----------|---------------|-----|
| 50+ microservices | Kubernetes | Built-in service mesh, network policies, resource quotas at scale |
| Multi-team platform | Kubernetes | RBAC, namespaces, admission controllers for team isolation |
| Cloud-managed offering | K8s (EKS/GKE/AKS) | Zero control plane management |
| GPU workloads / ML | Kubernetes | Device plugins, operator ecosystem |
| Windows containers | Kubernetes | Better Windows node support |
| Large existing K8s investment | Kubernetes | Migration cost outweighs benefits |

## Where Amadla Wins

| Scenario | Why Amadla |
|----------|------------|
| 1-20 servers | No control plane overhead, systemd handles process management |
| Small team (1-5 devs) | [UNIX tools](../tools/overview.md) they already know, no K8s expertise needed |
| Edge / IoT / VPS | Minimal resource footprint, works on cheap VPS instances |
| Compliance / audit | Every component is a standard, auditable Linux tool |
| Self-hosted SaaS | Simple HA without cloud vendor lock-in |
| Budget-constrained | Fewer servers, less RAM, lower cloud bills |
| Security-first | Rootless containers by default, no privileged daemon |

## Amadla Works With Other Tools

Amadla is not an all-or-nothing choice. The [entity model](../entities/overview.md) is the universal interface:

- **[weaver](../tools/weaver.md)** can generate Kubernetes manifests, Terraform configs, Ansible playbooks, or Quadlet files from the same entities
- **[raise](../tools/raise.md)** can provision infrastructure via OpenTofu, Terraform, or cloud APIs
- **[doorman](../tools/doorman.md)** can pull secrets from HashiCorp Vault, AWS Secrets Manager, or OpenBao

The same [HERY](hery-concepts.md) entities that describe your application work regardless of whether you deploy to Podman, Kubernetes, or bare metal. The tools are composable — use what fits your environment.

## Verdict

| Criteria | Winner |
|----------|--------|
| **Simplicity** | Amadla |
| **Security defaults** | Amadla |
| **Resource efficiency** | Amadla |
| **Small-scale HA (1-20 servers)** | Amadla |
| **Operational transparency** | Amadla |
| **Cost** | Amadla |
| **Large-scale (50+ services)** | Kubernetes |
| **Multi-team platform** | Kubernetes |
| **Managed cloud offering** | Kubernetes (EKS/GKE/AKS) |
| **Ecosystem / marketplace** | Kubernetes |

**For most self-hosted applications on 1-20 servers, Amadla's stack provides production-grade high availability with a fraction of the complexity, cost, and resource overhead of Kubernetes.** You don't need a container orchestrator to run containers well — you need systemd, a load balancer, and tools that compose.

[^shim]: A **shim layer** is an intermediate adapter that translates between two systems that don't speak the same interface. In Kubernetes, the Container Runtime Interface (CRI) is a shim — kubelet doesn't talk to containerd or CRI-O directly; it goes through this translation layer. With Podman, there is no orchestrator sitting above it, so no adapter is needed. You run containers directly.
