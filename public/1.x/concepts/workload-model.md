# Workload model & images

Kuack does not invent a new packaging format. It builds on top of standard OCI (Docker) images and multi-architecture manifests.

This page explains how a workload needs to be built so that it can run both on regular Kubernetes nodes and inside Kuack browser agents.

## Two paths to browser execution

Kuack supports two approaches for running workloads in browsers:

1. **Native WebAssembly** - Applications compiled directly to WASI/WebAssembly (fastest, most efficient)
2. **Container-to-WASM conversion** - Existing Linux containers converted using [container2wasm](https://github.com/container2wasm/container2wasm) (no code changes required)

Both approaches use the same OCI image format and work seamlessly with Kubernetes scheduling.

## Running existing containers with container2wasm

**[container2wasm](https://github.com/container2wasm/container2wasm)** is a tool that converts compatible Linux containers into WebAssembly modules. For compatible applications, this enables you to run existing containerized applications in browsers **without rewriting code**, though with important limitations.

### How it works

container2wasm uses CPU emulation to run a full Linux kernel and container runtime inside the browser's WebAssembly sandbox:

- **x86_64 containers** → Emulated with Bochs
- **riscv64 containers** → Emulated with TinyEMU
- **AArch64 containers** → Emulated with QEMU

The converted container runs with:

- Full Linux environment (kernel, system calls, standard libraries)
- Container runtime (runc) for proper isolation
- Access to standard Linux tools and utilities

### Converting a container

```bash
# Convert a container image to WASM
c2w ubuntu:22.04 out.wasm

# Or for a specific architecture
c2w --target-arch=riscv64 riscv64/ubuntu:22.04 out.wasm
```

The output is a WASM file that can be packaged as an OCI image and pushed to your registry, just like any other container image.

### Benefits

- **Zero code changes** - For compatible applications, your existing Python, Node.js, Rust, Go, or other containerized applications work as-is
- **Linux compatibility** - Access to standard Linux tools, libraries, and system calls (within browser constraints)
- **Expanded application support** - Run many Linux applications that work in containers, without needing to rewrite them
- **Seamless integration** - Works alongside natively compiled WASM workloads in the same cluster

### Limitations and constraints

**Not all containers can be converted or will run successfully.** container2wasm has strict limitations:

- **Architecture support** - Only x86_64, riscv64, or AArch64 containers are supported
- **Networking** - No raw TCP/UDP sockets; only HTTP(S) via `fetch` and WebSockets are available
- **File system** - Virtualized file system only; no direct host file system access
- **Process model** - Single-process workloads only; no `fork()` or `exec()`
- **Performance** - CPU emulation adds significant overhead (often 10-100x slower than native)
- **Memory** - Subject to browser memory limits (typically 2-4GB per tab)
- **Long-running processes** - Not suitable for daemons, servers, or long-lived services
- **GPU/Threading** - Limited GPU access and threading support
- **System calls** - Some Linux system calls may not be available or may behave differently

**What works well:**

- Command-line tools and batch jobs
- Scripts that process data (Python, Node.js, shell scripts)
- Single-process applications with simple I/O
- Short-lived, stateless workloads

**What won't work:**

- Applications requiring raw network sockets
- Multi-process applications or daemons
- Long-running services or servers
- Applications with heavy hardware dependencies
- Real-time or latency-critical workloads

### Performance considerations

Container2wasm workloads use CPU emulation, which adds significant overhead compared to natively compiled WASM or native execution. For best performance, prefer native WASM compilation when possible. However, container2wasm is useful when:

- You have compatible containerized applications you want to run in browsers
- The application is complex and rewriting would be time-consuming
- You need access to Linux-specific tools or libraries
- Development speed is more important than maximum performance
- The workload fits within container2wasm's constraints

## Multi-architecture OCI images

A Kuack-compatible workload is typically published as a **multi-architecture image**:

- `linux/amd64` and/or `linux/arm64` - for regular Kubernetes nodes.
- `wasm32` / WASI - for Kuack and other wasm runtimes (either natively compiled or container2wasm-converted).

From Kubernetes' point of view this is just another image. When a Pod is scheduled to a regular node, the usual Linux image is pulled. When it lands on the Kuack virtual node, the Node component uses the wasm variant.

## Expected layout for wasm workloads

Kuack assumes your wasm artefacts follow the conventions used by `wasm-pack` and `wasm-bindgen`:

- A directory (often called `pkg/`) contains:
  - A WebAssembly module, for example `my_app_bg.wasm`.
  - A JavaScript glue file, for example `my_app.js`, that bootstraps the module.
  - A `package.json` describing the bundle.

Inside the cluster, Kuack Node:

1. Pulls the image from your registry.
2. Selects the wasm layer from the multi-arch manifest.
3. Locates the `pkg/` artefacts.
4. Exposes the wasm file and JS glue via a simple HTTP registry proxy.

In the browser, Kuack Agent:

1. Downloads the wasm and its JS glue from the Node's registry proxy.
2. Dynamically imports the JS module.
3. Instantiates the wasm module and calls the exported entrypoint.

## Workload expectations

When designing a workload for Kuack, keep these expectations in mind:

- **Single container per Pod** - today Kuack executes only the first container of the Pod.
- **No sidecars or init containers** - they are ignored in the browser runtime.
- **Stdout/stderr as primary interface** - logs and simple results should be written to standard output.
- **Configuration via env and arguments** - use container args and environment variables, as you would for a regular job.

If your job works as a containerised batch job, you have two options:

1. **Compile to WASI** - For best performance, compile your application natively to WebAssembly/WASI
2. **Use container2wasm** - Convert your compatible container image to WASM without code changes (subject to container2wasm limitations)

Both approaches are supported, but container2wasm is only suitable for workloads that fit within its constraints. Always test converted containers to ensure they work correctly in the browser environment.
