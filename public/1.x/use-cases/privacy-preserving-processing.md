# Use case: privacy-preserving processing

Many applications handle sensitive data that ideally should never leave the user's device in raw form. Kuack makes it easier to run Kubernetes-scheduled workloads directly in the browser, next to that data.

## Problem

Centralising all processing in your backend can:

- Increase regulatory and compliance burden.
- Require heavy data anonymisation pipelines.
- Make it harder to give users strong privacy guarantees.

## How Kuack helps

By pushing certain computations into the browser you can:

- Process raw data locally and send only derived, aggregated or anonymised results.
- Keep personally identifiable or health-related data inside the user's device.
- Reuse your Kubernetes tooling and container images to orchestrate that work.

Kuack does not remove your privacy obligations, but it can reduce how much sensitive data your backend ever sees.

## Caveats

- You must still comply with applicable privacy regulations and obtain consent.
- Users can inspect the code that runs in their browser. **Do not** embed secrets.
- The browser environment is not suited for all ML workloads or large models yet.
