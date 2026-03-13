# Doorman Plugins

Doorman plugins integrate with specific secret stores. Each plugin knows how to authenticate with and retrieve secrets from one backend, outputting secrets in a universal entity format.

## Plugin Inventory

### Active

| Plugin | Integrates With | Language | Notes |
|--------|----------------|----------|-------|
| `doorman-keepassxc` | KeePassXC password manager | Go | Currently named `doorman-keepassxc` (will be renamed) |

### Stubs (Awaiting Implementation)

#### Cloud Providers

| Plugin | Integrates With |
|--------|----------------|
| `doorman-aws` | AWS Secrets Manager / SSM Parameter Store |
| `doorman-digitalocean` | DigitalOcean secrets |
| `doorman-linode` | Linode/Akamai secrets |
| `doorman-vultr` | Vultr secrets |
| `doorman-ovh` | OVH secrets |
| `doorman-rackspace` | Rackspace secrets |

#### Secret Managers

| Plugin | Integrates With |
|--------|----------------|
| `doorman-vault` | HashiCorp Vault / OpenBao |
| `doorman-sops` | Mozilla SOPS (encrypted files) |
| `doorman-bitwarden` | Bitwarden password manager |

#### Identity Providers

| Plugin | Integrates With |
|--------|----------------|
| `doorman-keycloak` | Keycloak identity server (OAuth2/OIDC tokens) |

#### Desktop Keystores

| Plugin | Integrates With |
|--------|----------------|
| `doorman-gnomekeyring` | GNOME Keyring (Linux desktop) |
| `doorman-chrome` | Chrome browser stored passwords |
| `doorman-chromium` | Chromium browser stored passwords |
| `doorman-firefox` | Firefox browser stored passwords |
| `doorman-thunderbird` | Thunderbird stored credentials |

## Protocol

Doorman plugins follow the standard [Plugin Protocol](../architecture/plugin-system.md):

```bash
# Plugin metadata
doorman-vault info
# {"name": "doorman-vault", "version": "1.0.0", "supports": ["amadla.org/entity/secret@^v1.0.0"], ...}

# Retrieve a secret (entity in via stdin, secret entity out via stdout)
echo '{"_type": "amadla.org/entity/secret@v1.0.0", "_body": {"key": "db_password", "path": "secret/data/myapp"}}' \
  | doorman-vault get
```

Output is always a universal secret entity format, regardless of the backend.

## Go Framework (Optional)

**LibraryDoormanFramework** provides convenience wrappers for Go plugin authors:

- Standard secret-fetching interface
- Secret entity output formatting
- Common authentication patterns

Plugins can also be written in any other language — just implement the protocol.

## Implementation Priority

Suggested implementation order based on ecosystem needs:

1. **doorman-vault** — Most common enterprise secret store
2. **doorman-aws** — Cloud deployments
3. **doorman-keycloak** — Identity/OAuth2 token management
4. **doorman-sops** — Git-friendly encrypted secrets
5. Remaining cloud providers and desktop keystores
