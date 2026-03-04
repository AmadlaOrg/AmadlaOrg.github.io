# Vision & Philosophy

## Application-Centric vs Environment-Centric

Traditional infrastructure tools (Terraform, Ansible, Puppet) are **environment-centric**: you describe the target environment — which servers to provision, what packages to install, what configuration files to write. The application's needs are implicit, embedded in playbooks and modules.

Amadla inverts this. It is **application-centric**: you describe what an application *requires* — its dependencies, secrets, configuration templates, system prerequisites — and those requirements flow outward to inform whatever provisioning, configuration, and auditing tools you use.

### Example

**Environment-centric (Ansible):**
```yaml
- hosts: webservers
  tasks:
    - apt: name=nginx state=present
    - template: src=nginx.conf.j2 dest=/etc/nginx/nginx.conf
    - service: name=nginx state=started
```

You must know that this app needs nginx, where the config goes, and how to start it. This knowledge is baked into the playbook.

**Application-centric (Amadla):**
```yaml
_entity: github.com/AmadlaOrg/EntityApplication@v1.0.0
_body:
  name: my-web-app
  requires:
    - _entity: github.com/AmadlaOrg/EntitySystem@v1.0.0
      _body:
        package: nginx
    - _entity: github.com/AmadlaOrg/EntitySecret@v1.0.0
      _body:
        key: tls-certificate
        source: vault
```

The application declares its own requirements. Tools downstream (raise, lay, weaver, judge) read these declarations and act accordingly.

## UNIX Philosophy

Amadla follows the UNIX philosophy:

1. **Each tool does one thing well.** `hery` manages data, `doorman` manages secrets, `weaver` generates templates — they don't overlap.

2. **Tools communicate via JSON pipes.** The output of one tool feeds into the next. No shared databases, no message queues, no RPC — just standard I/O.

3. **Small, composable programs.** You can use any tool independently, or chain them together in a pipeline.

4. **Text (structured data) as the universal interface.** YAML in, JSON out. Every tool speaks the same data format.

## The Pipeline Model

The Amadla pipeline flows from requirements to running infrastructure:

<!-- Diagram placeholder -->

| Stage | Tool | Input | Output |
|-------|------|-------|--------|
| **Define** | hery | YAML entity files | Structured entity data (JSON) |
| **Resolve secrets** | doorman | Entity data with secret references | Entity data with resolved secrets |
| **Provision** | raise | Infrastructure requirements | Provisioned servers/resources |
| **Install** | lay | Application requirements | Installed packages/services |
| **Configure** | weaver | Templates + entity data | Generated configuration files |
| **Audit** | judge | Expected state from entities | Compliance report |

### Supporting Tools

| Tool | Role |
|------|------|
| **waiter** | Orchestrates pipeline execution and sequencing |
| **unravel** | Debugging and inspection of pipeline state |

## Extensibility Through Plugins

Each tool that interfaces with external systems uses a **plugin architecture**:

- **Clerks** extend doorman with new secret sources (Vault, AWS, KeePassXC, Keycloak, ...)
- **Auditors** extend judge with new audit targets (applications, systems, infrastructure)
- **Weavers** extend weaver with new template engines (Jinja, Mustache, Handlebars, Qute)

Plugins are separate executables that communicate with their host tool via IPC. This keeps the core tools lightweight and allows plugins to be developed, versioned, and distributed independently.
