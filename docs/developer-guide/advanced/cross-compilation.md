# Cross-Compilation

spksrc uses cross-compilation to build binaries for Synology devices from a development machine.

## Toolchain Components

- **Cross-compiler** - GCC configured for target architecture
- **Binutils** - Assembler, linker, and tools
- **C library** - glibc or uClibc for target
- **Headers** - Kernel and library headers

## Building Toolchains

```bash
make -C toolchain/syno-x64-7.2
make -C toolchain/syno-aarch64-7.2
```

## Toolchain Variables

```makefile
TC_PATH      # Path to toolchain binaries
TC_PREFIX    # Cross-compiler prefix
CC           # Cross-compiler (gcc)
CXX          # Cross-compiler (g++)
```

## Configure Scripts

```makefile
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --host=$(TC_TARGET) --prefix=$(INSTALL_PREFIX)
```

## Library Dependencies

```makefile
DEPENDS = cross/openssl cross/zlib
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include
ADDITIONAL_LDFLAGS = -L$(STAGING_INSTALL_PREFIX)/lib
```

## Debugging

```bash
# Verbose output
make V=1 arch-x64-7.2

# Check configure log
cat spk/<pkg>/work-x64-7.2/<pkg>-<vers>/config.log

# Verify binary architecture
file spk/<pkg>/work-x64-7.2/install/var/packages/<pkg>/target/bin/<binary>
```

## Further Reading

For details on how the cross-compilation framework works internally, see:

- [Framework Architecture](../../framework/architecture.md) - Build pipeline and stages
- [Framework Toolchains](../../framework/toolchains.md) - Toolchain management internals
