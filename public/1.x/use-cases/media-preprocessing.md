# Use case: media & file preprocessing

Uploading large files can be slow and expensive. Preprocessing them in the browser before upload can save bandwidth and storage.

## Problem

Backends often handle tasks such as:

- Image resizing and optimisation.
- Video transcoding to different bitrates.
- Compression or encryption of large files.

These workloads are CPU-intensive and scale with user activity.

## How Kuack helps

With Kuack you can:

- Schedule preprocessing jobs as Kubernetes Pods that execute in users' browsers.
- Reduce the amount of data that needs to cross the network.
- Offload bursts of CPU work from your cluster to clients, while keeping the logic in familiar container images.

## Caveats

- Heavy processing may affect device responsiveness, battery life and thermals.
- Network conditions still matter. Users on slow connections may not benefit from aggressive preprocessing.
- You should give users visibility and control over such background work.
