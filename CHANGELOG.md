# eda-devcontainer

## 2026-09-07

### Changed
- Profiles prefer public GHCR bases (`ghcr.io/zesun33/...`); local `localhost/zesun33/...` still works after a sibling `make all` or retag.

## 2026-06-17

### Added
- Initial release
- 4 devcontainer profiles (verilog, spice, fpga, asic)
- Dockerfiles per profile
- VS Code extension recommendations per profile
- Fixture files for smoke testing
- Makefile with build/verify targets
- CI workflow
- Smoke scripts per profile
