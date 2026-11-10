# Docker ephemeral runner lab / Docker 临时 Runner 实验

中文详细步骤：[`../../docs/runner-guide.zh-CN.md`](../../docs/runner-guide.zh-CN.md)

Detailed English steps: [`../../docs/runner-guide.en-US.md`](../../docs/runner-guide.en-US.md)

This lab is optional when Docker is available in the Codespace. Build the runner image with `Dockerfile`, then run `bash start-container.sh`. The image contains the runner bootstrap logic but receives the registration token only at runtime. The container uses `--rm` and the runner uses `--ephemeral`; it must execute one job and disappear.

如果 Codespace 中 Docker 不可用，请跳过本实验。Token 只能在运行时注入。
If Docker is unavailable in the Codespace, skip this lab. The token must be injected only at runtime.

The image must never contain a token, cloud credential, or production configuration.

The workflow must use:

```yaml
runs-on: [self-hosted, linux, x64, training, docker, ephemeral]
```
