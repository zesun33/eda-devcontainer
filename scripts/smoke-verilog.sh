#!/usr/bin/env bash
# smoke-verilog.sh — verify verilog devcontainer builds and tools work
set -euo pipefail

echo "=== Verilog DevContainer Smoke Test ==="

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
FIXTURE_DIR="$ROOT_DIR/fixtures/verilog"

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

TAG="test-verilog-$(date +%s)"
$CONTAINER_RUNTIME build $BUILD_ARGS -t "$TAG" -f "$ROOT_DIR/.devcontainer/verilog/Dockerfile" "$ROOT_DIR/.devcontainer/verilog" >/dev/null 2>&1 || { echo "FAIL: devcontainer build"; exit 1; }

$CONTAINER_RUNTIME run --rm -v "$FIXTURE_DIR:/fixtures:Z" "$TAG" bash -c '
iverilog -V >/tmp/iverilog-version.txt 2>&1 || { echo "FAIL: iverilog not found"; exit 1; }
sed -n "1p" /tmp/iverilog-version.txt
verilator --version >/tmp/verilator-version.txt 2>&1 || { echo "FAIL: verilator not found"; exit 1; }
sed -n "1p" /tmp/verilator-version.txt
if /usr/bin/python3 -c "import cocotb" 2>/dev/null; then
  /usr/bin/python3 -c "import cocotb; print(f\"cocotb {cocotb.__version__}\")"
else
  python3 -c "import cocotb; print(f\"cocotb {cocotb.__version__}\")"
fi
echo "iverilog + verilator: OK"

cd /fixtures
rm -f counter_sim counter.vcd
iverilog -o counter_sim counter.v counter_tb.v 2>&1 || { echo "FAIL: iverilog compile"; exit 1; }
vvp counter_sim 2>&1 | grep -q "PASS" || { echo "FAIL: simulation result"; exit 1; }
echo "counter compile + simulate: PASS"
' 2>&1

echo "=== Verilog DevContainer Smoke PASS ==="
