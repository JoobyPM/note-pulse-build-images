###############################################################################
# Note-Pulse - reusable builder image
#
#  • Installs Go + the CLI tools the main Note-Pulse project needs.
#  • Everything is overridable with --build-arg so you'll never edit this file
#    just to bump a version.
#
#      docker build \
#        --build-arg GO_VERSION=1.24.2 \
#        --build-arg GCI_VER=v1.64.8 \
#        -t ghcr.io/joobypm/note-pulse-build-images:go1.24.2-alpine .
###############################################################################

########## overridable pins ###################################################
ARG GO_VERSION=1.24.2
ARG SWAG_VER=v1.16.4
ARG GCI_VER=v1.64.8
ARG GOIMPORTS_VER=v0.34.0
###############################################################################

FROM golang:${GO_VERSION}-alpine AS builder

# make the build-args visible in this stage
ARG GO_VERSION
ARG SWAG_VER
ARG GCI_VER
ARG GOIMPORTS_VER

LABEL org.opencontainers.image.source="https://github.com/joobypm/note-pulse-build-images" \
      org.opencontainers.image.description="Reusable build environment for the Note-Pulse project"

# ─────────────────────────────────────────────────────────────────────────────
# Minimal tool-box - keep the image tiny
# ─────────────────────────────────────────────────────────────────────────────
RUN apk add --no-cache git bash make

# Install project tooling.  
# BuildKit's module cache keeps subsequent builds ⚡ fast.
RUN --mount=type=cache,target=/go/pkg/mod \
    go install github.com/swaggo/swag/cmd/swag@${SWAG_VER} && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@${GCI_VER} && \
    go install golang.org/x/tools/cmd/goimports@${GOIMPORTS_VER}

# Expose Go binaries to any downstream stage *by default*.
ENV PATH="/go/bin:${PATH}"

# Happy build log
RUN echo "👉 Note-Pulse builder ready (Go ${GO_VERSION})"
