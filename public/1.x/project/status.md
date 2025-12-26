# Project status

Kuack is an early-stage project and should be treated as experimental.

## Maturity

Today, Kuack provides:

- A working Virtual Kubelet provider that registers a virtual node.
- A browser Agent that can connect, report resources and execute wasm workloads.
- A registry proxy that extracts wasm artefacts from multi-arch images.
- Log streaming so you can use `kubectl logs` with browser-executed Pods.

It is suitable for experimentation, prototypes and non-critical workloads. It is **not** yet a drop-in component for strict production SLAs.

## Known limitations

- Best-effort capacity only: browsers can disconnect at any time.
- One container per Pod is executed in the browser today.
- No persistent storage integration beyond what browsers provide.
- Limited observability and multi-tenant isolation.

These are active areas of design and development.

## Where to go next

- Read the [Roadmap](/docs/1.x/roadmap.md) for planned features.
- Explore the component repositories for implementation details.
- Join the project via issues and discussions in GitHub.
