# Self-hosted Runner Lab Guide

## 1. Security boundary

A self-hosted runner can access the host, network, and filesystem where it runs. Use only a dedicated training repository and harmless test code.

Do not:

- Run unknown pull requests on the runner.
- Read production secrets.
- Use production cloud credentials.
- Commit a registration token.
- Leave a training runner online indefinitely.

Prefer `--ephemeral` so each runner executes one job.

## 2. Codespaces runner

### Step 1: Set variables

```bash
export GITHUB_ORG="YOUR_ORG"
export RUNNER_LAB_REPO="YOUR_RUNNER_REPO"
gh auth status
```

### Step 2: Create a registration token

```bash
export RUNNER_TOKEN="$(gh api --method POST \
  "repos/$GITHUB_ORG/$RUNNER_LAB_REPO/actions/runners/registration-token" \
  --jq '.token')"
test -n "$RUNNER_TOKEN"
```

Keep the token in the current shell only. Do not print it.

### Step 3: Install the runner

```bash
cd runner-lab/codespaces
bash install-runner.sh
```

The script downloads the current runner release and registers these labels:

```text
training,codespace,ephemeral
```

### Step 4: Start the runner

In the first terminal:

```bash
bash start-runner.sh
```

Keep that terminal running. In a second terminal, manually dispatch `.github/workflows/05-self-hosted-runner.yml`.

### Step 5: Verify

```bash
gh api \
  "repos/$GITHUB_ORG/$RUNNER_LAB_REPO/actions/runners" \
  --jq '.runners[] | {name,status,busy,labels:[.labels[].name]}'
```

The job output must include `RUNNER_NAME`, `RUNNER_OS`, and `RUNNER_ARCH`.

### Step 6: Confirm cleanup

After the job succeeds, the runner should go offline or be removed:

```bash
bash cleanup-runner.sh
unset RUNNER_TOKEN
```

### Common failures

| Symptom | Cause | Action |
|---|---|---|
| Job remains queued | Labels do not match | Compare `runs-on` with runner labels |
| Runner is offline | `run.sh` stopped | Restart or register a new runner |
| Second job has no runner | Ephemeral runner already ran once | Register a new runner |
| Runner is online but job does not run | Runner Group excludes the repository | Check the organization Runner Group allow list |

## 3. Docker ephemeral runner

### Step 1: Check Docker

```bash
docker info
```

Stop if this fails.

### Step 2: Set variables

```bash
export RUNNER_REPO_URL="https://github.com/YOUR_ORG/YOUR_REPO"
export RUNNER_TOKEN="short-lived registration token"
```

### Step 3: Build and run

```bash
cd runner-lab/docker
bash start-container.sh
```

The container uses `--rm` and the runner uses `--ephemeral` with the labels `training,docker,ephemeral`. The token is passed only at runtime and is not included in the image.

### Step 4: Verify the lifecycle

While the job is running:

```bash
docker ps
docker logs -f <container>
```

After completion:

```bash
docker ps -a
unset RUNNER_TOKEN
```

No long-lived runner container should remain.

## 4. Kubernetes ARC runner scale set

### Step 1: Check the cluster

```bash
kubectl version --client
kubectl cluster-info
kubectl get nodes
helm version
```

### Step 2: Create dedicated namespaces

```bash
kubectl create namespace arc-systems
kubectl create namespace arc-runners
```

Do not use `default` or a production namespace.

### Step 3: Choose authentication

A short-lived PAT is acceptable for a controlled training exercise. GitHub App authentication is preferred for production. Neither credential may be committed.

### Step 4: Install the ARC controller

Before installation, verify the current Helm chart version and values against the official ARC documentation. Then inspect:

```bash
kubectl get pods -n arc-systems
kubectl get crd | grep -i runner
```

### Step 5: Create a runner scale set

Use `runner-lab/kubernetes/scale-set-values.yaml` as a reference and start with:

```text
runnerScaleSetName: training-arc
minRunners: 0
maxRunners: 3
```

The GitHub repository, Runner Group, and authentication Secret must all be training-only resources.

### Step 6: Run one job

The workflow uses:

```yaml
runs-on: training-arc
```

Watch the Pods:

```bash
kubectl get pods -n arc-runners -w
```

Expected lifecycle:

```text
No Pod → Runner Pod created → Job runs → Pod deleted
```

### Step 7: Verify scale-out

Run three jobs in parallel. Observe the Pod count grow from 0 to at most 3. Additional jobs must remain queued after `maxRunners` is reached.

### Step 8: Troubleshooting

Invalid label or scale-set name:

```bash
kubectl get pods -n arc-runners
gh run list --repo "$GITHUB_ORG/$RUNNER_LAB_REPO"
```

Image pull failure:

```bash
kubectl describe pod -n arc-runners <pod>
kubectl get events -n arc-runners --sort-by=.lastTimestamp
```

Insufficient resources:

```bash
kubectl describe node
kubectl describe pod -n arc-runners <pod>
```

### Step 9: Cleanup

1. Stop workflows.
2. Delete the runner scale set.
3. Confirm runner Pods are gone.
4. Delete `arc-runners`.
5. Delete `arc-systems`.
6. Remove the training Runner Group.
7. Revoke the short-lived PAT or uninstall the training GitHub App.
