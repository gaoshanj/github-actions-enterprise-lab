# Exploratory CI/CD Lab Guide

## 1. Exercise mode

The CI/CD workflows are provided in two forms:

```text
answers/              complete working solutions for instructors
student-templates/    incomplete learner templates with TODO comments
```

The root `.github/workflows/` directory remains a runnable baseline for instructor validation. Learners should work on a disposable branch and run:

```bash
bash scripts/prepare-student-mode.sh
git status --short
```

The script:

1. Backs up the working solutions to the Git-ignored `.lab-instructor-backup/`.
2. Copies `student-templates/workflows/` into `.github/workflows/`.
3. Copies the student Composite Action into `.github/actions/setup-project/action.yml`.

Each YAML file contains at most four learner-completion points. The TODOs are different for each module and map to that module's core concepts; the remaining boilerplate is complete so the exercise focuses on reasoning instead of repetitive typing.

> Do not run student mode on `main`. Use a temporary branch or a separate Codespace branch.

## 2. Learner procedure

### Step 1: Create a learning branch

```bash
git switch -c lab/student-workflows
```

### Step 2: Install the incomplete templates

```bash
bash scripts/prepare-student-mode.sh
```

### Step 3: Complete the modules

| Module | File | Main concepts |
|---|---|---|
| 1 | `01-basic-ci.yml` | Events, runner, permissions, artifact |
| 2 | `02-matrix-ci.yml` | Matrix, cache, concurrency |
| 3 | `03-build-and-deploy.yml` | Docker, service container, job outputs, environment |
| 4 | `04-reusable-workflow-consumer.yml` | Calling a workflow |
| 5 | `reusable-node-ci.yml` | `workflow_call`, inputs |
| 6 | `05-self-hosted-runner.yml` | Labels and self-hosted runners |
| 7 | `06-codeql.yml` | CodeQL permissions and language |
| 8 | `07-final-capstone.yml` | Orchestration and job summary |
| 9 | `setup-project/action.yml` | Composite Action |

### Step 4: Run static checks first

```bash
bash scripts/check-tools.sh
bash scripts/validate-permissions.sh
```

Find unresolved TODOs:

```bash
grep -R "TODO_\|TODO:" .github/workflows .github/actions
```

Do not submit until all TODOs are resolved.

### Step 5: Run workflows in sequence

Recommended order:

1. Basic CI
2. Matrix CI
3. Build and Deploy
4. Reusable Workflow Consumer
5. CodeQL
6. Final Capstone
7. Self-hosted Runner, after registering a runner

Record the Workflow Run URL, job name, result, failure log location, and YAML lines changed.

## 3. TODO requirements

### 3.1 Basic CI

Complete these four points:

- Events: push to `main`, pull request, and manual dispatch.
- `contents: read` permission.
- GitHub-hosted Ubuntu runner.
- Artifact name and path.

Checkout, the Composite Action, Node commands, and working directory are provided. This module focuses on triggers, least privilege, runner selection, and artifacts.

### 3.2 Matrix CI

Complete these four points:

- Pull request and manual triggers.
- Concurrency grouping by workflow and Git ref, with cancellation of older runs.
- Node.js 20 and 22 matrix values.
- Passing the matrix version to the Composite Action.

Permissions, runner, checkout, and test commands are provided. This module focuses on Matrix, Concurrency, and dynamic inputs.

### 3.3 Build and Deploy

Complete these four points:

- Push to `main` and manual dispatch.
- The `build` output reference `${{ steps.meta.outputs.tag }}`.
- The integration job dependency on `build`.
- The staging job dependency on both upstream jobs and its `staging` Environment.

Docker, the Redis service container, health checks, and artifact steps are provided. This module focuses on job outputs, dependencies, and Environments.

For a host runner job, a published service-container port is reached through `localhost`. This lab uses `localhost:6379`; do not copy the `redis` hostname from a job-container network example.

### 3.4 Reusable Workflow

The caller has three completion points:

```yaml
uses: ./.github/workflows/reusable-node-ci.yml
with:
  node-version: '22'
```

The called workflow has two completion points: define `workflow_call` with a string `node-version` input, and consume `${{ inputs.node-version }}`.

Permissions, runner, checkout, and the Composite Action are provided. This module focuses on the caller/callee interface contract.

### 3.5 Self-hosted Runner

Complete one point: `runs-on` must match all of:

```yaml
[self-hosted, linux, x64, training, codespace, ephemeral]
```

All labels are AND conditions. One missing label leaves the job queued.

### 3.6 CodeQL

Complete these three points:

- Push to `main`, pull request, weekly schedule, and manual dispatch.
- `security-events: write` permission.
- JavaScript scan language.

Checkout, runner, and CodeQL Init/Autobuild/Analyze are provided. This module focuses on events, permissions, and language configuration.

### 3.7 Final Capstone

Complete two points:

- Manual `workflow_dispatch`.
- Append the validation result to `GITHUB_STEP_SUMMARY`.

The other CI steps are provided. This module focuses on manual execution and Job Summary.

## 4. Checking the solution

The instructor can run:

```bash
bash scripts/validate-permissions.sh
grep -R "TODO_\|TODO:" .github/workflows .github/actions || true
```

Then run all Hosted Runner workflows.

The answer key is for instructor comparison only:

```text
answers/workflows/
answers/actions/setup-project/action.yml
```

Learners should explain each trigger, permission, job dependency, and runner choice instead of copying the answer key.

## 5. Restore the instructor baseline

After the exercise:

```bash
bash scripts/restore-instructor-mode.sh
git status --short
```

Perform cleanup on the temporary branch. Do not use destructive Git commands on the instructor `main` branch.
