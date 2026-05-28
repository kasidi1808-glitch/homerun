#!/usr/bin/env bash
set -euo pipefail

# Supports two Vercel root-directory modes:
# 1) repo root (contains ./frontend)
# 2) frontend root (contains ./package.json)
if [[ -f package.json && -d src ]]; then
  APP_DIR="."
elif [[ -f frontend/package.json ]]; then
  APP_DIR="frontend"
else
  echo "Unable to locate frontend package.json. Checked ./package.json and ./frontend/package.json" >&2
  exit 1
fi

cd "$APP_DIR"

echo "Using app directory: $(pwd)"

if [[ -f package-lock.json ]]; then
  npm ci --include=dev
else
  echo "package-lock.json missing; running npm install to regenerate lockfile" >&2
  npm install --include=dev
fi

npm run build
