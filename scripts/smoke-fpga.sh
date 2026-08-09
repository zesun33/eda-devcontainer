#!/usr/bin/env bash
# smoke-fpga.sh — verify fpga devcontainer builds and tools work
set -euo pipefail

echo "=== FPGA DevContainer Smoke Test ==="

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FIXTURE_DIR="$ROOT_DIR/fixtures/fpga"

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

TAG="test-fpga-$(date +%s)"
# shellcheck disable=SC2086
$CONTAINER_RUNTIME build $BUILD_ARGS -t "$TAG" -f "$ROOT_DIR/.devcontainer/fpga/Dockerfile" "$ROOT_DIR/.devcontainer/fpga" >/dev/null 2>&1 || { echo "FAIL: devcontainer build"; exit 1; }

$CONTAINER_RUNTIME run --rm -v "$FIXTURE_DIR:/fixtures:Z" "$TAG" bash -c '
yosys -V || { echo "FAIL: yosys not found"; exit 1; }
command -v icepack >/dev/null 2>&1 || { echo "FAIL: icepack not found"; exit 1; }
echo "icepack: OK"
command -v iceunpack >/dev/null 2>&1 || { echo "FAIL: iceunpack not found"; exit 1; }
echo "iceunpack: OK"
nextpnr-ice40 --version || { echo "FAIL: nextpnr-ice40 not found"; exit 1; }
nextpnr-ecp5 --version || { echo "FAIL: nextpnr-ecp5 not found"; exit 1; }
command -v prjoxide >/dev/null 2>&1 || { echo "FAIL: prjoxide not found"; exit 1; }
echo "prjoxide: OK"
sta -version || { echo "FAIL: sta not found"; exit 1; }
command -v openroad >/dev/null || { echo "FAIL: openroad not found"; exit 1; }
if /usr/bin/python3 -c "import cocotb" 2>/dev/null; then
  /usr/bin/python3 -c "import cocotb; print(f\"cocotb {cocotb.__version__}\")"
else
  python3 -c "import cocotb; print(f\"cocotb {cocotb.__version__}\")"
fi
cd /fixtures
yosys -p "synth_ice40 -top blinky -json blinky.json" blinky.v >/tmp/yosys-out.txt 2>&1 || { echo "FAIL: yosys synthesis"; exit 1; }
echo "yosys + icestorm + nextpnr + fixture: OK"
' 2>&1

echo "=== FPGA DevContainer Smoke PASS ==="
