.PHONY: all build-verilog build-spice build-fpga build-asic \
        smoke-verilog smoke-spice smoke-fpga smoke-asic \
        verify clean

CONTAINER_RUNTIME ?= $(shell command -v docker >/dev/null && echo docker || echo podman)
CONTAINER_BUILD_ARGS ?= $(shell [ "$(CONTAINER_RUNTIME)" = "podman" ] && echo "--storage-opt overlay.ignore_chown_errors=true")

all: build-verilog build-spice build-fpga build-asic

build-verilog:
	$(CONTAINER_RUNTIME) build $(CONTAINER_BUILD_ARGS) \
		-t zesun33/devcontainer-verilog \
		-f .devcontainer/verilog/Dockerfile .devcontainer/verilog

build-spice:
	$(CONTAINER_RUNTIME) build $(CONTAINER_BUILD_ARGS) \
		-t zesun33/devcontainer-spice \
		-f .devcontainer/spice/Dockerfile .devcontainer/spice

build-fpga:
	$(CONTAINER_RUNTIME) build $(CONTAINER_BUILD_ARGS) \
		-t zesun33/devcontainer-fpga \
		-f .devcontainer/fpga/Dockerfile .devcontainer/fpga

build-asic:
	$(CONTAINER_RUNTIME) build $(CONTAINER_BUILD_ARGS) \
		-t zesun33/devcontainer-asic \
		-f .devcontainer/asic/Dockerfile .devcontainer/asic

smoke-verilog:
	bash scripts/smoke-verilog.sh

smoke-spice:
	bash scripts/smoke-spice.sh

smoke-fpga:
	bash scripts/smoke-fpga.sh

smoke-asic:
	bash scripts/smoke-asic.sh

verify:
	bash scripts/verify.sh

clean:
	-$(CONTAINER_RUNTIME) rmi zesun33/devcontainer-verilog 2>/dev/null || true
	-$(CONTAINER_RUNTIME) rmi zesun33/devcontainer-spice 2>/dev/null || true
	-$(CONTAINER_RUNTIME) rmi zesun33/devcontainer-fpga 2>/dev/null || true
	-$(CONTAINER_RUNTIME) rmi zesun33/devcontainer-asic 2>/dev/null || true
