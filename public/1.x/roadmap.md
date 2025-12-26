# Roadmap

Kuack is evolving. This roadmap sketches the direction of the project rather than promising firm dates.

## Short term

- **Reliability improvements** - better handling of disconnections, clearer pod status reporting and safer retries.
- **Resource accounting** more accurate tracking of per-agent usage and safer enforcement of requested CPU and memory.
- **Documentation and examples** - more guides and example workloads to make it easier to get started.

## Medium term

- **GPU and WebGPU experiments** - exposing browser GPU capabilities where available, initially for non-critical workloads and experiments.
- **Wasm threads support** - taking advantage of wasm threads and `SharedArrayBuffer` where browsers permit them.
- **Richer scheduling signals** - using more information about agents (latency, stability, device class) to choose where to run a Pod.
- **Better observability** - improved metrics and debugging tools for understanding behaviour across many agents.

## Longer term

- **Networking and storage integrations** - mapping suitable Kubernetes abstractions (such as `emptyDir`-style storage) onto browser capabilities like the Origin Private File System.
- **Ecosystem integrations** - smoother interoperability with other wasm-on-Kubernetes projects and tools.
- **Managed service** - a hosted Kuack control plane that can connect your clusters to a larger pool of participating agents.
- **Language and framework SDKs** - helper libraries for common languages to make it easier to build Kuack-friendly workloads.

The exact order and scope of these items may change as real-world usage and feedback shape the project.
