#!/usr/bin/env bash
set -euo pipefail
failed=0
while IFS= read -r file; do
  if grep -qE '^[[:space:]]+actions:[[:space:]]+write|^[[:space:]]+contents:[[:space:]]+write' "$file"; then
    echo "Review elevated permission in $file"
    failed=1
  fi
done < <(find .github/workflows -type f -name '*.yml' -o -name '*.yaml')
if [ "$failed" -ne 0 ]; then
  exit 1
fi
echo "PASS workflow permissions require no unexpected write access"
