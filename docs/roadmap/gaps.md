# Gaps

Known gaps in the Amadla ecosystem, identified through code exploration.

## Resolved (as of March 2026)

The following critical gaps have been addressed:

- **Pipeline orchestration** — amadla CLI complete (DAG from `_requires`, parallel execution, `init`/`run`/`list`/`doctor` commands, InfoCache with mtime-based invalidation, 62 tests)
- **Infrastructure provisioning** — raise core + 7 plugins (libvirt, wsl, virtualbox, aws, digitalocean, quickemu, opentofu)
- **System state configuration** — enjoin core + 10 plugins (user, service, cron, network, filesystem, firewall, certificate, ids, mac, sysctl)
- **Deployment strategies** — waiter core + 6 plugins (podman, docker, quadlet, proxy-haproxy, proxy-kamal, judge-waiter), 86+ tests
- **Multi-server orchestration** — conduct built
- **Notifications/alerting** — lighthouse core + 4 plugins (webhook, slack, email, sms), 65+ tests
- **System discovery** — unravel core complete, 11 tests
- **Secrets management** — doorman core + 3 plugins (vault, keepassxc, bitwarden), plugin discovery via PATH
- **Template rendering** — weaver core + 5 plugins (go, jinja2, mustache, qute, freemarker), 30 E2E tests
- **Validation/auditing** — judge core + 2 plugins (application, network)
- **Installation** — lay core, 42 packages passing
- **Trash/cleanup** — garbage core, 86 tests
- **All libraries** — LibraryUtils, LibraryFramework, LibraryPluginFramework, LibraryDoormanFramework, LibraryJudgeFramework, LibraryEnjoinFramework

## Remaining Gaps

### End-to-End Integration

- No end-to-end integration tests across the full pipeline (raise -> lay -> enjoin -> weaver -> waiter)
- No example project showing the complete pipeline in action
- No CI/CD for the ecosystem as a whole (only per-project GitHub Actions)

### hery Incomplete Areas

- 34 files with TODO comments
- Cache rebuild edge cases
- Advanced query engine capabilities
- Entity composition limitations

### Plugin Stubs

- 13 of 16 doorman plugins are stubs (only vault, keepassxc, bitwarden implemented)
- 1 of 3 judge plugins is a stub (judge-system)
- Several raise plugin stubs (beyond the 7 implemented)

### Documentation

- Entity schemas exist but human-readable documentation is incomplete for some types
- No API documentation for libraries
- Some tool pages still describe planned rather than implemented features

### Platform Coverage

- Platform-specific IPC (Windows) untested in libraries
- WSL plugin only tested on Linux with WSL2 available

### amadla CLI

- D2 diagram generation from DAG not yet implemented
- `settings` command not yet implemented
- No `amadla` integration tests that exercise real tool binaries end-to-end
