ARG TAG=latest
FROM zesun33/verilog:${TAG}

# Rootless podman: openssh-client postinst may fail on chgrp; force-configure and continue.
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    openssh-client \
    || true; \
    dpkg --force-all --configure -a 2>/dev/null || true; \
    rm -rf /var/lib/apt/lists/*
