.PHONY: start build diagrams help

start: ## Start mkdocs dev server
	python -m mkdocs serve

build: ## Build mkdocs site
	python -m mkdocs build --strict

diagrams: ## Re-render the PlantUML diagrams (light + dark)
	./docs/diagrams/render.sh

help: ## Show help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
