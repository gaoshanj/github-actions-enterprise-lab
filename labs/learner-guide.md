# Learner guide

## Prerequisites

- GitHub account with access to a training repository
- GitHub Codespaces access
- Permission to run Actions and manage a disposable runner
- Optional Kubernetes test cluster with `kubectl` and `helm`

## Sequence

1. Run `bash scripts/check-tools.sh`.
2. Run the application tests locally.
3. Open a pull request and observe `01-basic-ci.yml`.
4. Run Matrix CI and inspect cache and concurrency.
5. Run Build and Deploy; configure the `staging` environment if approvals are available.
6. Inspect the Composite Action and Reusable Workflow.
7. Complete the Codespaces runner procedure in `runner-lab/codespaces/README.md`.
8. Complete the Docker runner design exercise if Docker is available.
9. Complete the ARC procedure if a Kubernetes test cluster is available.
10. Run the final capstone workflow.

## Stop conditions

Stop and ask the instructor if a command requests a password, a runner token is about to be committed, a job runs on an unknown runner, or a Kubernetes resource is being created outside the training namespaces.
