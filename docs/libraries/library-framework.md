# LibraryFramework

| Field | Value |
|-------|-------|
| **Purpose** | CLI framework wrapper around Cobra with decorator pattern for consistent command structure |
| **Status** | Active |
| **Repo** | [AmadlaOrg/LibraryFramework](https://github.com/AmadlaOrg/LibraryFramework) |

## What It Provides

LibraryFramework wraps [Cobra](https://github.com/spf13/cobra) to give all Amadla CLI tools a consistent structure:

- Standard `cli.New()` entry point
- Common flag patterns (`--collection`, `--output`)
- Settings command scaffolding
- Consistent error handling and output formatting

## Dependencies

| Library | Purpose |
|---------|---------|
| LibraryUtils | Foundation utilities |

### External Dependencies

| Package | Purpose |
|---------|---------|
| `github.com/spf13/cobra` | CLI framework |
| `github.com/onsi/ginkgo/v2` | BDD test framework |
| `github.com/onsi/gomega` | BDD assertions |

## Consumers

- hery
- doorman
- LibraryJudgeFramework (and by extension, judge plugins)

## Development Notes

- **Phase 2** in the development plan
- Needs solidification of CLI decorator pattern and plugin loading
- Testing uses Ginkgo/Gomega (BDD-style)
