# When to use Kuack

Kuack is a specialised tool. It is powerful in the right situations and the wrong choice in others. This page helps you decide whether your workload is a good fit.

## Good fits

Kuack works best for workloads that are:

- **Stateless and idempotent** - a task can be retried on another browser without corrupting shared state.
- **Short-lived** - from a few milliseconds up to a handful of minutes, not hours or days.
- **CPU-bound with small inputs/outputs** - the computation dominates, and the data you send to and from the browser is relatively small.
- **Embarrassingly parallel** - many similar tasks that do not need to talk to each other.
- **Safe to run on untrusted machines** - nothing in the code or data would harm you if a user inspects it.

Examples include:

- API load generation from many real networks.
- Local preprocessing of files before upload.
- Lightweight analytics or scoring on data that already lives in the browser.
- **Compatible containerized applications** - Thanks to [container2wasm](https://github.com/container2wasm/container2wasm), you can run many Python scripts, Node.js applications, and compiled binaries without rewriting code, subject to browser and container2wasm limitations. See [Container2Wasm Integration](use-cases/existing-containers.md).

## Poor fits

Kuack is usually the wrong tool when workloads are:

- **Stateful** - require shared mutable state, locks or coordination between tasks.
- **Long-running daemons** - need stable processes that live for hours or expose long-lived services.
- **Latency-critical** - must respond in milliseconds with tight SLOs.
- **Network anchored to the cluster** - depend on pod-to-pod communication or internal-only services.
- **Data-heavy** - require transferring large datasets into or out of the browser.

You should not try to run databases, message brokers, or internal HTTP services on Kuack.

## How to think about Kuack

A useful mental model is:

> Kuack is a best-effort, browser-backed compute plane that can offload the right kind of work from your regular nodes.

It is not meant to replace your existing cluster. Instead, it gives you an extra option for where certain jobs can run - especially those that benefit from running close to end-users or from leveraging idle client resources.

### The container2wasm advantage

One of Kuack's key differentiators is its integration with [container2wasm](https://github.com/container2wasm/container2wasm), which can lower the barrier to entry for compatible workloads. Instead of requiring you to rewrite applications to compile to WebAssembly, container2wasm enables you to:

- **Run compatible containerized applications** - Many Python, Node.js, Rust, Go, and other Linux-based containerized applications can run in browsers without modification, if they fit within container2wasm's constraints
- **Leverage existing tooling** - Use the same Docker images, CI/CD pipelines, and deployment processes you already have (for compatible workloads)
- **Reduce development time** - No need to learn WebAssembly tooling or rewrite working code (for compatible applications)
- **Expand use cases** - Run applications that would be impractical to rewrite, such as complex scripts with many dependencies

**Important:** Not all containers can run with container2wasm. Applications requiring raw network sockets, multiple processes, long-running daemons, or direct hardware access will not work. Always test converted containers to verify compatibility.

This makes Kuack practical for a wider range of compatible workloads than would be feasible with native WebAssembly compilation alone, but it is not a universal solution for all containerized applications.
