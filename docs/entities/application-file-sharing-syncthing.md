# Application/FileSharing/Syncthing

| Field | Value |
|-------|-------|
| **Purpose** | Syncthing-specific configuration — decentralized peer-to-peer file synchronization with no central server |
| **Repo** | [AmadlaOrg/Entities/Application/FileSharing/Syncthing](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/application/file-sharing/syncthing@v1.0.0` |
| **Parent type** | [Application/FileSharing](application-file-sharing.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `device_name` | string | Name of this Syncthing device |
| `gui_address` | string | Web GUI listen address (e.g., `127.0.0.1:8384`) |
| `gui_user` | string | Web GUI username |
| `gui_password_secret` | string | Doorman secret reference for the web GUI password |
| `folders` | array of objects | Shared folder configurations (id, path, type, devices) |
| `folders[].id` | string | Unique folder identifier |
| `folders[].path` | string | Local filesystem path for the folder |
| `folders[].type` | string | Sync type (`sendreceive`, `sendonly`, or `receiveonly`) |
| `folders[].devices` | array of strings | Device IDs to share this folder with |
| `default_folder_path` | string | Default path for new shared folders |
| `global_announce_enabled` | boolean | Whether global discovery announcement is enabled |
| `local_announce_enabled` | boolean | Whether local discovery announcement is enabled |
| `nat_enabled` | boolean | Whether NAT traversal is enabled |

## Example

```yaml
_type: amadla.org/entity/application/file-sharing/syncthing@v1.0.0
_extends: amadla.org/entity/application/file-sharing@v1.0.0
_body:
  data_dir: /srv/syncthing
  device_name: server-01
  gui_address: 127.0.0.1:8384
  gui_user: admin
  gui_password_secret: doorman://vault/syncthing/gui-password
  folders:
    - id: documents
      path: /srv/syncthing/documents
      type: sendreceive
      devices:
        - DEVICE-ID-1
        - DEVICE-ID-2
    - id: backups
      path: /srv/syncthing/backups
      type: receiveonly
      devices:
        - DEVICE-ID-1
  default_folder_path: /srv/syncthing
  global_announce_enabled: true
  local_announce_enabled: true
  nat_enabled: true
```

## Consumers

| Tool | How It Uses Application/FileSharing/Syncthing |
|------|------------------------------------------------|
| lay | Installs the `syncthing` package |
| weaver | Generates `config.xml` |
| enjoin-service | Enables/starts `syncthing@<user>` service |
