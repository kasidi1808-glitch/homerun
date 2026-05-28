#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../.."

if [ ! -d frontend ]; then
  echo "frontend folder not found"
  exit 1
fi

cd frontend

if [ -f package-lock.json ]; then
  npm ci --include=dev
else
  npm install
fi

npm run build
