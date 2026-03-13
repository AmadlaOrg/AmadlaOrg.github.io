# LibraryJudgeFramework

| Field | Value |
|-------|-------|
| **Purpose** | Judge plugin framework — specialization for audit/compliance plugins used by judge |
| **Module** | `github.com/AmadlaOrg/LibraryJudgeFramework` |
| **Status** | Active |
| **Repo** | [AmadlaOrg/LibraryJudgeFramework](https://github.com/AmadlaOrg/LibraryJudgeFramework) |

## What It Provides

LibraryJudgeFramework extends LibraryPluginFramework for audit plugins:

- Standard interface for running audit checks
- Compliance reporting format (pass/fail per check)
- Entity-to-audit-rule mapping
- Table-formatted output for CLI display

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | Foundation utilities |
| LibraryFramework | CLI framework |

## Consumers

- judge-application
- judge-system (planned)
- judge-infrastructure (planned)

## Development Notes

- **Phase 2** in the development plan (specialization of plugin framework)
- Only one judge plugin (judge-application) currently implements this framework
