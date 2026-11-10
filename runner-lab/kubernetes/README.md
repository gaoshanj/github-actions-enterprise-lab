# Kubernetes ARC runner lab

This is the optional Kubernetes path. Use a disposable test cluster, separate namespaces, and a dedicated Runner Group. The recommended production authentication model is a GitHub App; a short-lived PAT is acceptable only for a controlled training exercise.

## Procedure

1. Verify `kubectl`, `helm`, and cluster access.
2. Create `arc-systems` and `arc-runners` namespaces.
3. Install the official ARC controller Helm chart.
4. Create a Runner Scale Set with `minRunners: 0` and a small `maxRunners`.
5. Point `runs-on` at the Scale Set name.
6. Run one job and watch the runner Pod appear and disappear.
7. Run three parallel jobs and observe scale-out.
8. Set an invalid label and diagnose the queued job.
9. Test image pull and resource scheduling failures.
10. Remove the Scale Set, namespaces, and temporary credentials.

Validate the current chart values against the official ARC documentation before every course delivery; chart options evolve.
