#!/usr/bin/env sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

export BROWSER="${PROJECT_ROOT}/scripts/open-browser.sh"
export STORYBOOK_DISABLE_TELEMETRY=1

if command -v xdg-open >/dev/null 2>&1; then
  echo "xdg-open is installed; uninstall it to reproduce the ENOENT crash." >&2
fi

cd "${PROJECT_ROOT}"
npm run storybook

