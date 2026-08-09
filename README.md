# eda-devcontainer

DevContainer profiles for hardware development — Verilog simulation, SPICE circuit analysis, FPGA synthesis, and ASIC physical design. Each profile provides a purpose-built development environment with pre-installed EDA tools, VS Code extensions, and workspace tasks.

These profiles consume local images from [`eda-docker-images`](https://github.com/zesun33/eda-docker-images). **Docker Hub pulls are not available yet** — build the base images first.

## Profiles

| Profile | Base Image | Tools | Extensions |
|---|---|---|---|
| `verilog` | `zesun33/verilog` | iverilog 12.0, verilator 5.020, verible, sv2v, svlint, cocotb 2.0 | Verilog HDL, Python, GitLens |
| `spice` | `zesun33/spice` | ngspice 42, cocotb 2.0 | Python, GitLens |
| `fpga` | `zesun33/fpga` | yosys 0.38, icestorm, nextpnr-ice40/ecp5, prjoxide, opensta 2.5, openroad 2.0, cocotb | Verilog HDL, Python, GitLens |
| `asic` | `zesun33/asic` | yosys 0.38, opensta 2.5, openroad 2.0, cocotb | Verilog HDL, Python, GitLens |

## Quickstart

### Prerequisites

- [Visual Studio Code](https://code.visualstudio.com/) or Cursor with the Dev Containers extension
- Docker or Podman (rootless Podman is supported; builds use `overlay.ignore_chown_errors`)
- Base images from sibling repo `eda-docker-images` already built locally (`make all` there)

### Open a profile

```bash
git clone https://github.com/zesun33/eda-devcontainer.git
cd eda-devcontainer
code .   # or: cursor .
```

Use **Dev Containers: Reopen in Container** and pick a profile under `.devcontainer/{verilog,spice,fpga,asic}/`.

### Build and verify locally

```bash
# Build all profile layers (requires local zesun33/* base images)
make all

# Run smoke tests
make verify
```

## Verification

`make verify` builds each thin Dockerfile and runs tool + fixture checks in-container.

## CI note

GitHub Actions cannot pull unpublished Hub images. CI assumes base images are available on the runner (build `eda-docker-images` in a prior job, or skip until Hub publish).

## License

Apache-2.0. See [LICENSE](./LICENSE).
