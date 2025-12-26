# Workload model & images

Kuack does not invent a new packaging format. It builds on top of standard OCI (Docker) images and multi-architecture manifests.

This page explains how a workload needs to be built so that it can run both on regular Kubernetes nodes and inside Kuack browser agents.

## Multi-architecture OCI images

A Kuack-compatible workload is typically published as a **multi-architecture image**:

- `linux/amd64` and/or `linux/arm64` - for regular Kubernetes nodes.
- `wasm32` / WASI - for Kuack and other wasm runtimes.

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

If your job works as a containerised batch job and can be compiled to WASI, it is usually straightforward to make it Kuack-compatible.
