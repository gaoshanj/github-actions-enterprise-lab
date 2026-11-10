# GitHub Actions 企业级实验室学员手册

## 1. 实验目标

完成本实验后，学员能够：

- 编写由 `push`、`pull_request` 和 `workflow_dispatch` 触发的 Workflow。
- 使用 Job、Step、Action、Context、Matrix、Cache 和 Artifact。
- 使用最小 `GITHUB_TOKEN` 权限。
- 构建 Docker 镜像并使用 Service Container 执行集成测试。
- 编写 Composite Action 和 Reusable Workflow。
- 在 Codespace 或 Docker 中运行一次性 Self-hosted Runner。
- 理解 Kubernetes ARC Runner Scale Set 的注册、调度、扩缩容和清理。
- 使用 CodeQL 完成 JavaScript 代码扫描。

企业治理、Copilot、真实生产部署和真实云凭据不属于本版本实验范围。

## 2. 前置条件

- GitHub 账号。
- GitHub Codespaces 使用权限。
- 对实验仓库具有 Actions 使用权限。
- 完成 Self-hosted Runner 实验时，需要仓库管理或 Runner 管理权限。
- ARC 实验需要 Kubernetes 测试集群、`kubectl` 和 `helm`。

不要使用生产仓库、生产 Runner 或生产 Secret。Self-hosted Runner 实验必须使用专用实验仓库或专用实验分支。

## 3. Codespace 初始化

在仓库页面选择 **Code → Codespaces → Create codespace on main**，等待 `.devcontainer/post-create.sh` 完成。

执行：

```bash
bash scripts/check-tools.sh
gh auth status
cd app/order-service
npm ci
npm run lint
npm test
npm run build
```

预期结果：

```text
PASS required tools are available
2 tests passed
```

## 4. Lab 01：基础 Workflow

文件：`.github/workflows/01-basic-ci.yml`

1. 创建一个分支。
2. 修改 `app/order-service/src/orders.js`。
3. 提交并创建 Pull Request。
4. 在 Actions 页面观察 Workflow。
5. 确认测试、Lint、Build 均通过。
6. 下载 `order-service-dist` Artifact。

重点观察：

- `pull_request` 触发方式。
- `permissions: contents: read`。
- 本地 Composite Action 的调用。
- Artifact 的上传。

## 5. Lab 02：Matrix、Cache 和权限

文件：`.github/workflows/02-matrix-ci.yml`

手动运行 Workflow，确认 Node.js 20 和 22 两个矩阵 Job 都成功。

观察：

- Matrix 如何生成多个 Job。
- `fail-fast: false` 的作用。
- `concurrency` 如何取消同一分支的旧运行。
- npm cache 如何由 `actions/setup-node` 配置。

执行权限检查：

```bash
bash scripts/validate-permissions.sh
```

## 6. Lab 03：构建、Service Container 和 Staging

文件：`.github/workflows/03-build-and-deploy.yml`

执行：

1. 运行 Workflow。
2. 检查 Docker 镜像是否构建成功。
3. 下载 `order-service-image` Artifact。
4. 检查 `integration` Job 的 Redis Service Container。
5. 检查 `staging` Job 的模拟部署输出。

在 GitHub-hosted Runner 上，Service Container 的端口通过 `localhost` 访问；本实验使用 `localhost:6379` 检查 Redis，而不是在宿主 Runner Job 中使用 `redis` 主机名。

如果配置了 `staging` Environment 的 Required Reviewer，部署 Job 会等待审批。

## 7. Lab 04：Composite Action

文件：`.github/actions/setup-project/action.yml`

检查该 Action 的输入和步骤：

- Node.js 版本输入。
- npm cache。
- `npm ci`。
- `working-directory`。

修改默认 Node.js 版本并重新运行 CI，确认调用方不需要复制安装逻辑。

## 8. Lab 05：Reusable Workflow

文件：

- `.github/workflows/reusable-node-ci.yml`
- `.github/workflows/04-reusable-workflow-consumer.yml`

执行：

1. 手动运行 `Reusable workflow consumer`。
2. 检查调用方通过 `with.node-version` 传递输入。
3. 检查被调用 Workflow 使用 `workflow_call`。
4. 确认测试在被调用 Workflow 中完成。

重点区别：

| 机制 | 复用范围 |
|---|---|
| Composite Action | 复用步骤 |
| Reusable Workflow | 复用完整 Job/Workflow |

## 9. Lab 06：Codespaces Self-hosted Runner

按照 [`runner-guide.zh-CN.md`](runner-guide.zh-CN.md) 的 Codespaces 部分执行。

关键要求：

- 使用专用实验仓库。
- 生成短期 Registration Token。
- 使用 `--ephemeral`。
- 使用 `training,codespace,ephemeral` 标签。
- 只运行测试，不读取生产 Secret。
- Job 完成后确认 Runner 已下线并清理。

## 10. Lab 07：Docker 临时 Runner

仅在 Codespace 中 `docker info` 成功时执行：

```bash
docker info
```

按照 Runner 手册构建和启动容器。Token 只能通过运行时环境变量传入，不得写入 Dockerfile 或镜像层。

## 11. Lab 08：Kubernetes ARC

ARC 是可选高级实验。需要测试集群和独立 Namespace。

实验顺序：

1. 创建 `arc-systems`。
2. 创建 `arc-runners`。
3. 安装 ARC Controller。
4. 创建 Runner Scale Set。
5. 设置 `minRunners: 0`、较小的 `maxRunners`。
6. 运行一个 Job，观察 Pod 创建和删除。
7. 并行运行三个 Job，观察扩容。
8. 设置错误 Label，诊断排队。
9. 清理 Scale Set、Namespace 和临时凭据。

## 12. Lab 09：CodeQL

文件：`.github/workflows/06-codeql.yml`

执行：

1. 手动运行 CodeQL。
2. 检查 `init`、`autobuild`、`analyze` 三个步骤。
3. 在 Security 页面查看 Code Scanning 结果。
4. 记录 Workflow Run URL 和结果。

## 13. Lab 10：Final Capstone

运行 `.github/workflows/07-final-capstone.yml`，确认以下全部通过：

- Lint
- Unit Test
- Build
- Job Summary

## 14. 停止条件

出现以下情况必须停止并联系讲师：

- 终端要求输入密码或未知凭据。
- Registration Token 即将写入文件或 Git。
- Job 被调度到未知 Runner。
- Runner 访问生产资源。
- Kubernetes 资源创建在非实验 Namespace。
- 发现长期在线且无法确认用途的 Runner。

## 15. 清理

实验结束后：

```bash
unset RUNNER_TOKEN GH_PAT
rm -rf runner-runtime
```

删除临时 Runner、临时仓库和 ARC Namespace。撤销只为培训创建的短期 Token。
