# Running Standard Containers

Kuack allows you to run standard OCI containers (like Ubuntu, Python, Node.js and others) in the browser, thanks to our integration with [container2wasm](https://github.com/ktock/container2wasm).

This means you can take an existing Docker image built for `linux/amd64`, convert it to WASM, and deploy it to a Kuack Node (browser) just like any other Pod.

## How it works

The `container2wasm` project takes a container filesystem and runs it inside a virtualized environment on top of WASM (using a VMM like Bochs, but compiled to WASM). This allows unmodified binaries to run, albeit with some performance overhead compared to native WASM.

## Ready-to-use Examples

We maintain a set of popular images that are already converted and ready to use in our [c2w-examples](https://github.com/kuack-io/c2w-examples) repository.

### Python

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: python-c2w
spec:
  nodeSelector:
    kuack.io/node-type: kuack-node
  tolerations:
    - key: "kuack.io/provider"
      operator: "Equal"
      value: "kuack"
      effect: "NoSchedule"
  containers:
    - name: python
      image: ghcr.io/kuack-io/c2w-examples/python:3.14-alpine
      command: ["python3", "-c", "print('Hello from Python in the Browser!')"]
```

### Node.js

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: node-c2w
spec:
  nodeSelector:
    kuack.io/node-type: kuack-node
  tolerations:
    - key: "kuack.io/provider"
      operator: "Equal"
      value: "kuack"
      effect: "NoSchedule"
  containers:
    - name: node
      image: ghcr.io/kuack-io/c2w-examples/node:24-alpine
      command: ["node", "-e", "console.log('Hello from Node.js in the Browser!')"]
```

### Ubuntu

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-c2w
spec:
  nodeSelector:
    kuack.io/node-type: kuack-node
  tolerations:
    - key: "kuack.io/provider"
      operator: "Equal"
      value: "kuack"
      effect: "NoSchedule"
  containers:
    - name: ubuntu
      image: ghcr.io/kuack-io/c2w-examples/ubuntu:24.04
      command: ["/bin/bash", "-c", "cat /etc/os-release"]
```

## Creating Custom Images

To convert your own images, you can use the `c2w` CLI tool or our GitHub Actions helper.
See [c2w-examples](https://github.com/kuack-io/c2w-examples) for the build pipeline reference.

## Limitations

While powerful, running full containers in the browser has constraints:

1. **Performance**: Emulation is slower than native execution.
2. **Networking**: Outbound network access is restricted by the browser sandbox (no raw sockets, limited WebSocket usage depending on the implementation).
3. **Environment Variables**: The total size of environment variables passed to the container is limited to **1024 bytes** (IOV_MAX limitation in the WASI runtime). If your env vars exceed this, the container may fail to start or truncate them.
