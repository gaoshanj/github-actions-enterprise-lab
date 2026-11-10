# Docker ephemeral runner lab

This lab is optional when Docker is available in the Codespace. Build the runner image with `Dockerfile`, then run `bash start-container.sh`. The image contains the runner bootstrap logic but receives the registration token only at runtime. The container uses `--rm` and the runner uses `--ephemeral`; it must execute one job and disappear.

The image must never contain a token, cloud credential, or production configuration.

The workflow must use:

```yaml
runs-on: [self-hosted, linux, x64, training, docker, ephemeral]
```
