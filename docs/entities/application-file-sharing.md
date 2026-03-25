# Application/FileSharing

| Field | Value |
|-------|-------|
| **Purpose** | Common properties shared by all file sharing applications |
| **Repo** | [AmadlaOrg/Entities/Application/FileSharing](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/file-sharing@v1.0.0` |
| **Parent type** | [Application](application.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `listen_address` | string | Address the service listens on (e.g., `0.0.0.0`, `127.0.0.1`) |
| `listen_port` | integer | Port the service listens on |
| `data_dir` | string | Directory for file storage |
| `max_upload_size` | string | Maximum upload file size (e.g., `10G`, `512M`) |
| `tls.enabled` | boolean | Whether TLS is enabled |
| `tls.cert` | string | Path to TLS certificate file |
| `tls.key` | string | Path to TLS private key file |

These properties are common across all file sharing implementations. Sub-types add application-specific settings.

## Sub-types

| Sub-type | Application |
|----------|-------------|
| [FileSharing/Nextcloud](application-file-sharing-nextcloud.md) | Nextcloud — self-hosted productivity platform with file sync |
| [FileSharing/Seafile](application-file-sharing-seafile.md) | Seafile — high-performance file sync with delta transfer |
| [FileSharing/Syncthing](application-file-sharing-syncthing.md) | Syncthing — decentralized peer-to-peer file sync |

## Example

```yaml
_type: amadla.org/entity/application/file-sharing@v1.0.0
_body:
  listen_address: 0.0.0.0
  listen_port: 443
  data_dir: /srv/data
  max_upload_size: 10G
  tls:
    enabled: true
    cert: /etc/ssl/certs/fileshare.pem
    key: /etc/ssl/private/fileshare.key
```

## Consumers

| Tool | How It Uses Application/FileSharing |
|------|-------------------------------------|
| [lay](../tools/lay.md) | Installs the file sharing application |
| [weaver](../tools/weaver.md) | Generates configuration files |
| enjoin-service | Enables/starts the file sharing service |
