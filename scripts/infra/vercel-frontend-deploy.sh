#!/usr/bin/env bash
set -euo pipefail
set -x

echo "[deploy] starting vercel frontend deploy script"
pwd
ls -la

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Run from repo root so paths are stable.
cd "$REPO_ROOT"

echo "[deploy] repo root: $(pwd)"
ls -la

# Validate required tools exist in Vercel environment.
command -v bash
command -v node
command -v npm

if [ ! -d frontend ]; then
  echo "[deploy] frontend folder not found at $REPO_ROOT/frontend" >&2
  exit 1
fi

cd frontend

echo "[deploy] frontend dir: $(pwd)"
ls -la

if [ -f package-lock.json ]; then
  npm ci --include=dev
else
  echo "[deploy] package-lock.json missing; using npm install fallback" >&2
  npm install --include=dev
fi

npm run build
