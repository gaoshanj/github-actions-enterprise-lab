#!/usr/bin/env bash
set -euo pipefail
: "${GITHUB_ORG:?Set GITHUB_ORG}"
: "${RUNNER_LAB_REPO:?Set RUNNER_LAB_REPO}"
: "${RUNNER_TOKEN:?Set RUNNER_TOKEN}"

root="${RUNNER_ROOT:-$PWD/runner-runtime}"
mkdir -p "$root"
cd "$root"
version="$(curl --fail --silent https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/^v//')"
archive="actions-runner-linux-x64-${version}.tar.gz"
curl --fail --location --output "$archive" "https://github.com/actions/runner/releases/download/v${version}/${archive}"
tar xzf "$archive"
rm "$archive"
./config.sh \
  --url "https://github.com/${GITHUB_ORG}/${RUNNER_LAB_REPO}" \
  --token "$RUNNER_TOKEN" \
  --name "codespace-${RANDOM}" \
  --labels "training,codespace,ephemeral" \
  --ephemeral \
  --unattended
echo "PASS runner installed at $root"
