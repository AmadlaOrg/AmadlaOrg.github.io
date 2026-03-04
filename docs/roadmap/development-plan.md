# Development Plan

The Amadla ecosystem is developed bottom-up: stabilize foundations before building features on top.

## Phased Approach

### Phase 1: LibraryUtils — Foundation

LibraryUtils is the foundation for everything else. All tools and frameworks depend on it.

**Goals:**

1. Audit current test coverage across all packages
2. Identify code duplicated in downstream projects (hery, doorman, weaver) and consolidate
3. Stabilize interfaces — changes here ripple to every downstream project
4. Fill test coverage gaps
5. Document public interfaces

**Packages to audit:**

| Package | Priority | Notes |
|---------|----------|-------|
| `git/` | High | Core to hery's entity versioning |
| `database/sqlite3/` | High | Core to hery's caching layer |
| `file/` | High | Used everywhere |
| `interconnection/` | Medium | Core to doorman's plugin communication |
| `encryption/aes_gcm/` | Medium | Core to doorman's cache encryption |
| `configuration/` | Medium | Used by all tools for settings |
| `location/` | Low | XDG paths, relatively simple |
| `packaging/` | Low | Not yet used by active tools |

### Phase 2: Frameworks — CLI and Plugin Infrastructure

**Stage 2a: LibraryFramework + LibraryPluginFramework**

- Solidify CLI decorator pattern
- Stabilize plugin loading and IPC protocol
- Ensure consistent command structure across tools

**Stage 2b: LibraryClerkFramework + LibraryAuditFramework**

- These specialize the plugin framework for their domains
- Validate the patterns with existing reference implementations (clerk-keepassxc, auditor-application)

### Phase 3: hery — Core Data Layer

hery is the data source for the entire pipeline. Every other tool depends on it.

**Goals:**

1. Resolve the 34 TODO items across the codebase
2. Bring all commands to fully working state
3. Stabilize the query engine
4. Fix cache rebuild edge cases
5. Ensure entity composition works correctly
6. Improve documentation

**Estimated effort:** ~70 hours

### Phase 4: Tools and Plugins — Pipeline Completion

With stable foundations, build out the pipeline tools and plugins:

**Stage 4a: doorman**

- Implement daemon mode (`start` command)
- Implement `resolve` command
- Replace XOR cache encryption with AES-GCM + TPM
- Implement Clerk plugin loading

**Stage 4b: weaver**

- Complete `weave` command
- Implement template plugin loading
- Build first weaver plugin (weaver-jinja recommended)

**Stage 4c: Priority plugins**

- clerk-vault — Most common enterprise secret store
- clerk-aws — Cloud deployments
- auditor-system — System compliance

**Stage 4d: Remaining tools**

- raise — Infrastructure provisioning
- lay — Application installation
- judge — Audit orchestration
- waiter — Pipeline orchestration
- unravel — Debugging

## Approach Per Repo

For each repository, follow this sequence:

1. **Assess** — Review current state: test coverage, missing features, code duplication, TODOs
2. **Fix** — Address gaps: add tests, implement missing features, consolidate duplicated code
3. **Document** — Update CLAUDE.md, add interface documentation
4. **Move on** — Proceed to the next repo in dependency order

## Priority Matrix

| Priority | Repo | Reason |
|----------|------|--------|
| P0 | LibraryUtils | Everything depends on it |
| P0 | LibraryFramework | All CLI tools depend on it |
| P1 | hery | Core data layer for the pipeline |
| P1 | LibraryPluginFramework | Plugin system foundation |
| P2 | doorman | Secrets are needed early in the pipeline |
| P2 | LibraryClerkFramework | doorman needs clerk plugins |
| P2 | weaver | Config generation is a core use case |
| P3 | clerk-vault | Most requested secret backend |
| P3 | clerk-aws | Cloud deployment support |
| P3 | LibraryAuditFramework | Audit pipeline foundation |
| P4 | raise, lay, judge | Pipeline completion |
| P4 | waiter, unravel | Orchestration and debugging |
