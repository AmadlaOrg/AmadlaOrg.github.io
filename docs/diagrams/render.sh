#!/usr/bin/env bash
#
# Renders every diagram in src/ to out/, twice: <name>.svg for light mode and
# <name>-dark.svg for dark mode. The docs reference the pair with Material's
# #only-light / #only-dark suffixes.
#
# The vendored C4-PlantUML needs a recent parser — the PlantUML packaged by
# most distros (1.2020.x) fails on it with IllegalArgumentException. Point
# PLANTUML_JAR at a 1.2024+ jar if the default location is not where yours is.
#
set -euo pipefail

cd "$(dirname "$0")"

PLANTUML_JAR="${PLANTUML_JAR:-$HOME/.local/plantuml/plantuml.jar}"

if [ ! -f "$PLANTUML_JAR" ]; then
    echo "error: PlantUML jar not found at $PLANTUML_JAR" >&2
    echo "       download it from https://plantuml.com/download and/or set PLANTUML_JAR" >&2
    exit 1
fi

plantuml() { java -jar "$PLANTUML_JAR" "$@"; }

echo "==> light"
plantuml -tsvg -o ../out src/*.puml

# PlantUML names output files after the @startuml name, not the input file, so
# the dark pass lands on the same names. Render it to a scratch directory and
# suffix the results.
echo "==> dark"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

(cd src && plantuml -tsvg -config ../dark.cfg -o "$tmp" ./*.puml)

for svg in "$tmp"/*.svg; do
    name="$(basename "$svg" .svg)"
    mv "$svg" "out/${name}-dark.svg"
done

echo "==> done: $(ls -1 out/*.svg | wc -l) files in out/"
