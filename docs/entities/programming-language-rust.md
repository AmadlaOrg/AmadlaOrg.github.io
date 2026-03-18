# ProgrammingLanguage/Rust

| Field | Value |
|-------|-------|
| **Purpose** | Rust-specific configuration — rustup toolchain, targets, components, and cargo settings |
| **Repo** | [AmadlaOrg/Entities/ProgrammingLanguage/Rust](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/programming-language/rust@v1.0.0` |
| **Parent type** | [ProgrammingLanguage](programming-language.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `toolchain` | string | Rustup toolchain (`stable`, `beta`, `nightly`, or specific version) |
| `targets` | array of strings | Compilation targets (e.g., `x86_64-unknown-linux-musl`) |
| `components` | array of strings | Rustup components to install (e.g., `clippy`, `rustfmt`, `rust-analyzer`) |
| `cargo_install` | array of strings | Crates to install via `cargo install` |
| `registry.name` | string | Custom registry name |
| `registry.index` | string | Custom registry index URL |
| `profile` | string | Default build profile (`dev`, `release`, `bench`, `test`) |

## Example

```yaml
_type: amadla.org/entity/programming-language/rust@v1.0.0
_extends: amadla.org/entity/programming-language@v1.0.0
_body:
  language: rust
  version: "1.77"
  toolchain: stable
  targets:
    - x86_64-unknown-linux-musl
    - aarch64-unknown-linux-gnu
  components:
    - clippy
    - rustfmt
    - rust-analyzer
  cargo_install:
    - cargo-watch
    - cargo-edit
    - sccache
  registry:
    name: my-registry
    index: https://registry.example.com/index
  profile: release
```

## Consumers

| Tool | How It Uses ProgrammingLanguage/Rust |
|------|--------------------------------------|
| lay | Installs Rust via rustup, adds targets, components, and cargo crates |
