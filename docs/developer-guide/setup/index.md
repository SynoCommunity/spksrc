# Development Environment Setup

This section covers how to set up your development environment for building spksrc packages.

## Requirements

- A **64-bit x86 (amd64)** system - non-x86 host architectures are not supported
- At least **8GB RAM** recommended (16GB+ for parallel builds)
- **50GB+ disk space** for toolchains and build artifacts
- **Internet connection** for downloading source files and toolchains

## Choose Your Method

=== "Docker (Recommended)"

    **Best for:** Quick setup, consistent environment
    
    - Works on Linux and macOS
    - Pre-configured container with all dependencies
    - Easy to update
    
    [Set up Docker →](docker.md)

=== "Virtual Machine"

    **Best for:** Full development environment, long-term work
    
    - Complete Debian system
    - Can install additional tools
    - Good for debugging
    
    [Set up VM →](vm.md)

=== "LXC Container"

    **Best for:** Linux users wanting lightweight isolation
    
    - Lower overhead than VMs
    - Shared kernel with host
    - Good for multiple environments
    
    [Set up LXC →](lxc.md)

## After Setup

Once your environment is ready:

1. **Clone the repository** (if using Docker, this is already done)
   ```bash
   git clone https://github.com/SynoCommunity/spksrc.git
   cd spksrc
   ```

2. **Run initial setup**
   ```bash
   make setup
   ```
   This creates `local.mk` with default toolchain configuration.

3. **Test your setup** by building a simple package:
   ```bash
   make -C spk/transmission ARCH=x64 TCVERSION=7.2
   ```

4. Continue to [Your First Package](../basics/first-package.md)
