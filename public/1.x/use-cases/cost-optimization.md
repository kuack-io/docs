# Use case: cost optimization

Use Kuack to reduce cloud infrastructure costs by leveraging browser resources.

## Problem

Cloud infrastructure is expensive:

- **Compute**: You pay for every CPU cycle.
- **Scaling**: Handling peak loads requires provisioning extra servers.
- **Idle capacity**: You often pay for reserved instances that aren't fully utilized.

## How Kuack helps

- **Free Resources**: Utilize idle CPU and memory on user devices.
- **Burst Capacity**: Handle traffic spikes without provisioning new servers.
- **Zero Infrastructure**: No need to manage or pay for the underlying hardware.

## Scenarios

### Baseline + Burst

Keep a small baseline of servers for steady traffic and burst into browsers during peak load.

```text
Baseline: 10 servers @ $100/month = $1,000/month
Peak: Browser resources (free)
Total: $1,000/month
Savings: 67% (vs scaling to 30 servers)
```

### Load Testing

Run distributed load tests using existing browser connections instead of paying for dedicated load testing services.

### Image Processing

Offload image resizing and compression to client devices to save server CPU and bandwidth.

## Implementation

### Hybrid Orchestration

Use browsers when available, servers when needed:

```yaml
spec:
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
        - weight: 100
          preference:
            matchExpressions:
              - key: kuack.io/node-type
                operator: In
                values: ["kuack-node"]
```

### Batch Processing

Process large batches using browser resources:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: batch-processor
spec:
  completions: 10000
  parallelism: 100
  template:
    spec:
      affinity:
        nodeAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 100
              preference:
                matchExpressions:
                  - key: kuack.io/node-type
                    operator: In
                    values: ["kuack-node"]
```

## Caveats

- **Availability**: Browser resources are best-effort and ephemeral.
- **Workload suitability**: Must be WASM-compatible, stateless, and short-lived.
- **Reliability**: Fallback strategies are essential for critical workloads.
