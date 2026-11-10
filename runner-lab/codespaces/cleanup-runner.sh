#!/usr/bin/env bash
set -euo pipefail
root="${RUNNER_ROOT:-$PWD/runner-runtime}"
if [ -x "$root/config.sh" ]; then
  "$root/config.sh" remove --token "${RUNNER_TOKEN:-}" || true
fi
rm -rf "$root"
echo "PASS runner runtime removed"
