# Use case: running existing data transformation scripts

Many organizations have existing containerized scripts for data processing, transformation, validation, and ETL operations. With container2wasm and Kuack, you can run these scripts in browsers without rewriting a single line of code.

## Problem

Organizations often have:

- **Legacy data processing scripts** - Python, Node.js, or shell scripts that transform, validate, or process data
- **ETL pipelines** - Extract, transform, and load operations that run as batch jobs
- **Data validation tools** - Scripts that verify data quality, format, or schema compliance
- **File conversion utilities** - Tools that convert between formats (CSV to JSON, XML to Parquet, etc.)

These scripts are typically:

- Already containerized and working in production
- CPU-intensive but short-lived
- Single-process, stateless operations
- Perfect candidates for browser execution, but rewriting them to WebAssembly would be time-consuming

## How Kuack helps

With container2wasm integration, Kuack enables you to:

- **Run existing scripts without modification** - Convert your containerized Python, Node.js, or other scripts to WASM and execute them in browsers
- **Process data closer to the source** - Transform or validate data in the user's browser before it reaches your servers
- **Reduce server load** - Offload CPU-intensive transformation work to client browsers
- **Maintain existing tooling** - Use the same Docker images, CI/CD pipelines, and deployment processes

### Example: CSV to JSON conversion

You have an existing Python script that converts CSV files to JSON:

```python
# csv_to_json.py
import csv
import json
import sys

def convert_csv_to_json(input_file, output_file):
    with open(input_file, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        data = list(reader)

    with open(output_file, 'w') as jsonfile:
        json.dump(data, jsonfile, indent=2)

if __name__ == '__main__':
    convert_csv_to_json(sys.argv[1], sys.argv[2])
```

#### Step 1: Containerize (if not already done)

```dockerfile
FROM python:3.14-slim
COPY csv_to_json.py /app/
WORKDIR /app
ENTRYPOINT ["python", "csv_to_json.py"]
```

#### Step 2: Convert to WASM

```bash
# Build and tag your container
docker build -t my-registry/csv-converter:latest .

# Convert to WASM using container2wasm
c2w my-registry/csv-converter:latest csv-converter.wasm

# Push the WASM image to your registry
# (package the .wasm file as an OCI image)
```

#### Step 3: Run on Kuack

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: csv-converter
spec:
  nodeSelector:
    kuack.io/node-type: kuack-node
  tolerations:
    - key: "kuack.io/provider"
      operator: "Equal"
      value: "kuack"
      effect: "NoSchedule"
  containers:
    - name: converter
      image: my-registry/csv-converter:latest
      args: ["/input/data.csv", "/output/data.json"]
      env:
        - name: INPUT_DIR
          value: "/mnt/input"
        - name: OUTPUT_DIR
          value: "/mnt/output"
```

The script runs in the user's browser, processing the CSV file locally and producing JSON output without sending raw data to your servers.

## Real-world advantages

### 1. Zero code changes

Your existing scripts work as-is. No need to:

- Learn WebAssembly tooling
- Rewrite working code
- Maintain separate browser/server codebases
- Modify your CI/CD pipelines

### 2. Process data locally

- **Privacy** - Sensitive data never leaves the user's device
- **Bandwidth savings** - Send processed/transformed data instead of raw files
- **Faster processing** - No network latency for data transfer
- **Cost reduction** - Less server CPU and bandwidth usage

### 3. Leverage existing investments

- Reuse your existing containerized scripts
- Maintain your current development workflows
- Keep using familiar tools and languages
- No need to retrain your team

## What works well

Container2wasm is ideal for scripts that:

- ✅ Process files or data (CSV, JSON, XML, etc.)
- ✅ Perform transformations or validations
- ✅ Run as single-process, short-lived jobs
- ✅ Use standard libraries (no special hardware requirements)
- ✅ Output results to stdout or files
- ✅ Are already containerized and working

## Limitations to consider

Not all scripts will work. Container2wasm has constraints:

- ❌ **No raw network sockets** - Scripts that need direct TCP/UDP connections won't work
- ❌ **Single process only** - Multi-process scripts or daemons won't work
- ❌ **Performance overhead** - CPU emulation adds 10-100x overhead compared to native execution
- ❌ **Memory limits** - Subject to browser memory constraints (typically 2-4GB)
- ❌ **Long-running processes** - Not suitable for jobs that run for hours

Always test your converted containers to ensure they work correctly in the browser environment.

## Caveats

- **Performance** - Emulated execution is slower than native. Suitable for batch jobs, not real-time processing.
- **Testing required** - Not all containers will work. Test thoroughly before deploying to production.
- **User consent** - Users should be aware that their browsers are being used for computation.
- **Resource usage** - Heavy processing may affect device battery life and responsiveness.

## When to use this approach

Use container2wasm with Kuack when:

- You have existing containerized scripts that fit the constraints
- Rewriting to native WebAssembly would be time-consuming or impractical
- The scripts are CPU-intensive but short-lived
- Processing data locally provides clear benefits (privacy, bandwidth, latency)
- You want to leverage existing investments without major changes

For new projects or when maximum performance is critical, consider compiling directly to WebAssembly instead.
