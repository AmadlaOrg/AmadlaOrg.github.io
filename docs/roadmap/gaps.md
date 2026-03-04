# Gaps

Known gaps in the Amadla ecosystem, identified through code exploration.

## Critical Gaps

### 1. No Working Pipeline

The core pipeline (hery → doorman → raise → lay → weaver → judge) cannot be run end-to-end. Only hery and weaver have partial implementations. This means:

- No infrastructure provisioning (raise)
- No application installation (lay)
- No compliance auditing (judge)
- No pipeline orchestration (waiter)
- No pipeline debugging (unravel)

### 2. doorman Has No Daemon Mode

doorman's core function — running as a secrets daemon — is not implemented. Only the `settings` command works. Missing:

- `start` command (daemon mode)
- `resolve` command (secret resolution)
- Clerk plugin loading and IPC
- Proper cache encryption (current XOR placeholder is insecure)

### 3. hery Has Significant Incomplete Code

34 files contain TODO markers. Key gaps:

- Cache rebuild edge cases
- Advanced query engine capabilities
- Entity composition limitations
- Documentation gaps within the project

## Library Gaps

### LibraryUtils

- Test coverage needs audit and improvement
- Code duplicated in downstream projects needs consolidation
- Some interfaces may need stabilization

### LibraryFramework

- CLI decorator pattern needs solidification
- Plugin loading integration incomplete

### LibraryPluginFramework

- Plugin discovery and lifecycle management needs testing
- IPC protocol documentation missing

### LibraryClerkFramework / LibraryAuditFramework

- Only one reference implementation each (clerk-keepassxc, auditor-application)
- Platform-specific IPC (Windows) untested

## Plugin Gaps

### Clerk Plugins

- 15 of 16 clerk plugins are stubs (README-only)
- Only clerk-keepassxc has Go code
- Most enterprise-critical clerks (vault, aws, keycloak) are not implemented

### Auditor Plugins

- 2 of 3 auditor plugins are stubs
- Only auditor-application has Go code

### Weaver Plugins

- All 4 weaver plugins are stubs
- No template engine integration exists yet

## Test Coverage Gaps

| Repo | Coverage Status |
|------|----------------|
| LibraryUtils | Needs comprehensive audit |
| LibraryFramework | Unknown |
| hery | Has tests (Ginkgo) but many TODOs |
| doorman | Minimal tests |
| weaver | Limited coverage |

## Documentation Gaps

- No central documentation site existed before this repo
- Most projects lack detailed CLAUDE.md (only 3 of 52 repos have one)
- No architecture diagrams
- No API documentation for libraries
- Entity schemas exist but are not documented for humans

## Integration Gaps

- No end-to-end integration tests across tools
- No example project showing the full pipeline
- No CI/CD for the ecosystem as a whole (only per-project GitHub Actions)
