#!/usr/bin/env bash
set -euo pipefail
set -x

echo "[deploy] start"
START_DIR="$(pwd)"
pwd
ls -la

# Detect app directory from common Vercel root-directory modes:
# - frontend root  => ./package.json + ./src
# - repo root      => ./frontend/package.json
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
APP_ABS_DIR="$(pwd)"
echo "[deploy] app dir: $APP_ABS_DIR"
ls -la

if [[ -f package-lock.json ]]; then
  npm ci --include=dev
else
  npm install --include=dev
fi

npm run build

# Ensure Vercel outputDirectory=dist is present at invocation root.
if [[ "$START_DIR" != "$APP_ABS_DIR" ]]; then
  rm -rf "$START_DIR/dist"
  cp -R "$APP_ABS_DIR/dist" "$START_DIR/dist"
  echo "[deploy] copied build output to $START_DIR/dist"
  ls -la "$START_DIR/dist"
fi
