# Use case: edge computing

Use Kuack for edge computing scenarios that benefit from geographic distribution.

## What is Edge Computing?

Edge computing processes data closer to users, reducing latency and bandwidth usage.

### Traditional Model

```text
User -> Internet -> Data Center -> Process -> Response
```

High latency, high bandwidth usage.

### Edge Model

```text
User -> Browser -> Process -> Response
```

Low latency, minimal bandwidth usage.

## Use Cases

### Data Preprocessing

Process data before sending to servers.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: data-preprocessor
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
  containers:
    - name: preprocessor
      image: ghcr.io/example/preprocessor:latest
      env:
        - name: INPUT_DATA
          value: "..." # Large JSON/CSV
        - name: OUTPUT_FORMAT
          value: "parquet"
```

Benefits:

- **Reduced bandwidth**: Send processed data, not raw
- **Lower latency**: Process locally
- **Privacy**: Data doesn't leave device

### Image Processing

Process images before upload.

Benefits:

- **Server offload**: Reduce server CPU usage
- **Faster uploads**: Smaller files upload faster
- **Cost savings**: Less storage and bandwidth

For implementation details, see [Media & file preprocessing](media-preprocessing.md).

### Validation

Validate data before submission.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: validator
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
  containers:
    - name: validator
      image: ghcr.io/example/validator:latest
      env:
        - name: SCHEMA
          value: "..." # JSON schema
        - name: DATA
          value: "..." # Data to validate
```

Benefits:

- **Instant feedback**: Validate before upload
- **Server offload**: Reduce server validation load
- **Better UX**: Faster error detection

## Advantages

### Low Latency

Process data locally:

- **No network round-trip**: Process in browser
- **Faster response**: Immediate results
- **Better UX**: Responsive applications

### Bandwidth Savings

Send processed data:

- **Smaller payloads**: Compressed/processed data
- **Reduced costs**: Less bandwidth usage
- **Faster transfers**: Smaller files transfer faster

### Privacy

Keep data local:

- **No data transfer**: Process on device
- **GDPR friendly**: Data doesn't leave device
- **User trust**: Better privacy guarantees
