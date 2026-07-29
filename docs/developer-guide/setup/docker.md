# Docker Setup

The Docker development environment is the recommended approach for most users. It provides a pre-configured container with all dependencies installed.

!!! warning "Platform Support"
    Docker setup supports **Linux** and **macOS**. Windows is not supported due to file system limitations affecting symlinks and permissions.

## Prerequisites

- [Docker](https://docs.docker.com/engine/install/) installed on your system
- Git installed for cloning the repository

## Quick Start

### 1. Fork and Clone the Repository

```bash
# Fork on GitHub first, then clone your fork
git clone https://github.com/YOUR-USERNAME/spksrc
cd spksrc
```

### 2. Pull the Container Image

```bash
docker pull ghcr.io/synocommunity/spksrc
```

### 3. Run the Container

=== "Linux"

    ```bash
    docker run -it --platform=linux/amd64 \
      -v $(pwd):/spksrc \
      -w /spksrc \
      ghcr.io/synocommunity/spksrc /bin/bash
    ```

=== "macOS"

    ```bash
    docker run -it --platform=linux/amd64 \
      -v $(pwd):/spksrc \
      -w /spksrc \
      -e TAR_CMD="fakeroot tar" \
      ghcr.io/synocommunity/spksrc /bin/bash
    ```

### 4. Run Initial Setup

Inside the container:

```bash
make setup
```

This creates `local.mk` with default toolchain configuration.

### 5. Test Your Setup

```bash
make -C spk/transmission ARCH=x64 TCVERSION=7.2
```

If the build completes, your environment is ready!

## Container Details

### What's Included

The container includes:

- Debian Trixie (testing) base
- All required build tools (GCC, Make, CMake, etc.)
- Cross-compilation toolchains (downloaded on first use)
- Python 3.12 with build dependencies
- Meson, Ninja, Rust toolchain support

### Volume Mounts

The repository is mounted at `/spksrc`. Changes made in the container are reflected on your host, and vice versa.

### Persisting Work

Your work is saved in the mounted repository directory. You can:

- Exit and restart the container without losing work
- Run multiple containers sharing the same repository
- Use your favorite editor on the host while building in the container

## Advanced Configuration

### Using a Custom Network

If you need to access the container from other services:

```bash
docker run -it --platform=linux/amd64 \
  -v $(pwd):/spksrc \
  -w /spksrc \
  -p 8080:8080 \
  ghcr.io/synocommunity/spksrc /bin/bash
```

### Using a Proxy

If your network requires a proxy:

```bash
docker run -it --platform=linux/amd64 \
  -v $(pwd):/spksrc \
  -w /spksrc \
  -e http_proxy="http://proxy:3128" \
  -e https_proxy="http://proxy:3128" \
  ghcr.io/synocommunity/spksrc /bin/bash
```

### Allocating More Resources

For parallel builds, allocate more memory:

```bash
docker run -it --platform=linux/amd64 \
  -v $(pwd):/spksrc \
  -w /spksrc \
  --memory=16g \
  ghcr.io/synocommunity/spksrc /bin/bash
```

## Troubleshooting

### "Cannot run on Apple Silicon"

The container runs under x86 emulation on Apple Silicon Macs using Rosetta. Make sure to include `--platform=linux/amd64`.

### Permission Issues

If you see permission errors:

1. Check that the mounted directory has appropriate permissions
2. On Linux, you may need to run Docker with your user ID:
   ```bash
   docker run -it --platform=linux/amd64 \
     -v $(pwd):/spksrc \
     -w /spksrc \
     -u $(id -u):$(id -g) \
     ghcr.io/synocommunity/spksrc /bin/bash
   ```

### Container Won't Start

1. Ensure Docker is running: `docker info`
2. Pull the latest image: `docker pull ghcr.io/synocommunity/spksrc`
3. Check for conflicting containers: `docker ps -a`

## Next Steps

Continue to [Your First Package](../basics/first-package.md) to build your first SPK.
