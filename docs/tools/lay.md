# lay

| Field | Value |
|-------|-------|
| **Purpose** | Package and application installer — installs software based on entity requirements |
| **Module** | — |
| **Status** | Planned |
| **Repo** | [AmadlaOrg/lay](https://github.com/AmadlaOrg/lay) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `lay install` | Planned | Install applications from entity requirements |
| `lay settings` | Planned | Manage lay configuration |

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | File operations, configuration |
| LibraryFramework | CLI framework |

## Pipeline Position

lay sits **after raise** (infrastructure provisioning) and **before weaver** (configuration generation). It installs the applications that the provisioned servers need.

```
hery → doorman → raise → [lay] → weaver → judge
```

## Intended Design

lay will read `EntityApplication` and `EntitySystem` declarations and install the required software using the appropriate package manager for the target system (apt, yum, brew, etc.). It may wrap or integrate with existing configuration management tools like Ansible.

## Current Gaps

- Repository exists as a stub only
- No Go code or module definition
