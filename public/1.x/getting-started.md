# Quickstart: run your first browser pod

This guide walks through installing Kuack into a cluster and running a simple workload that executes in your browser.

The commands below are intentionally minimal and focus on the happy path.

## Prerequisites

- A Kubernetes cluster (local `kind`, `minikube` or a managed cluster).
- `kubectl` and `helm` installed.

Note: logs streaming will not work in k3s clusters, because its implementation for konnectivity is non-standard. Support for k3s will be added in later releases. For now, please use in minikube, kind, EKS, GKE or other non-rancher clusters

## 1. Install Kuack via Helm

Install the chart directly from the OCI registry:

```bash
helm install kuack oci://ghcr.io/kuack-io/charts/kuack
```

This deploys:

- **Kuack Node**: Registers as a virtual node in your cluster.
- **Kuack Agent**: The server that browser agents connect to.

Verify that the virtual node is registered:

```bash
kubectl get nodes
```

You should see a node named `kuack-node` (or similar) in the list.

## 2. Connect a browser agent

For local testing, you need to expose both the Node service (for the API) and the Agent service (for the UI) to your local machine.

1. **Forward the Node service (API):**

   ```bash
   kubectl port-forward service/kuack-node 8081:8080
   ```

2. **Forward the Agent service (UI):**

   ```bash
   kubectl port-forward service/kuack-agent 8080:8080
   ```

3. **Connect:**

   Open `http://localhost:8080` in your browser. You should see the Kuack Agent interface.

   In the connection settings, point the agent to the Node service address:
   `ws://127.0.0.1:8081`

   (You can use the default token value if prompted).

## 3. Run the example checker workload

The **checker** image is a small Rust application compiled to both native and WASM. It performs simple checks and prints results.

Create a file named `checker.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: checker
spec:
  nodeSelector:
    kuack.io/node-type: kuack-node
  tolerations:
    - key: "kuack.io/provider"
      operator: "Equal"
      value: "kuack"
      effect: "NoSchedule"
  containers:
    - name: checker
      image: ghcr.io/kuack-io/checker:latest
```

Apply the manifest:

```bash
kubectl apply -f checker.yaml
```

Watch the logs:

```bash
kubectl logs -f checker
```

You should see output coming from the checker workload running inside your browser tab.

## 4. Where to go next

- Read [When to use Kuack](/docs/when-to-use) to check whether your own workloads are a good fit.
- Explore [Browser runtime & limits](/docs/browser-runtime) before designing production workloads.
- Look at the example checker repository to see how a multi-arch, Kuack-compatible image is built.
