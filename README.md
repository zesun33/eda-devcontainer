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

---

## ⚡ Quick Tour: Instant Hardware IDE in Cursor & VS Code

### Traditional IDE Setup vs. `eda-devcontainer`
| Traditional Manual Setup | With `eda-devcontainer` |
| :--- | :--- |
| Manually find and install 5+ language extensions and linters | **1-Click "Reopen in Container"** auto-provisions everything |
| Broken linter paths when switching projects or hosts | Pinned `verible`, `sv2v`, and `verilator` binaries already on `$PATH` |
| Virtual environment clashes between PyTorch, cocotb, and system Python | Pre-configured Python 3.12 + `cocotb 2.0` ready to run testbenches |
| Inconsistent team editor settings | Pinned editor defaults (format-on-save, file associations `.v`/`.sv`) |

### Developer Experience in 3 Steps

1. **Clone & Open**: `cursor .` or `code .`
2. **Reopen**: Click **Reopen in Container** and select your domain (`verilog`, `spice`, `fpga`, `asic`).
3. **Instant Verification**: On boot, the container runs its built-in sanity probe:
   ```text
   [postCreateCommand]
   iverilog 12.0 (stable) | Verilator 5.020 | cocotb v2.0.1
   ✔ All hardware extensions active and connected to container runtime.
   ```

---

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
