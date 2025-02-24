#!/bin/bash
ARCH=$(uname -m)

# Convert architecture names to OpenSearch format
case "$ARCH" in
    "x86_64")  ARCH="x64" ;;
    "aarch64") ARCH="arm64" ;;
esac

# Download and extract OpenSearch
DOWNLOAD_URL="https://artifacts.opensearch.org/releases/bundle/opensearch/${VERSION}/opensearch-${VERSION}-linux-${ARCH}.tar.gz"

if ! curl -L "$DOWNLOAD_URL" -o "$TEMP_DIR/opensearch.tar.gz"; then
    echo "Failed to download OpenSearch"
    exit 1
fi

if ! tar -xzf "$TEMP_DIR/opensearch.tar.gz" -C "$OPENSEARCH_HOME" --strip-components=1; then
    echo "Failed to extract OpenSearch"
    exit 1
fi
