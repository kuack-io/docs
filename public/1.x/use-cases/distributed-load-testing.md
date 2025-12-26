# Use case: distributed load testing

Load testing from a single region or a small pool of servers often fails to capture real-world behaviour. Kuack enables you to generate traffic from many real browsers, running on real networks.

## Problem

Traditional load testing tools:

- Run from data centres with predictable, low-latency connectivity.
- Miss the impact of residential networks, mobile carriers and flaky Wi-Fi.
- Can become expensive at high scale.

## How Kuack helps

With Kuack you can:

- Attach a lightweight Agent to a site with many visitors.
- Schedule a test workload as a Kubernetes job that runs in their browsers.
- Observe how your APIs behave under realistic, globally distributed traffic.

The same test container can still run on regular nodes, so you can mix browser-backed and server-backed capacity.

## Caveats

- Users must explicitly or implicitly consent to this kind of activity according to your policies.
- You should limit the intensity and duration of tests to avoid harming user experience.
- Sensitive test data should be anonymised or synthetic before it reaches the browser.
