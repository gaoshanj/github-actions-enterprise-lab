# Lab architecture

The same order-service application is used by all workflows. Hosted Runner workflows are safe to run immediately after the repository is created. Self-hosted workflows are manual and require an intentionally registered disposable runner.

The Kubernetes path uses ARC Runner Scale Sets conceptually:

```text
GitHub Actions service -> Scale Set listener -> ephemeral Runner Pod -> one Job -> Pod cleanup
```

No long-lived runner, registration token, GitHub App private key, or cloud credential is stored in this repository.
