#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y jq shellcheck
printf 'Tools installed:\n'
git --version
gh --version
node --version
npm --version
docker --version
jq --version
