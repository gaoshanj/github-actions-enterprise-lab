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

每个 YAML 最多包含 4 处需要学员补全的内容，且每个模块的 TODO 对应本模块的核心知识点。其余样板代码保持完整，避免把实验变成机械填空。

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

补全以下 4 处：

- 事件配置：`push` 到 `main`、`pull_request`、`workflow_dispatch`。
- `contents: read` 权限。
- GitHub-hosted Ubuntu Runner。
- Artifact 的上传位置和名称。

Checkout、Composite Action、Node 命令和工作目录已提供，重点练习基础触发器、最小权限、Runner 与 Artifact。

### 3.2 Matrix CI

补全以下 4 处：

- Pull Request 和手动触发。
- 按 Workflow 与 Git ref 分组的并发控制，并启用取消旧运行。
- Node.js `20` 和 `22` 的 Matrix。
- 将 Matrix 版本传给 Composite Action。

权限、Runner、Checkout 和测试命令已提供，重点练习 Matrix、Concurrency 和动态输入。

### 3.3 Build and Deploy

补全以下 4 处：

- push 到 `main` 和手动触发。
- `build` Job 输出引用：`${{ steps.meta.outputs.tag }}`。
- integration Job 对 `build` 的依赖。
- staging Job 同时依赖两个前置 Job，并绑定 `staging` Environment。

Docker、Redis Service Container、健康检查和 Artifact 样板已提供，重点练习 Job 输出、Job 依赖和 Environment。

Service Container 在宿主 Runner Job 中通过发布端口访问，本实验使用 `localhost:6379`，不要直接照搬容器网络场景中的 `redis` 主机名。

### 3.4 Reusable Workflow

调用方补全以下 3 处：

```yaml
uses: ./.github/workflows/reusable-node-ci.yml
with:
  node-version: '22'
```

被调用 Workflow 只补全以下 2 处：

- `workflow_call`。
- 定义 `node-version` 字符串输入，并在 Job 中使用 `${{ inputs.node-version }}`。

权限、Runner、Checkout 和 Composite Action 已提供，重点练习调用方与被调用方的接口契约。

### 3.5 Self-hosted Runner

只补全 1 处：`runs-on` 必须同时匹配：

```yaml
[self-hosted, linux, x64, training, codespace, ephemeral]
```

所有 Label 都是 AND 条件，缺少一个 Label 都会导致 Job 排队。

### 3.6 CodeQL

补全以下 3 处：

- push 到 `main`、pull_request、每周定时任务和 workflow_dispatch。
- `security-events: write` 权限。
- JavaScript 扫描语言。

Checkout、Runner、CodeQL Init/Autobuild/Analyze 已提供，重点练习事件、权限和语言配置。

### 3.7 Final Capstone

补全以下 2 处：

- `workflow_dispatch` 手动触发。
- 将验收结果写入 `GITHUB_STEP_SUMMARY`。

其它 CI 步骤已提供，重点练习手动执行和 Job Summary。

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
