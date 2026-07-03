# LXC Container Setup

LXC (Linux Containers) provides a lightweight alternative to full virtual machines on Linux systems.

## Prerequisites

- **Linux host** with LXD/LXC installed and configured
- **64-bit x86 host** - non-x86 host architectures are not supported
- Basic LXD/LXC knowledge (e.g., `lxd init` already run)

## Quick Start

### 1. Create the Container

```bash
lxc launch images:debian/13 spksrc
```

### 2. Enable 32-bit Architecture

```bash
lxc exec spksrc -- /usr/bin/dpkg --add-architecture i386
lxc exec spksrc -- /usr/bin/apt update
```

### 3. Install Build Dependencies

```bash
lxc exec spksrc -- /usr/bin/apt install --no-install-recommends -y \
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
```

### 4. Install Python Dependencies

```bash
lxc exec spksrc -- /usr/bin/apt install --no-install-recommends -y \
    httpie mercurial meson ninja-build \
    python3 python3-mako python3-pip python3-setuptools \
    python3-virtualenv python3-yaml
```

### 5. Create spksrc User

By default, development is done as a non-root `spksrc` user:

```bash
lxc exec spksrc -- /usr/sbin/adduser --uid 1001 spksrc
lxc exec spksrc --user 1001 -- cp /etc/skel/.profile /etc/skel/.bashrc ~spksrc/.
```

### 6. Connect to the Container

```bash
lxc exec spksrc -- su --login spksrc
```

### 7. Clone and Setup

Inside the container:

```bash
git clone https://github.com/YOUR-USERNAME/spksrc
cd spksrc
make setup
```

### 8. Test Your Setup

```bash
make -C spk/transmission ARCH=x64 TCVERSION=7.2
```

## Advanced Configuration

### Shared Home Directory

You can share your host home directory with the container for easier file access:

```bash
# Create matching user on host (if not exists)
# UID 1001 must match the container user

# Map the UID
lxc config set spksrc raw.idmap "both 1001 1001"
lxc restart spksrc

# Mount host home directory
lxc config device add spksrc home disk path=/home/spksrc source=/home/spksrc
```

Now files in `/home/spksrc` are shared between host and container.

### Using a Proxy

If your network requires a proxy:

```bash
# Set environment variables for the container
lxc config set spksrc environment.http_proxy http://192.168.1.1:3128
lxc config set spksrc environment.https_proxy http://192.168.1.1:3128

# Configure wget for the spksrc user
lxc exec spksrc --user $(id -u spksrc) -- bash -c "cat << WGETRC > ~spksrc/.wgetrc
use_proxy = on
http_proxy = http://192.168.1.1:3128/
https_proxy = http://192.168.1.1:3128/
ftp_proxy = http://192.168.1.1:3128/
WGETRC"
```

### Allocating Resources

```bash
# Limit CPU
lxc config set spksrc limits.cpu 4

# Limit memory
lxc config set spksrc limits.memory 8GB

# Increase disk space (if using ZFS)
lxc config device set spksrc root size=100GB
```

### Multiple Containers

You can run multiple containers for different purposes:

```bash
# Development container
lxc copy spksrc spksrc-dev

# Testing container
lxc copy spksrc spksrc-test
```

## Container Management

### Start/Stop

```bash
lxc start spksrc
lxc stop spksrc
```

### Snapshot

Create snapshots before major changes:

```bash
lxc snapshot spksrc clean-install
lxc restore spksrc clean-install  # if needed
```

### Delete

```bash
lxc delete spksrc --force
```

## Troubleshooting

### Permission Denied Errors

Ensure the UID mapping is correct:

```bash
lxc config show spksrc | grep idmap
```

### Container Won't Start

Check LXD status:

```bash
lxc list
systemctl status lxd
```

### Network Issues

Check container network:

```bash
lxc exec spksrc -- ip addr
lxc exec spksrc -- ping -c 1 google.com
```

## Next Steps

Continue to [Your First Package](../basics/first-package.md) to build your first SPK.
