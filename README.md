# GitHub Actions Enterprise Lab / GitHub Actions 企业级实验室

本仓库是一个基于 GitHub Codespaces 的 GitHub Actions 实战实验室。
This repository is a hands-on GitHub Actions lab for GitHub Codespaces.

实验覆盖工作流基础、CI/CD 编排、Reusable Workflow、Composite Action、CodeQL，以及一次性 Self-hosted Runner。
It covers workflow fundamentals, CI/CD orchestration, reusable workflows, composite actions, CodeQL, and disposable self-hosted runners.

## Scope / 实验范围

- 工作流基础、Matrix、Cache、Artifact / Workflow fundamentals, matrix, cache, and artifacts
- Docker 构建、Service Container、Staging 模拟部署 / Docker build, service containers, and simulated staging deployment
- Composite Action、Reusable Workflow / Composite Actions and reusable workflows
- Codespaces、Docker 和 Kubernetes ARC Runner / Codespaces, Docker, and Kubernetes ARC runners
- CodeQL 和供应链安全基础 / CodeQL and supply-chain security fundamentals

企业治理和 Copilot 不在当前版本范围内。
Enterprise governance and Copilot are intentionally out of scope for this version.

## Quick start / 快速开始

在 Codespace 中打开仓库，然后执行：
Open the repository in a Codespace, then run:

```bash
bash scripts/check-tools.sh
cd app/order-service
npm ci
npm test
npm run lint
npm run build
```

可执行 Workflow 位于 `.github/workflows/`。Self-hosted Runner Workflow 只支持 `workflow_dispatch`，在注册匹配的临时 Runner 前会保持排队。
Runnable workflows are under `.github/workflows/`. The self-hosted workflow is `workflow_dispatch` only and waits until a matching disposable runner is registered.

## Lab sequence / 实验顺序

| Lab | 中文主题 | English topic |
|---|---|---|
| 01 | Workflow 事件、Job、Step、Context、Artifact | Events, jobs, steps, contexts, artifacts |
| 02 | Matrix CI、Cache、Concurrency、权限 | Matrix CI, cache, concurrency, permissions |
| 03 | 构建、Service Container、Staging 部署 | Build, service containers, staging deployment |
| 04 | Composite Action | Composite Action |
| 05 | Reusable Workflow | Reusable Workflow |
| 06 | Codespaces Self-hosted Runner | Codespaces self-hosted runner |
| 07 | Docker 临时 Runner | Docker ephemeral runner |
| 08 | Kubernetes ARC Runner Scale Set | Kubernetes ARC runner scale set |
| 09 | CodeQL 和供应链控制 | CodeQL and supply-chain controls |
| 10 | 综合实验 | Final capstone |

中文学员手册：[`docs/learner-guide.zh-CN.md`](docs/learner-guide.zh-CN.md)
Chinese learner guide: [`docs/learner-guide.zh-CN.md`](docs/learner-guide.zh-CN.md)

English learner guide: [`docs/learner-guide.en-US.md`](docs/learner-guide.en-US.md)

中文 Runner 手册：[`docs/runner-guide.zh-CN.md`](docs/runner-guide.zh-CN.md)
Chinese runner guide: [`docs/runner-guide.zh-CN.md`](docs/runner-guide.zh-CN.md)

English runner guide: [`docs/runner-guide.en-US.md`](docs/runner-guide.en-US.md)

Never commit runner registration tokens, GitHub App private keys, cloud credentials, or production secrets.
严禁提交 Runner 注册 Token、GitHub App 私钥、云凭据或生产 Secret。
