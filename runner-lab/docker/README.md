# Docker ephemeral runner lab

This lab is optional when Docker is available in the Codespace. Build a runner image that contains the runner software but injects the registration token only at runtime. Start it with `--rm` and `--ephemeral`; the container must execute one job and disappear.

The image must never contain a token, cloud credential, or production configuration.
