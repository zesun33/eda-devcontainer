#!/usr/bin/env bash
# smoke-spice.sh — verify spice devcontainer builds and tools work
set -euo pipefail

echo "=== SPICE DevContainer Smoke Test ==="

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FIXTURE_DIR="$ROOT_DIR/fixtures/spice"

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

BUILD_ARGS="${CONTAINER_BUILD_ARGS:-}"
if [ "$CONTAINER_RUNTIME" = "podman" ]; then
    BUILD_ARGS="$BUILD_ARGS --storage-opt overlay.ignore_chown_errors=true"
fi

TAG="test-spice-$(date +%s)"
# shellcheck disable=SC2086
$CONTAINER_RUNTIME build $BUILD_ARGS -t "$TAG" -f "$ROOT_DIR/.devcontainer/spice/Dockerfile" "$ROOT_DIR/.devcontainer/spice" 2>&1 || { echo "FAIL: devcontainer build"; exit 1; }

$CONTAINER_RUNTIME run --rm -v "$FIXTURE_DIR:/fixtures:Z" "$TAG" bash -c '
ngspice -v >/tmp/ngspice-version.txt 2>&1 || { echo "FAIL: ngspice not found"; exit 1; }
sed -n "1p" /tmp/ngspice-version.txt
echo "ngspice: OK"
ngspice -b /fixtures/rc_lowpass.cir 2>&1 || { echo "FAIL: ngspice simulation"; exit 1; }
echo "ngspice simulation: OK"
' 2>&1

echo "=== SPICE DevContainer Smoke PASS ==="
