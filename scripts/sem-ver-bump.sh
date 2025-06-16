#!/usr/bin/env sh

# NEW VERSION for Release
VERSION="${1}"
# EXAMPLE: 1.4.5

# Sem Ver Major Minor Patch + Pre-release metadata
regex="[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*)?"

set -e

## 1. Update PYPROJECT - Sem Ver
# Until uv migration is verified we must update all regex matches (ie for poetry and uv config sections!)
PYPROJECT='pyproject.toml'
sed -i.bak -E "s/(version = ['\"])[0-9]+\.[0-9]+\.[0-9]+(['\"])/\\1${VERSION}\\2/" "${PYPROJECT}" && rm "${PYPROJECT}.bak"

## 2. Update README.md - Sem Ver
README_MD='README.md'
# sed -i -E "s/(['\"]?v?)[0-9]+\.[0-9]+\.[0-9]+(['\"]?)/\1${VERSION}\2/" "${README_MD}"

# Replace occurrences such as /v2.5.8/ with /v2.5.9/, excluding lines with `image_tag:`
sed -i -E "/image_tag:/!s/(['\"]?v?)${regex}(['\"]?)/\1${VERSION}\2/" "${README_MD}"

# Replace occurrences such as /v2.5.8..main with /v2.5.9..main, excluding lines with `image_tag:`
sed -i -E "/image_tag:/!s/(['\"]?v?)${regex}\.\./\1${VERSION}../" "${README_MD}"
