# eda-devcontainer

DevContainer profiles for hardware development — Verilog simulation, SPICE circuit analysis, FPGA synthesis, and ASIC physical design. Each profile provides a purpose-built development environment with pre-installed EDA tools, VS Code extensions, and workspace tasks.

These profiles consume images from [`eda-docker-images`](https://github.com/zesun33/eda-docker-images). Prefer public GHCR tags (`ghcr.io/zesun33/...`); local `localhost/zesun33/...` builds still work after `make all` in that repo.

## Profiles

| Profile | Base Image | Tools | Extensions |
|---|---|---|---|
| `verilog` | `ghcr.io/zesun33/verilog` (or local `localhost/...`) | iverilog 12.0, verilator 5.020, verible, sv2v, svlint, cocotb 2.0 | Verilog HDL, Python, GitLens |
| `spice` | `ghcr.io/zesun33/spice` | ngspice 42, cocotb 2.0 | Python, GitLens |
| `fpga` | `ghcr.io/zesun33/fpga` | yosys 0.38, icestorm, nextpnr-ice40/ecp5, prjoxide, opensta 2.5, openroad 2.0, cocotb | Verilog HDL, Python, GitLens |
| `asic` | `ghcr.io/zesun33/asic` | yosys 0.38, opensta 2.5, openroad 2.0, cocotb | Verilog HDL, Python, GitLens |

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
- Base images available locally **or** via GHCR:
  ```bash
  podman pull ghcr.io/zesun33/verilog:latest
  # optional: retag for Dockerfiles that still default to localhost
  podman tag ghcr.io/zesun33/verilog:latest localhost/zesun33/verilog:latest
  ```
  Or build from sibling `eda-docker-images` (`make all`). Override with `--build-arg BASE=ghcr.io/zesun33/verilog`.

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

GitHub Actions can pull public GHCR images (`ghcr.io/zesun33/...`). Local profile Dockerfiles still default to `localhost/...`; set `BASE=ghcr.io/zesun33/<image>` in CI or retag after pull.

## License

Apache-2.0. See [LICENSE](./LICENSE).
