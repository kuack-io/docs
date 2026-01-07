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
- **Run existing containers without rewriting** - Thanks to container2wasm, leverage your existing containerized applications in browsers.

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

## Running existing containers without rewriting code

One of Kuack's most powerful features is its integration with **[container2wasm](https://github.com/container2wasm/container2wasm)**, which enables you to run existing Linux containers in browsers **without rewriting a single line of code**. Check out the [Container2Wasm Integration](use-cases/existing-containers.md) guide to learn more.

### The challenge

Traditionally, running applications in browsers required:

- Rewriting code to compile to WebAssembly
- Adapting to browser constraints (no file system, limited networking)
- Maintaining separate codebases for browser and server deployments

### The solution: container2wasm

container2wasm converts standard Linux containers (x86_64, riscv64, or AArch64) into WebAssembly modules that can run in browsers. It uses CPU emulation (Bochs for x86_64, TinyEMU for riscv64, or QEMU) to run a full Linux kernel and container runtime inside the browser's WebAssembly sandbox.

This enables you to:

- **Run compatible containerized applications** - Many Python scripts, Node.js apps, and compiled binaries can run without code changes
- **No code changes required** - For compatible applications, your existing Docker images work as-is
- **Linux environment** - Access to standard Linux tools, libraries, and system calls (within browser constraints)
- **Seamless integration** - Works alongside natively compiled WASM workloads in the same Kuack cluster

### Important limitations

**Not all containers can run in browsers.** container2wasm has strict limitations due to browser sandbox constraints:

- **Architecture requirements** - Only x86_64, riscv64, or AArch64 containers are supported
- **Networking constraints** - No raw TCP/UDP sockets; networking is limited to HTTP(S) via `fetch` and WebSockets
- **File system** - Virtualized file system only; no direct host file system access
- **Process management** - No `fork()` or `exec()`; single-process workloads only
- **Performance overhead** - CPU emulation adds significant overhead compared to native execution
- **Memory limits** - Subject to browser memory constraints (typically 2-4GB per tab)
- **Long-running processes** - Not suitable for daemons or long-lived services
- **GPU access** - Limited or unavailable depending on browser support
- **Threading** - Limited threading support; `SharedArrayBuffer` requires specific browser configurations

Containers that require raw network access, multiple processes, direct hardware access, or long-running daemons will not work with container2wasm.

### How it works with Kuack

1. Convert your container image to WASM using `c2w` (the container2wasm CLI)
2. Push the converted WASM image to your container registry
3. Schedule it as a Kubernetes Pod targeting the Kuack node
4. Kuack executes it in connected browsers, just like any other workload

This dramatically expands what you can run on Kuack, making it practical to leverage browser compute for a much wider range of existing applications and tools.

## What you can build with it

Kuack is designed for:

- Short-lived, stateless, CPU-heavy jobs that can run in parallel.
- Workloads where running in the browser adds value, such as:
  - Load testing from real networks.
  - Local preprocessing and anonymisation of user data.
  - Media and document processing before upload.
- **Compatible containerized applications** - Thanks to container2wasm, you can run many Python, Node.js, Rust, Go, and other applications without rewriting them, subject to browser and container2wasm limitations.

The following pages describe when to use Kuack, how the architecture works, and what constraints you should be aware of.
