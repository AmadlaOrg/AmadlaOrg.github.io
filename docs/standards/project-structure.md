# Project Structure

All Go projects in the Amadla ecosystem follow a standardized structure.

## Standard Layout

```
{project}/
├── CLAUDE.md               # Claude Code guidance (optional but recommended)
├── Makefile                 # Standardized build targets
├── go.mod                   # Go module with replace directives
├── go.sum
├── main.go                  # Entry point (CLI apps only)
├── .golangci.yml            # Linter configuration
├── .mockery.yaml            # Mock generation configuration
├── .covignore               # Coverage exclusion patterns
├── cmd/                     # Cobra CLI commands
├── internal/                # Internal packages (some projects)
├── bin/                     # Build output (gitignored)
└── .reports/                # Coverage reports (gitignored)
```

## Makefile

All projects share the same Makefile targets:

```makefile
make build              # Build for current platform (output: bin/{GOOS}/{GOARCH}/)
make build-linux        # Build for Linux amd64
make build-macos-arm64  # Build for macOS Apple Silicon
make build-all          # Build for all platforms
make test               # Run tests with coverage
make test-cov           # Run tests and open coverage in browser
make lint               # Run golangci-lint
make lint-fix           # Auto-fix linting issues
make generate           # Generate mocks with mockery
make install-deps       # Install dev tools
make clean              # Remove build artifacts
```

## go.mod Replace Directives

Projects reference sibling directories for local development:

```go
module github.com/AmadlaOrg/hery

require (
    github.com/AmadlaOrg/LibraryUtils v0.0.0
    github.com/AmadlaOrg/LibraryFramework v0.0.0
)

replace (
    github.com/AmadlaOrg/LibraryUtils => ../LibraryUtils
    github.com/AmadlaOrg/LibraryFramework => ../LibraryFramework
)
```

This means all sibling repos must be checked out at the same level for builds to work.

## Linter Configuration

`.golangci.yml` excludes mock files:

```yaml
issues:
  exclude-files:
    - "^.*mock_.*\\.go$"
```

## Mock Configuration

`.mockery.yaml` configures in-package mock generation:

```yaml
with-expecter: true
testonly: false
inpackage: true
```

## Coverage Configuration

`.covignore` excludes generated and test files:

```
.gen.
_test.
mock_
main.go
```

## Project Template

New Go projects can be bootstrapped from `template-application-golang`, which contains the standard Makefile, linter config, and directory structure.
