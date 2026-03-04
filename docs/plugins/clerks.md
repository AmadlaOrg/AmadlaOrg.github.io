# Clerk Plugins

Clerks are plugins for **doorman** that integrate with specific secret stores. Each clerk knows how to authenticate with and retrieve secrets from one backend.

## Clerk Inventory

### Active

| Plugin | Integrates With | Language | Notes |
|--------|----------------|----------|-------|
| `clerk-keepassxc` | KeePassXC password manager | Go | Uses D-Bus for communication |

### Stubs (Awaiting Implementation)

#### Cloud Providers

| Plugin | Integrates With |
|--------|----------------|
| `clerk-aws` | AWS Secrets Manager / SSM Parameter Store |
| `clerk-digitalocean` | DigitalOcean secrets |
| `clerk-linode` | Linode/Akamai secrets |
| `clerk-vultr` | Vultr secrets |
| `clerk-ovh` | OVH secrets |
| `clerk-rackspace` | Rackspace secrets |

#### Secret Managers

| Plugin | Integrates With |
|--------|----------------|
| `clerk-vault` | HashiCorp Vault / OpenBao |
| `clerk-sops` | Mozilla SOPS (encrypted files) |
| `clerk-bitwarden` | Bitwarden password manager |

#### Identity Providers

| Plugin | Integrates With |
|--------|----------------|
| `clerk-keycloak` | Keycloak identity server (OAuth2/OIDC tokens) |

#### Desktop Keystores

| Plugin | Integrates With |
|--------|----------------|
| `clerk-gnomekeyring` | GNOME Keyring (Linux desktop) |
| `clerk-chrome` | Chrome browser stored passwords |
| `clerk-chromium` | Chromium browser stored passwords |
| `clerk-firefox` | Firefox browser stored passwords |
| `clerk-thunderbird` | Thunderbird stored credentials |

## Framework

All clerk plugins use **LibraryClerkFramework**, which provides:

- Standard secret-fetching interface
- IPC communication with doorman (Unix sockets on Linux, named pipes on Windows)
- Integration with doorman's encrypted in-memory cache

## Implementation Priority

Suggested implementation order based on ecosystem needs:

1. **clerk-vault** — Most common enterprise secret store
2. **clerk-aws** — Cloud deployments
3. **clerk-keycloak** — Identity/OAuth2 token management
4. **clerk-sops** — Git-friendly encrypted secrets
5. Remaining cloud providers and desktop keystores
