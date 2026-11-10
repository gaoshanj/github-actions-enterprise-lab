# Self-hosted Runner 实验手册（中文）

## 1. 安全边界

Self-hosted Runner 可以访问运行它的主机、网络和文件系统。只使用专用实验仓库和无害测试代码。

禁止：

- 在 Runner 上运行未知 Pull Request。
- 读取生产 Secret。
- 使用生产云凭据。
- 将 Registration Token 写入 Git。
- 让培训 Runner 长期在线。

推荐使用 `--ephemeral`，每个 Runner 只执行一个 Job。

## 2. Codespaces Runner

### Step 1：准备变量

```bash
export GITHUB_ORG="YOUR_ORG"
export RUNNER_LAB_REPO="YOUR_RUNNER_REPO"
gh auth status
```

### Step 2：创建 Registration Token

```bash
export RUNNER_TOKEN="$(gh api --method POST \
  "repos/$GITHUB_ORG/$RUNNER_LAB_REPO/actions/runners/registration-token" \
  --jq '.token')"
test -n "$RUNNER_TOKEN"
```

Token 只存在当前 shell 中，不要执行 `echo "$RUNNER_TOKEN"`。

### Step 3：安装 Runner

```bash
cd runner-lab/codespaces
bash install-runner.sh
```

脚本会下载当前 Actions Runner 版本，并使用以下标签注册：

```text
training,codespace,ephemeral
```

### Step 4：启动 Runner

在第一个终端执行：

```bash
bash start-runner.sh
```

保持该终端运行。在第二个终端手动运行 `.github/workflows/05-self-hosted-runner.yml`。

### Step 5：验证

```bash
gh api \
  "repos/$GITHUB_ORG/$RUNNER_LAB_REPO/actions/runners" \
  --jq '.runners[] | {name,status,busy,labels:[.labels[].name]}'
```

确认 Job 输出包含：

```text
RUNNER_NAME
RUNNER_OS
RUNNER_ARCH
```

### Step 6：确认一次性清理

Job 成功后，Runner 应下线或被移除。执行：

```bash
bash cleanup-runner.sh
unset RUNNER_TOKEN
```

### 常见故障

| 现象 | 原因 | 处理 |
|---|---|---|
| Job 一直 Queued | Label 不匹配 | 对照 `runs-on` 和 Runner labels |
| Runner Offline | `run.sh` 已停止 | 重新启动或重新注册 |
| 第二次 Job 无 Runner | `--ephemeral` 已执行一次 | 重新生成 Token 并注册 |
| Runner 在线但 Job 不执行 | Runner Group 不允许仓库 | 检查组织 Runner Group Allow List |

## 3. Docker Ephemeral Runner

### Step 1：检查 Docker

```bash
docker info
```

失败时停止，不要继续 Docker Runner 实验。

### Step 2：准备变量

```bash
export RUNNER_REPO_URL="https://github.com/YOUR_ORG/YOUR_REPO"
export RUNNER_TOKEN="短期 Registration Token"
```

### Step 3：构建并运行

```bash
cd runner-lab/docker
bash start-container.sh
```

容器参数包括：

- `--rm`
- `--ephemeral`
- `training,docker,ephemeral`

Token 只通过运行时环境变量传入，不会写入镜像。

### Step 4：验证生命周期

Job 执行期间：

```bash
docker ps
docker logs -f <container>
```

Job 完成后：

```bash
docker ps -a
unset RUNNER_TOKEN
```

预期没有长期运行的 Runner 容器。

## 4. Kubernetes ARC Runner Scale Set

### Step 1：检查集群

```bash
kubectl version --client
kubectl cluster-info
kubectl get nodes
helm version
```

### Step 2：创建独立 Namespace

```bash
kubectl create namespace arc-systems
kubectl create namespace arc-runners
```

不要使用 `default` 或生产 Namespace。

### Step 3：选择认证方式

培训快速演示可以使用短期 PAT；正式环境优先使用 GitHub App。两者都不得写入仓库。

### Step 4：安装 ARC Controller

安装前必须根据当前官方 ARC 文档确认 Helm Chart 版本和参数。安装后检查：

```bash
kubectl get pods -n arc-systems
kubectl get crd | grep -i runner
```

### Step 5：创建 Runner Scale Set

参考 `runner-lab/kubernetes/scale-set-values.yaml`，使用：

```text
runnerScaleSetName: training-arc
minRunners: 0
maxRunners: 3
```

配置的 GitHub 组织/仓库、Runner Group 和认证 Secret 必须是培训专用资源。

### Step 6：运行一个 Job

Workflow 使用：

```yaml
runs-on: training-arc
```

观察：

```bash
kubectl get pods -n arc-runners -w
```

预期：

```text
无 Pod → 创建 Runner Pod → 执行 Job → Pod 删除
```

### Step 7：验证并发扩容

同时运行三个 Job，观察 Pod 数量从 0 增加到最多 3。达到 `maxRunners` 后，额外 Job 应排队。

### Step 8：故障排查

Label 或 Scale Set 名称错误：

```bash
kubectl get pods -n arc-runners
gh run list --repo "$GITHUB_ORG/$RUNNER_LAB_REPO"
```

镜像拉取失败：

```bash
kubectl describe pod -n arc-runners <pod>
kubectl get events -n arc-runners --sort-by=.lastTimestamp
```

资源不足：

```bash
kubectl describe node
kubectl describe pod -n arc-runners <pod>
```

### Step 9：清理

按顺序执行：

1. 停止 Workflow。
2. 删除 Runner Scale Set。
3. 确认 Runner Pod 已删除。
4. 删除 `arc-runners`。
5. 删除 `arc-systems`。
6. 删除培训 Runner Group。
7. 撤销短期 PAT 或卸载 GitHub App。
