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
