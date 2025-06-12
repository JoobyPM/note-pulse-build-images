###############################################################################
# Note-Pulse - reusable builder image
#
#  • Installs Go + Node and pnpm so the main Note-Pulse project can build both
#    backend and frontend assets.
#  • Everything is overridable with --build-arg so you'll never edit this file
#    just to bump a version.
#
#      docker build \
#        --build-arg GO_VERSION=1.24.2 \
#        --build-arg NODE_VERSION=21.7.2 \
#        --build-arg PNPM_VERSION=10.12.1 \
#        --build-arg GCI_VER=v1.64.8 \
#        -t ghcr.io/joobypm/note-pulse-build-images:go1.24.2-node20-alpine .
###############################################################################

########## overridable pins ###################################################
ARG GO_VERSION=1.24.2
ARG NODE_VERSION=21.7.2
ARG PNPM_VERSION=10.12.1
ARG SWAG_VER=v1.16.4
ARG GCI_VER=v1.64.8
ARG GOIMPORTS_VER=v0.34.0
###############################################################################

FROM golang:${GO_VERSION}-alpine AS builder

# make the build-args visible in this stage
ARG GO_VERSION
ARG NODE_VERSION
ARG PNPM_VERSION
ARG SWAG_VER
ARG GCI_VER
ARG GOIMPORTS_VER

LABEL org.opencontainers.image.source="https://github.com/joobypm/note-pulse-build-images" \
      org.opencontainers.image.description="Reusable build environment for the Note-Pulse project"

# ─────────────────────────────────────────────────────────────────────────────
# Minimal tool-box - keep the image small
# ─────────────────────────────────────────────────────────────────────────────
RUN apk add --no-cache git bash make yamllint docker-cli curl nodejs npm

# Install Go project tooling
RUN --mount=type=cache,target=/go/pkg/mod \
    go install github.com/swaggo/swag/cmd/swag@${SWAG_VER} && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@${GCI_VER} && \
    go install golang.org/x/tools/cmd/goimports@${GOIMPORTS_VER}

# Install pnpm at the requested version
RUN npm install --global "pnpm@${PNPM_VERSION}"

# Expose binaries to downstream stages
ENV PATH="/go/bin:${PATH}"

# Print versions for build logs
RUN echo "👉 Note-Pulse builder ready (Go ${GO_VERSION}, Node $(node -v), pnpm $(pnpm --version))"
