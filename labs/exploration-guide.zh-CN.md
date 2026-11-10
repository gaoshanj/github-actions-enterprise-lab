# 探索式 CI/CD 实验手册（中文）

## 1. 实验模式

本实验把 CI/CD Workflow 分为两份：

```text
answers/              完整正确答案，仅供讲师和验收使用
student-templates/    学员待补全模板，包含 TODO 注释
```

仓库根目录的 `.github/workflows/` 仍保留可运行基线，便于讲师先验证环境。学员应在临时分支执行：

```bash
bash scripts/prepare-student-mode.sh
git status --short
```

脚本会：

1. 将当前正确答案备份到被 Git 忽略的 `.lab-instructor-backup/`。
2. 将 `student-templates/workflows/` 复制到 `.github/workflows/`。
3. 将学员 Composite Action 复制到 `.github/actions/setup-project/action.yml`。

完成后，所有 TODO 都需要由学员补全，Workflow 才能正常执行。

> 不要在 `main` 分支执行学员模式。请先创建临时分支或单独的 Codespace 分支。

## 2. 学员操作流程

### Step 1：创建学习分支

```bash
git switch -c lab/student-workflows
```

### Step 2：安装待补全模板

```bash
bash scripts/prepare-student-mode.sh
```

### Step 3：按模块补全

| 模块 | 文件 | 主要知识点 |
|---|---|---|
| 1 | `01-basic-ci.yml` | 事件、Runner、权限、Artifact |
| 2 | `02-matrix-ci.yml` | Matrix、Cache、Concurrency |
| 3 | `03-build-and-deploy.yml` | Docker、Service Container、Job outputs、Environment |
| 4 | `04-reusable-workflow-consumer.yml` | Workflow 调用 |
| 5 | `reusable-node-ci.yml` | `workflow_call`、输入参数 |
| 6 | `05-self-hosted-runner.yml` | Labels 和 Self-hosted Runner |
| 7 | `06-codeql.yml` | CodeQL 权限和扫描语言 |
| 8 | `07-final-capstone.yml` | 综合编排和 Job Summary |
| 9 | `setup-project/action.yml` | Composite Action |

### Step 4：先做静态检查

```bash
bash scripts/check-tools.sh
bash scripts/validate-permissions.sh
```

检查 TODO：

```bash
grep -R "TODO_\|TODO:" .github/workflows .github/actions
```

在所有 TODO 解决前，不要提交答案。

### Step 5：逐个运行 Workflow

推荐顺序：

1. Basic CI
2. Matrix CI
3. Build and Deploy
4. Reusable Workflow Consumer
5. CodeQL
6. Final Capstone
7. Self-hosted Runner（完成 Runner 注册后）

每个模块都需要记录：

- Workflow Run URL
- Job 名称
- 成功或失败结果
- 失败时的日志位置
- 修正的 YAML 行

## 3. TODO 补全要求

### 3.1 Basic CI

必须补全：

- `push` 的 `main` 分支过滤。
- `pull_request` 和 `workflow_dispatch`。
- `contents: read`。
- `ubuntu-latest`。
- `actions/checkout@v4`。
- 本地 Composite Action。
- `npm run lint`、`npm test`、`npm run build`。
- `app/order-service` 工作目录。
- `order-service-dist` Artifact。

### 3.2 Matrix CI

必须补全：

- Pull Request 和手动触发。
- `contents: read`。
- 按 Workflow 和 Git ref 分组的并发控制。
- `cancel-in-progress: true`。
- Node.js `20` 和 `22`。
- `${{ matrix.node }}`。

### 3.3 Build and Deploy

必须补全：

- `build` Job 输出 `image-tag`。
- `${{ steps.meta.outputs.tag }}`。
- Docker build 和 Docker save。
- Redis Service Container。
- `needs: build`。
- `localhost:6379` 连接检查。
- `needs: [build, integration]`。
- `environment: staging`。

Service Container 在宿主 Runner Job 中通过发布端口访问，本实验使用 `localhost:6379`，不要直接照搬容器网络场景中的 `redis` 主机名。

### 3.4 Reusable Workflow

调用方需要：

```yaml
uses: ./.github/workflows/reusable-node-ci.yml
with:
  node-version: '22'
```

被调用 Workflow 需要：

- `workflow_call`。
- 字符串输入 `node-version`。
- 默认值 `22`。
- 使用 `${{ inputs.node-version }}`。

### 3.5 Self-hosted Runner

`runs-on` 必须同时匹配：

```yaml
[self-hosted, linux, x64, training, codespace, ephemeral]
```

所有 Label 都是 AND 条件，缺少一个 Label 都会导致 Job 排队。

### 3.6 CodeQL

必须补全：

- `push` 到 `main`。
- `pull_request`。
- 每周定时任务。
- `workflow_dispatch`。
- `contents: read`。
- `security-events: write`。
- `github/codeql-action/init@v3`。
- `languages: javascript`。
- `autobuild` 和 `analyze`。

## 4. 正确答案检查

学员完成后，讲师可以使用：

```bash
bash scripts/validate-permissions.sh
grep -R "TODO_\|TODO:" .github/workflows .github/actions || true
```

然后运行全部 Hosted Runner Workflow。

答案目录仅用于讲师对照：

```text
answers/workflows/
answers/actions/setup-project/action.yml
```

不要让学员直接复制答案；应要求学员解释每个触发器、权限、Job 依赖和 Runner 选择。

## 5. 恢复讲师基线

完成实验或需要恢复可运行基线时：

```bash
bash scripts/restore-instructor-mode.sh
git status --short
```

如果要清理学员修改，请在临时分支中操作，不要对讲师的 `main` 分支执行破坏性 Git 命令。
