# Virtual Machine Setup

A virtual machine provides a complete development environment that you can customize and use for long-term development.

## Requirements

- **64-bit x86 host** - non-x86 host architectures are not supported
- **Virtualization software** - VirtualBox, VMware, Parallels, or similar
- **Debian 13 (Trixie)** stable 64-bit - the recommended guest OS

## VM Configuration

Recommended VM settings:

| Setting | Minimum | Recommended |
|---------|---------|-------------|
| RAM | 4 GB | 8-16 GB |
| CPUs | 2 | 4-8 |
| Disk | 50 GB | 100+ GB |
| Network | NAT | NAT or Bridged |

## Installation

### 1. Install Debian

Download and install [Debian 13 (Trixie)](https://www.debian.org/devel/debian-installer/) with minimal installation options.

### 2. Install Required Packages

After installation, run the following commands:

```bash
# Enable 32-bit architecture (required for some toolchains)
sudo dpkg --add-architecture i386
sudo apt update

# Install build dependencies
sudo apt install --no-install-recommends -y \
    autoconf-archive autogen automake autopoint \
    bash bash-completion bc bison build-essential \
    check cmake curl cython3 debootstrap ed expect \
    fakeroot flex gh g++-multilib gawk gettext gfortran \
    git gobject-introspection gperf imagemagick intltool \
    jq libbz2-dev libc6-i386 libcppunit-dev libelf-dev \
    libffi-dev libgc-dev libgmp3-dev libicu76 libltdl-dev \
    libmount-dev libncurses-dev libpcre2-dev libssl-dev \
    libtool libtool-bin libunistring-dev lzip man-db manpages-dev \
    moreutils nasm p7zip patchelf php pkg-config plocate \
    rename ripgrep rsync ruby-mustache scons subversion \
    sudo swig texinfo time tree unzip xmlto yasm \
    zip zlib1g-dev

# Install Python dependencies
sudo apt install --no-install-recommends -y \
    httpie mercurial meson ninja-build \
    python3 python3-mako python3-pip python3-setuptools \
    python3-virtualenv python3-yaml
```

### 3. Clone the Repository

```bash
# Fork on GitHub first, then clone your fork
git clone https://github.com/YOUR-USERNAME/spksrc
cd spksrc
```

### 4. Run Initial Setup

```bash
make setup
```

This creates `local.mk` with default toolchain configuration.

### 5. Test Your Setup

```bash
make -C spk/transmission ARCH=x64 TCVERSION=7.2
```

If the build completes, your environment is ready!

## Configuration

### local.mk

After running `make setup`, edit `local.mk` to customize your environment:

```makefile
# Build for specific architectures only
DEFAULT_TC = 7.2

# Use parallel jobs (adjust based on CPU cores)
MAKEFLAGS += -j8

# Use a local cache directory
DISTRIB_DIR = /home/spksrc/distrib
```

### Using a Proxy

If your network requires a proxy:

```bash
# Add to ~/.bashrc
export http_proxy="http://proxy:3128"
export https_proxy="http://proxy:3128"

# For wget
cat > ~/.wgetrc << 'WGETRC'
use_proxy = on
http_proxy = http://proxy:3128/
https_proxy = http://proxy:3128/
WGETRC
```

## Performance Tips

### Enable Parallel Builds

Add to `local.mk`:

```makefile
MAKEFLAGS += -j$(nproc)
```

### Use an SSD

Build performance is significantly better with SSD storage, especially for the `work/` directory.

### Allocate More RAM

Some builds (e.g., LLVM, Chromium) require significant RAM. 16GB+ recommended for these.

### Use ccache (Optional)

For repeated builds of the same packages:

```bash
sudo apt install ccache
echo 'export PATH="/usr/lib/ccache:$PATH"' >> ~/.bashrc
```

## Keeping Up to Date

### Update System Packages

```bash
sudo apt update && sudo apt upgrade
```

### Update spksrc

```bash
cd spksrc
git fetch upstream
git merge upstream/master
```

### Update Toolchains

Toolchains are downloaded on first use. To force re-download:

```bash
make clean-toolchain
```

## Troubleshooting

### Missing Library Errors

If you see missing library errors during builds:

```bash
# Search for the package
apt-cache search libXXX

# Install it
sudo apt install libXXX-dev
```

### 32-bit Build Failures

Ensure 32-bit support is enabled:

```bash
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install libc6-i386
```

### Out of Disk Space

1. Clean build artifacts: `make clean`
2. Clean toolchains: `make clean-toolchain`
3. Remove old distribution files: `rm -rf distrib/*`

## Next Steps

Continue to [Your First Package](../basics/first-package.md) to build your first SPK.
