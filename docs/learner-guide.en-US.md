# GitHub Actions Enterprise Lab - Learner Guide

## 1. Objectives

By the end of this lab, learners can:

- Write workflows triggered by `push`, `pull_request`, and `workflow_dispatch`.
- Use jobs, steps, actions, contexts, matrices, caches, and artifacts.
- Apply least-privilege `GITHUB_TOKEN` permissions.
- Build a Docker image and run integration checks with a service container.
- Write a composite action and a reusable workflow.
- Run a disposable self-hosted runner in Codespaces or Docker.
- Understand Kubernetes ARC runner scale-set registration, scheduling, scaling, and cleanup.
- Run CodeQL analysis for JavaScript.

Enterprise governance, Copilot, real production deployment, and real cloud credentials are out of scope.

## 2. Prerequisites

- A GitHub account.
- GitHub Codespaces access.
- Permission to run Actions in the training repository.
- Repository administration or runner-management permission for self-hosted runner labs.
- `kubectl`, `helm`, and a Kubernetes test cluster for the ARC lab.

Do not use a production repository, production runner, or production secret. Use a dedicated training repository or branch for runner experiments.

## 3. Codespace initialization

Open the repository with **Code → Codespaces → Create codespace on main** and wait for `.devcontainer/post-create.sh`.

Run:

```bash
bash scripts/check-tools.sh
gh auth status
cd app/order-service
npm ci
npm run lint
npm test
npm run build
```

Expected result:

```text
PASS required tools are available
2 tests passed
```

## 4. Lab 01: Basic workflow

File: `.github/workflows/01-basic-ci.yml`

1. Create a branch.
2. Modify `app/order-service/src/orders.js`.
3. Commit and open a pull request.
4. Observe the workflow in the Actions tab.
5. Confirm lint, tests, and build pass.
6. Download the `order-service-dist` artifact.

Observe the `pull_request` trigger, `contents: read`, the local composite action, and artifact upload.

## 5. Lab 02: Matrix, cache, and permissions

File: `.github/workflows/02-matrix-ci.yml`

Run the workflow manually and confirm both Node.js 20 and Node.js 22 jobs pass.

Observe:

- How a matrix creates multiple jobs.
- The effect of `fail-fast: false`.
- How `concurrency` cancels obsolete runs for the same branch.
- How `actions/setup-node` configures npm caching.

Run:

```bash
bash scripts/validate-permissions.sh
```

## 6. Lab 03: Build, service container, and staging

File: `.github/workflows/03-build-and-deploy.yml`

1. Run the workflow.
2. Confirm the Docker image builds.
3. Download the `order-service-image` artifact.
4. Inspect the Redis service container in the `integration` job.
5. Inspect the simulated staging deployment output.

For a job running directly on a GitHub-hosted runner, published service-container ports are reached through `localhost`. This lab checks Redis on `localhost:6379`; it does not use the `redis` hostname from a host runner job.

If Required Reviewers are configured for the `staging` environment, the deployment job waits for approval.

## 7. Lab 04: Composite Action

File: `.github/actions/setup-project/action.yml`

Inspect the Node.js input, npm cache, `npm ci`, and working directory. Change the default Node.js version and rerun CI to confirm callers do not duplicate setup steps.

## 8. Lab 05: Reusable Workflow

Files:

- `.github/workflows/reusable-node-ci.yml`
- `.github/workflows/04-reusable-workflow-consumer.yml`

1. Run `Reusable workflow consumer` manually.
2. Confirm the caller passes `node-version` through `with`.
3. Confirm the called workflow uses `workflow_call`.
4. Confirm tests run in the called workflow.

| Mechanism | Reuse unit |
|---|---|
| Composite Action | Steps |
| Reusable Workflow | Jobs or a complete workflow |

## 9. Lab 06: Codespaces self-hosted runner

Follow the Codespaces section in [`runner-guide.en-US.md`](runner-guide.en-US.md).

Requirements:

- Use a dedicated training repository.
- Generate a short-lived registration token.
- Use `--ephemeral`.
- Use the `training,codespace,ephemeral` labels.
- Run tests only; do not read production secrets.
- Confirm the runner goes offline and is cleaned up after the job.

## 10. Lab 07: Docker ephemeral runner

Run this only if Docker works in the Codespace:

```bash
docker info
```

Build and start the container as described in the runner guide. Pass the token only at runtime; never put it in the Dockerfile or image layers.

## 11. Lab 08: Kubernetes ARC

The ARC lab is optional and requires a test cluster and dedicated namespaces.

Sequence:

1. Create `arc-systems`.
2. Create `arc-runners`.
3. Install the ARC controller.
4. Create a runner scale set.
5. Set `minRunners: 0` and a small `maxRunners`.
6. Run one job and observe Pod creation and deletion.
7. Run three parallel jobs and observe scale-out.
8. Use an invalid label and diagnose the queued job.
9. Remove the scale set, namespaces, and temporary credentials.

## 12. Lab 09: CodeQL

File: `.github/workflows/06-codeql.yml`

Run CodeQL manually, inspect `init`, `autobuild`, and `analyze`, and review the Code Scanning result in the Security tab.

## 13. Lab 10: Final capstone

Run `.github/workflows/07-final-capstone.yml` and confirm lint, unit tests, build, and the job summary all pass.

## 14. Stop conditions

Stop and contact the instructor if a terminal requests a password or unknown credential, a registration token is about to be written to disk or Git, a job is assigned to an unknown runner, a runner can reach production resources, a Kubernetes object is created outside the training namespaces, or a long-lived runner cannot be explained.

## 15. Cleanup

At the end:

```bash
unset RUNNER_TOKEN GH_PAT
rm -rf runner-runtime
```

Delete temporary runners, repositories, and ARC namespaces. Revoke short-lived credentials created for training.
