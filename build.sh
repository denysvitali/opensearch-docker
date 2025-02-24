#!/bin/bash
IMAGE_NAME=${1:-dvitali/opensearch}
OPENSEARCH_VERSION=${2:-2.19.0}
PLATFORM=${PLATFORM:-linux/amd64,linux/arm64}

# Create a temporary (working) directory:
tempdir=$(mktemp -d)

EXTRA_BUILD_ARGS=""

# Push if the user has specified PUSH_TO_REGISTRY=1
if [ "$PUSH_TO_REGISTRY" == "1" ]; then
  EXTRA_BUILD_ARGS="--push"
fi

# Cleanup the temp dir when the script exits or dies
trap cleanup EXIT
function cleanup {
  rm -rf "$tempdir"
}

function info(){
    echo -e "\e[32m$1\e[0m"
}

# Copy the source files to the temp dir
cp -r opensearch-build/docker/release/config/opensearch/* "$tempdir"
cp opensearch-build/config/opensearch.yml "$tempdir"
cp opensearch-build/scripts/opensearch-onetime-setup.sh "$tempdir"
cp "scripts/download.sh" "$tempdir"

info "Building $IMAGE_NAME:$OPENSEARCH_VERSION"
if [ "$PUSH_TO_REGISTRY" == "1" ]; then
  info "... and pushing to registry"
fi

# Build docker image
docker buildx build \
    --platform $PLATFORM \
    --build-arg VERSION="${OPENSEARCH_VERSION}" \
    -t "$IMAGE_NAME:$OPENSEARCH_VERSION" \
    -f "Dockerfile.debian" \
    $EXTRA_BUILD_ARGS \
    "$tempdir"
