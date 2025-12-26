# Browser runtime & limits

Running code in a user's browser is very different from running a container on a Linux node. Kuack hides some of the details, but the underlying constraints still matter.

This page summarises what your workloads can and cannot do in the browser.

## Security sandbox

Browsers execute code inside a strict sandbox that isolates pages from the host operating system. As a result, your WebAssembly workloads **cannot**:

- **Access the host file system** - paths like `/etc/passwd` or `/var/log` do not exist, only virtualised storage via browser APIs (IndexedDB, Origin Private File System) is available.
- **Open raw sockets** - no arbitrary TCP/UDP, networking goes through HTTP(S) (`fetch`) and WebSockets.
- **Spawn processes** - there is no `fork` or `exec`.

These constraints are a strength from a safety perspective, but they also narrow the class of workloads that make sense to run on Kuack.

## WASI bridge

Kuack uses WASI (WebAssembly System Interface) as the contract between your code and the environment.

When your workload writes to `stdout` or `stderr`, Kuack captures that output and streams it back over the WebSocket to Kuack Node, which then exposes it via the kubelet logs API.

Many filesystem and networking calls are stubbed or mapped onto browser capabilities. You should treat the environment as **minimal** compared to a full Linux userland.

## Networking

Because browsers usually sit behind NATs and firewalls, pod-to-pod communication is effectively one-way:

- **Inbound:** A browser cannot accept inbound TCP connections. You cannot expose a service and have other Pods call it directly.
- **Outbound:** Outbound HTTP(S) requests are subject to CORS and other browser policies. Any external API you call must explicitly allow browser-origin requests.

Kuack is therefore not suitable for workloads that rely on being part of the cluster's internal network.

## Ephemerality

Browser tabs are fragile:

- Users can close or refresh them at any time.
- Laptops can sleep, move between networks or lose connectivity.
- Mobile browsers may throttle or suspend background tabs.

Design Kuack workloads so that they are:

- **Stateless and idempotent** - safe to retry.
- **Short-lived** - complete in a bounded amount of time.
- **Resilient** - upstream controllers (Jobs, Deployments) can reschedule when an agent disappears.

## Performance

Modern WebAssembly engines are fast, but there are still limits:

- **Memory** - browsers cap per-tab memory, often in the 2-4 GB range or lower on constrained devices.
- **CPU** - heavy work can compete with the page's own UI and other tabs. Kuack uses workers, but total CPU is still shared.
- **Threads** - wasm threads and `SharedArrayBuffer` are available only under certain conditions and are not yet universally enabled.

In practice, Kuack works best when you keep individual tasks modest in size and rely on parallelism across many agents rather than pushing a single browser to its limits.
