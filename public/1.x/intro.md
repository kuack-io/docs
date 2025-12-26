# What is Kuack?

Kuack extends a Kubernetes cluster with a **virtual node** whose capacity comes from end-user browsers.

When visitors open a page that includes the Kuack Agent, their browsers connect to your cluster, report available CPU and memory, and become ephemeral workers for WebAssembly workloads scheduled by Kubernetes.

From the cluster's point of view, Kuack is just another node. From the browser's point of view, it is a background worker running inside the existing sandbox.

## Why it exists

For some workloads, the limiting factor is not how much cloud you can buy, but how much you want to spend, how close you can get to end-users, or how much sensitive data you are willing to ship to your backend.

Kuack explores a different trade-off:

- Use **idle client resources** instead of provisioning more servers.
- Run code **next to the user and their data** when that is beneficial.
- Stay **Kubernetes-native**, using familiar tooling and OCI images.

It is not a general replacement for your existing nodes. It is an extra compute plane that you can opt into where it makes sense.

## How it fits into Kubernetes

Kuack Node implements the Virtual Kubelet interface and registers a single synthetic node in your cluster. That node:

- Reports capacity based on connected browsers.
- Advertises labels and taints so only explicitly targeted Pods land on it.
- Streams logs back so `kubectl logs` works as expected.

Kuack Agent runs in the browser and:

- Connects to Kuack Node over WebSocket.
- Reports approximate CPU, memory and optional GPU capability.
- Downloads wasm workloads via a registry proxy and executes them in the browser.

Kubernetes still decides **which** Pods are assigned to the Kuack node. Kuack then decides **which browser** actually runs each Pod.

## What you can build with it

Kuack is designed for:

- Short-lived, stateless, CPU-heavy jobs that can run in parallel.
- Workloads where running in the browser adds value, such as:
  - Load testing from real networks.
  - Local preprocessing and anonymisation of user data.
  - Media and document processing before upload.

The following pages describe when to use Kuack, how the architecture works, and what constraints you should be aware of.
