#!/usr/bin/env bash
set -euo pipefail

: "${RUNNER_REPO_URL:?Set RUNNER_REPO_URL}"
: "${RUNNER_TOKEN:?Set RUNNER_TOKEN}"

docker build -t github-actions-training-runner .
docker run --rm \
  --name "github-actions-training-runner-${RANDOM}" \
  -e RUNNER_REPO_URL \
  -e RUNNER_TOKEN \
  github-actions-training-runner
