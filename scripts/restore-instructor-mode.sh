#!/usr/bin/env bash
set -euo pipefail

if [ -d ".lab-instructor-backup/workflows" ]; then
  cp .lab-instructor-backup/workflows/*.yml .github/workflows/
  cp .lab-instructor-backup/actions/setup-project/action.yml .github/actions/setup-project/action.yml
else
  cp answers/workflows/*.yml .github/workflows/
  cp answers/actions/setup-project/action.yml .github/actions/setup-project/action.yml
fi
echo "Working workflows restored."
