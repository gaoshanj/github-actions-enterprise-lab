#!/usr/bin/env bash
set -euo pipefail

: "${RUNNER_REPO_URL:?Set RUNNER_REPO_URL}"
: "${RUNNER_TOKEN:?Set RUNNER_TOKEN}"

version="$(curl --fail --silent https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed 's/^v//')"
archive="actions-runner-linux-x64-${version}.tar.gz"
curl --fail --location --output "$archive" \
  "https://github.com/actions/runner/releases/download/v${version}/${archive}"
tar xzf "$archive"
rm "$archive"

cleanup() {
  ./config.sh remove --token "${RUNNER_TOKEN}" || true
}
trap cleanup EXIT

./config.sh \
  --url "$RUNNER_REPO_URL" \
  --token "$RUNNER_TOKEN" \
  --name "docker-${HOSTNAME}" \
  --labels "training,docker,ephemeral" \
  --ephemeral \
  --unattended

exec ./run.sh
