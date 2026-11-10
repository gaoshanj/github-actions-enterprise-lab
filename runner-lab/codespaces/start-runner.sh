#!/usr/bin/env bash
set -euo pipefail
root="${RUNNER_ROOT:-$PWD/runner-runtime}"
test -x "$root/run.sh" || { echo "Runner is not installed"; exit 1; }
cd "$root"
exec ./run.sh
