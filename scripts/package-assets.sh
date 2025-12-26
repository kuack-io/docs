#!/usr/bin/env bash
#
# Script that builds release artifacts for kuack documentation.
#
# Flag legend:
# -e: exit immediately if one of the commands fails
# -u: throw an error if one of the inputs is not set
# -o pipefail: result is the value of the last command
# +x: do not print all executed commands to terminal
set -euo pipefail
set +x

VERSION=$1
OUTPUT_DIR="release-artifacts"

if [[ -z "$VERSION" ]]; then
  echo "Missing release version argument" >&2
  exit 1
fi

rm -rf "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR"

ARCHIVE="$OUTPUT_DIR/kuack-docs.tar.gz"
tar -C "public" -czf "$ARCHIVE" .

echo "Created release artifacts in $OUTPUT_DIR:"
ls -lh "$OUTPUT_DIR"
