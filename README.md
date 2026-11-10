# GitHub Actions Enterprise Lab

This repository is a hands-on GitHub Actions lab for GitHub Codespaces. It covers workflow fundamentals, CI/CD orchestration, reusable workflows, composite actions, CodeQL, and disposable self-hosted runners.

The lab has two runner paths:

1. **Codespaces/Docker runner**: a disposable runner for a single job.
2. **Kubernetes ARC**: an optional runner scale set exercise for teams that have a Kubernetes test cluster.

Enterprise governance and Copilot are intentionally out of scope for this version. Never commit runner registration tokens, GitHub App private keys, cloud credentials, or production secrets.

## Quick start

Open the repository in a Codespace, then run:

```bash
bash scripts/check-tools.sh
cd app/order-service
npm ci
npm test
npm run lint
```

The runnable workflows are under `.github/workflows/`. The self-hosted workflow is `workflow_dispatch` only and will wait until a matching disposable runner is registered.

## Lab sequence

| Lab | Topic |
|---|---|
| 01 | Workflow events, jobs, steps, contexts, artifacts |
| 02 | Matrix CI, cache, concurrency, permissions |
| 03 | Build, service containers, staging deployment |
| 04 | Composite Action |
| 05 | Reusable Workflow |
| 06 | Codespaces self-hosted runner |
| 07 | Docker ephemeral runner |
| 08 | Kubernetes ARC runner scale set |
| 09 | CodeQL and supply-chain controls |
| 10 | Final capstone |

See `docs/learner-guide.md` for the detailed sequence and `runner-lab/` for runner-specific procedures.
