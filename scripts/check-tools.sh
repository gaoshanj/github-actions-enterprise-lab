#!/usr/bin/env bash
set -euo pipefail
for tool in git gh node npm curl jq tar; do
  command -v "$tool" >/dev/null || { echo "Missing tool: $tool" >&2; exit 1; }
done
echo "PASS required tools are available"
