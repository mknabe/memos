#!/usr/bin/env bash
set -euo pipefail

PORT=5230
DATA_DIR="./dev-data"
SKIP_BUILD=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --port)
      PORT="${2:?missing value for --port}"
      shift 2
      ;;
    --data)
      DATA_DIR="${2:?missing value for --data}"
      shift 2
      ;;
    --skip-build)
      SKIP_BUILD=1
      shift
      ;;
    *)
      echo "unknown argument: $1" >&2
      exit 2
      ;;
  esac
done

if [[ ! -f "go.mod" || ! -d "web" ]]; then
  echo "run this script from the Memos repository root" >&2
  exit 1
fi

if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  # shellcheck disable=SC1091
  source "$HOME/.nvm/nvm.sh"
  nvm use 24 >/dev/null
fi

if [[ "$SKIP_BUILD" -eq 0 ]]; then
  pushd web >/dev/null
  if ! command -v pnpm >/dev/null 2>&1; then
    if command -v corepack >/dev/null 2>&1; then
      corepack enable
      corepack prepare pnpm@11.0.1 --activate
    else
      npm install -g pnpm@11.0.1
    fi
  fi
  if [[ ! -d "node_modules" ]]; then
    pnpm install
  fi
  pnpm release
  popd >/dev/null
fi

mkdir -p "$DATA_DIR"
exec go run ./cmd/memos --data "$DATA_DIR" --port "$PORT"
