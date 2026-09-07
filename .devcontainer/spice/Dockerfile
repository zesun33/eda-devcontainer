ARG TAG=latest
ARG BASE=localhost/zesun33/spice
FROM ${BASE}:${TAG}

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    openssh-client \
    || true; \
    dpkg --force-all --configure -a 2>/dev/null || true; \
    rm -rf /var/lib/apt/lists/*
