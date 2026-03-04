# raise

| Field | Value |
|-------|-------|
| **Purpose** | Infrastructure provisioner — provisions servers and resources from entity requirements |
| **Module** | — |
| **Status** | Planned |
| **Repo** | [AmadlaOrg/raise](https://github.com/AmadlaOrg/raise) |

## Commands

| Command | Status | Description |
|---------|--------|-------------|
| `raise provision` | Planned | Provision infrastructure from entity requirements |
| `raise settings` | Planned | Manage raise configuration |

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

## Intended Design

raise will read `EntityInfrastructure` declarations and provision the required resources. It wraps infrastructure-as-code tools (OpenTofu/Terraform) with Amadla's application-centric model, translating entity requirements into provider-specific resource definitions.

## Current Gaps

- Repository exists as a stub only
- No Go code or module definition
