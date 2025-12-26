# Scheduling & capacity

Kuack integrates with Kubernetes scheduling through a **virtual node** implemented via Virtual Kubelet.

This page explains how capacity is reported, how Pods end up on Kuack, and what happens when browsers appear or disappear.

## The virtual node

Kuack Node registers itself as a Kubernetes node with:

- An architecture like `wasm32`.
- A custom provider label and taint so that only opted-in workloads land there.
- Capacity and allocatable values based on connected browser agents.

From the scheduler's perspective, it is just another node with CPU and memory resources.

## Aggregating browser capacity

Each connected browser agent:

- Reports an approximate number of CPU cores.
- Reports an approximate memory budget.
- Optionally reports GPU capability when the browser exposes it.

Kuack Node aggregates these reports into a total capacity for the virtual node. As agents connect or disconnect, this capacity goes up and down.

## Pod placement

When you submit a Pod that can run on Kuack:

- It must tolerate the Kuack taint and/or select the Kuack node via labels.
- The scheduler may assign it to the virtual node if there is enough capacity.
- Kuack Node then selects a specific agent that has sufficient free resources for that Pod's requests.

Today, selection is intentionally simple: any agent with enough free CPU and memory is acceptable. Future versions may use richer signals such as latency, stability or historical reliability.

## Failure and rescheduling

Browsers are ephemeral. When an agent disconnects:

- Kuack marks all Pods on that agent as failed with a `NodeLost`-style reason.
- Kubernetes controllers (Jobs, Deployments, etc.) are responsible for rescheduling if desired.

This means Kuack provides **best-effort** capacity. You should design workloads so they can be retried elsewhere if a browser disappears.
