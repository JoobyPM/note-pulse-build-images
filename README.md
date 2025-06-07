# 🛠️ Note-Pulse - Builder Image

A lean Alpine container that ships the exact tool-chain expected by the
[Note-Pulse](https://github.com/JoobyPM/note-pulse) application.

| Tool                    | Default           | Override with `--build-arg`       |
|-------------------------|-------------------|------------------------------------|
| **Go**                  | `1.24.2`          | `GO_VERSION`                       |
| **swag** (OpenAPI)      | `v1.16.4`         | `SWAG_VER`                         |
| **golangci-lint**       | `v1.64.8`         | `GCI_VER`                          |
| **goimports**           | `v0.34.0`         | `GOIMPORTS_VER`                    |

## Why a dedicated image?

* **CI runs faster** - module & tool downloads are baked in.
* **Reproducible builds** - everyone compiles with the same versions.
* **One-line upgrades** - bump a *build arg* in the workflow, not the code.

## Quick start

```bash
# Pull the ready-made image
docker pull ghcr.io/JoobyPM/note-pulse-build-images:go1.24.2-alpine

# Use it in your multi-stage Dockerfile
FROM ghcr.io/JoobyPM/note-pulse-build-images:go1.24.2-alpine AS builder
# ... project build steps ...

# Build locally with a newer linter
docker build \
  --build-arg GCI_VER=v1.64.8 \
  -t note-pulse/builder:dev .
```

## How to use

```dockerfile
FROM ghcr.io/JoobyPM/note-pulse-build-images:go1.24.2-alpine AS builder
# ... project build steps ...
```
