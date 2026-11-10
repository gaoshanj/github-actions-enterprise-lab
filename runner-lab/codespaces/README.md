# Codespaces Runner Lab

Use a disposable Codespace or a dedicated runner Codespace. Do not register the same Codespace that edits untrusted pull requests.

## Procedure

1. Confirm `gh auth status`.
2. Confirm repository admin or runner-management permission.
3. Obtain a short-lived registration token:

```bash
RUNNER_TOKEN="$(gh api --method POST \
  "repos/$GITHUB_ORG/$RUNNER_LAB_REPO/actions/runners/registration-token" \
  --jq '.token')"
```

4. Run `bash install-runner.sh`.
5. Start `bash start-runner.sh`.
6. Dispatch workflow `05-self-hosted-runner.yml`.
7. Verify the job uses labels `training`, `codespace`, and `ephemeral`.
8. Confirm the runner disappears after one job.
9. Run `bash cleanup-runner.sh`.

Never save `RUNNER_TOKEN` in a file or commit the runner directory.
