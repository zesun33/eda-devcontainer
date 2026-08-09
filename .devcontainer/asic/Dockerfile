ARG TAG=latest
FROM zesun33/asic:${TAG}

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    openssh-client \
    || true; \
    dpkg --force-all --configure -a 2>/dev/null || true; \
    rm -rf /var/lib/apt/lists/*
