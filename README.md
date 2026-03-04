# AmadlaOrg.github.io

Amadla documentation website built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/).

## Development

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
make start
```

Site available at http://127.0.0.1:8000

## Build

```bash
make build
```

## Deployment

Automatically deployed to GitHub Pages via GitHub Actions on push to `master`.
