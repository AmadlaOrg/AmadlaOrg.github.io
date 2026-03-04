# LibraryAuditFramework

| Field | Value |
|-------|-------|
| **Purpose** | Auditor plugin framework — specialization for audit/compliance plugins used by judge |
| **Module** | `github.com/AmadlaOrg/LibraryAuditFramework` |
| **Status** | Active |
| **Repo** | [AmadlaOrg/LibraryAuditFramework](https://github.com/AmadlaOrg/LibraryAuditFramework) |
| **Go Version** | 1.24.0 |

## What It Provides

LibraryAuditFramework extends LibraryPluginFramework for audit plugins:

- Standard interface for running audit checks
- Compliance reporting format (pass/fail per check)
- Entity-to-audit-rule mapping
- Table-formatted output for CLI display

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | Foundation utilities |
| LibraryFramework | CLI framework |

### External Dependencies

| Package | Purpose |
|---------|---------|
| `github.com/spf13/cobra` | CLI framework |
| `gopkg.in/yaml.v3` | YAML parsing |
| `github.com/olekukonko/tablewriter` | Formatted table output |

## Consumers

- auditor-application
- auditor-system (planned)
- auditor-infrastructure (planned)

## Development Notes

- **Phase 2** in the development plan (specialization of plugin framework)
- Only one auditor plugin (auditor-application) currently implements this framework
