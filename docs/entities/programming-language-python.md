# ProgrammingLanguage/Python

| Field | Value |
|-------|-------|
| **Purpose** | Python-specific configuration — pip, virtualenv, Poetry, and pyproject settings |
| **Repo** | [AmadlaOrg/Entities/ProgrammingLanguage/Python](https://github.com/AmadlaOrg/Entities) |
| **Entity URI** | `amadla.org/entity/programming-language/python@v1.0.0` |
| **Parent type** | [ProgrammingLanguage](programming-language.md) |

## Schema

| Property | Type | Description |
|----------|------|-------------|
| `pip_packages` | array of strings | Global pip packages to install |
| `virtualenv.path` | string | Path for the virtual environment |
| `virtualenv.python` | string | Python binary path to use for the virtualenv |
| `poetry_enabled` | boolean | Install Poetry package manager |
| `pipx_packages` | array of strings | CLI tools to install via pipx |
| `pyproject.build_system` | string | Build system to use (`setuptools`, `poetry`, `flit`, `hatch`) |
| `site_packages` | boolean | Allow system site-packages in virtual environments |

## Example

```yaml
_type: amadla.org/entity/programming-language/python@v1.0.0
_extends: amadla.org/entity/programming-language@v1.0.0
_body:
  language: python
  version: "3.12"
  version_manager: pyenv
  pip_packages:
    - requests
    - black
    - ruff
  virtualenv:
    path: /opt/myapp/venv
    python: /usr/bin/python3.12
  poetry_enabled: true
  pipx_packages:
    - cookiecutter
    - httpie
  pyproject:
    build_system: poetry
  site_packages: false
```

## Consumers

| Tool | How It Uses ProgrammingLanguage/Python |
|------|----------------------------------------|
| [lay](../tools/lay.md) | Installs Python runtime, pip packages, virtualenv, Poetry, pipx tools |
