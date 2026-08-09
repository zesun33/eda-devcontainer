#!/usr/bin/env bash
# smoke-asic.sh — verify asic devcontainer builds and tools work
set -euo pipefail

echo "=== ASIC DevContainer Smoke Test ==="

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FIXTURE_DIR="$ROOT_DIR/fixtures/asic"

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

TAG="test-asic-$(date +%s)"
# shellcheck disable=SC2086
$CONTAINER_RUNTIME build $BUILD_ARGS -t "$TAG" -f "$ROOT_DIR/.devcontainer/asic/Dockerfile" "$ROOT_DIR/.devcontainer/asic" >/dev/null 2>&1 || { echo "FAIL: devcontainer build"; exit 1; }

$CONTAINER_RUNTIME run --rm -v "$FIXTURE_DIR:/fixtures:Z" "$TAG" bash -c '
yosys -V || { echo "FAIL: yosys not found"; exit 1; }
sta -version || { echo "FAIL: sta not found"; exit 1; }
command -v openroad >/dev/null || { echo "FAIL: openroad not found"; exit 1; }
openroad -version 2>&1 | head -1 || true
if /usr/bin/python3 -c "import cocotb" 2>/dev/null; then
  /usr/bin/python3 -c "import cocotb; print(f\"cocotb {cocotb.__version__}\")"
else
  python3 -c "import cocotb; print(f\"cocotb {cocotb.__version__}\")"
fi
cd /fixtures
yosys -p "synth -top tiny_top; stat" tiny_top.v >/tmp/yosys-out.txt 2>&1 || { echo "FAIL: yosys synthesis"; exit 1; }
echo "yosys + opensta + openroad + fixture: OK"
' 2>&1

echo "=== ASIC DevContainer Smoke PASS ==="
