#!/usr/bin/env bash
set -euo pipefail
set -x

echo "[deploy] start"
pwd
ls -la

# Detect app directory from common Vercel root-directory modes:
# - repo root      => ./frontend/package.json
# - frontend root  => ./package.json + ./src
# - backend root   => ../frontend/package.json
if [[ -f package.json && -d src ]]; then
  APP_DIR="."
elif [[ -f frontend/package.json ]]; then
  APP_DIR="frontend"
elif [[ -f ../frontend/package.json ]]; then
  APP_DIR="../frontend"
else
  echo "[deploy] Could not locate frontend package.json from $(pwd)" >&2
  exit 1
fi

cd "$APP_DIR"
echo "[deploy] app dir: $(pwd)"
ls -la

if [[ -f package-lock.json ]]; then
  npm ci --include=dev
else
  npm install --include=dev
fi

npm run build
