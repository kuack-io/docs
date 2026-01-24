# Roadmap

Kuack is evolving. This roadmap sketches the direction of the project rather than promising firm dates.

## Focus Areas

We have ambitious plans to take Kuack from prototype to production-grade:

- **Registry Separation**: Extracting the internal registry into a standalone, scalable service (currently in-memory).
- **Distributed Nodes**: Moving from a single-node architecture to a horizontally scalable, distributed system (likely using Redis for coordination).
- **Persistence**: Implementing caching layer for WASM binaries and logs (currently in-memory).
- **Log Collection**: Adding sidecar support to run reliable log collectors like Fluentbit or Promtail on the virtual node.
- **High Concurrency**: Optimizing for millions of concurrent agent connections.

## Short term

- **Reliability improvements** - better handling of disconnections, clearer pod status reporting and safer retries.
- **Resource accounting** more accurate tracking of per-agent usage and safer enforcement of requested CPU and memory.
- **Documentation and examples** - more guides and example workloads to make it easier to get started.

## Medium term

- **GPU and WebGPU experiments** - exposing browser GPU capabilities where available, initially for non-critical workloads and experiments.
- **Wasm threads support** - taking advantage of wasm threads and `SharedArrayBuffer` where browsers permit them.
- **Richer scheduling signals** - using more information about agents (latency, stability, device class) to choose where to run a Pod.
- **Better observability** - improved metrics and debugging tools for understanding behaviour across many agents.
