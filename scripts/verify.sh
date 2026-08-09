#!/usr/bin/env bash
# verify.sh — build and smoke-test all devcontainer profiles
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

CONTAINER_RUNTIME="${CONTAINER_RUNTIME:-}"
if [ -z "$CONTAINER_RUNTIME" ]; then
    if command -v docker &>/dev/null; then
        CONTAINER_RUNTIME=docker
    elif command -v podman &>/dev/null; then
        CONTAINER_RUNTIME=podman
    else
        echo "FAIL: no container runtime found"
        exit 1
    fi
fi
export CONTAINER_RUNTIME

BUILD_ARGS="${CONTAINER_BUILD_ARGS:-}"
if [ "$CONTAINER_RUNTIME" = "podman" ]; then
    BUILD_ARGS="$BUILD_ARGS --storage-opt overlay.ignore_chown_errors=true"
fi
export CONTAINER_BUILD_ARGS="$BUILD_ARGS"

echo "Container runtime: $CONTAINER_RUNTIME"

for profile in verilog spice fpga asic; do
    echo "---"
    echo "Smoke testing $profile..."
    if bash "scripts/smoke-$profile.sh"; then
        echo "  ✓ $profile verified"
    else
        echo "  ✗ $profile FAILED"
        exit 1
    fi
done

echo "---"
echo "All devcontainer profiles verified."
