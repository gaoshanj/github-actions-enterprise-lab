# Kubernetes ARC runner lab / Kubernetes ARC Runner 实验

中文详细步骤：[`../../docs/runner-guide.zh-CN.md`](../../docs/runner-guide.zh-CN.md)

Detailed English steps: [`../../docs/runner-guide.en-US.md`](../../docs/runner-guide.en-US.md)

This is the optional Kubernetes path. Use a disposable test cluster, separate namespaces, and a dedicated Runner Group. The recommended production authentication model is a GitHub App; a short-lived PAT is acceptable only for a controlled training exercise.

这是可选的 Kubernetes 路径。请使用独立测试集群、独立 Namespace 和专用 Runner Group。正式环境优先使用 GitHub App；短期 PAT 只用于受控培训演示。

Validate the current chart values against the official ARC documentation before every course delivery; chart options evolve.
每次交付课程前，都要根据官方 ARC 文档重新确认 Helm Chart 参数，因为配置选项可能变化。
