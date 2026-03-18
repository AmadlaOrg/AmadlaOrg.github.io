# ProgrammingLanguage/Go

| Field | Value |
|-------|-------|
| **Purpose** | Go-specific configuration — GOPATH, module proxy, private modules, and CGO settings |
| **Repo** | [AmadlaOrg/Entities/ProgrammingLanguage/Go](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/programming-language/go@v1.0.0` |
| **Parent type** | [ProgrammingLanguage](programming-language.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `gopath` | string | GOPATH directory |
| `gobin` | string | GOBIN directory for installed binaries |
| `goproxy` | string | Module proxy URL (e.g., `https://proxy.golang.org,direct`) |
| `gonosumcheck` | string | Patterns to skip checksum verification |
| `goprivate` | string | Private module patterns (e.g., `github.com/myorg/*`) |
| `go_install` | array of strings | Tools to install via `go install` |
| `cgo_enabled` | boolean | Enable CGO for C interop |

## Example

```yaml
_type: amadla.org/entity/programming-language/go@v1.0.0
_extends: amadla.org/entity/programming-language@v1.0.0
_body:
  language: go
  version: "1.22"
  gopath: /home/deploy/go
  gobin: /home/deploy/go/bin
  goproxy: https://proxy.golang.org,direct
  goprivate: github.com/myorg/*
  go_install:
    - golang.org/x/tools/gopls@latest
    - github.com/golangci/golangci-lint/cmd/golangci-lint@latest
  cgo_enabled: false
```

## Consumers

| Tool | How It Uses ProgrammingLanguage/Go |
|------|-------------------------------------|
| lay | Installs Go runtime, sets environment variables, installs tools via `go install` |
