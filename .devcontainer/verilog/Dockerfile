ARG TAG=latest
ARG BASE=localhost/zesun33/verilog
FROM ${BASE}:${TAG}

# Rootless podman: openssh-client postinst may fail on chgrp; force-configure and continue.
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    openssh-client \
    || true; \
    dpkg --force-all --configure -a 2>/dev/null || true; \
    rm -rf /var/lib/apt/lists/*
