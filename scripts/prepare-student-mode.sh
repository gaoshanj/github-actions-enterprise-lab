#!/usr/bin/env bash
set -euo pipefail

backup=".lab-instructor-backup"
mkdir -p "$backup/workflows" "$backup/actions/setup-project"
cp .github/workflows/*.yml "$backup/workflows/"
cp .github/actions/setup-project/action.yml "$backup/actions/setup-project/"
cp student-templates/workflows/*.yml .github/workflows/
cp student-templates/actions/setup-project/action.yml .github/actions/setup-project/action.yml
echo "Student templates installed."
echo "Complete TODOs, then run the workflows from a disposable branch."
echo "Instructor files were backed up under $backup (ignored by Git)."
