# Debugging

Techniques for debugging build failures and runtime issues.

## Build Debugging

```bash
# Verbose output
make -C spk/<pkg> V=1 ARCH=x64 TCVERSION=7.2

# Check configure log
cat spk/<pkg>/work-<arch>/<pkg>-<vers>/config.log

# Incremental builds
make -C spk/<pkg> configure-arch-x64-7.2
make -C spk/<pkg> compile-arch-x64-7.2
```

## Common Failures

**"cannot find -lXXX"** - Missing library dependency
```makefile
DEPENDS = cross/openssl
ADDITIONAL_LDFLAGS = -L$(STAGING_INSTALL_PREFIX)/lib
```

**"XXX.h: No such file"** - Missing headers
```makefile
ADDITIONAL_CFLAGS = -I$(STAGING_INSTALL_PREFIX)/include
```

## Python/Wheel Debugging

Wheels are processed from the `WHEELS` list and land in `work-<arch>-<tcversion>/wheelhouse`. Run these from the package directory:

```bash
# Build every wheel in WHEELS for one arch/toolchain
make wheel-x64-7.2

# Build a single wheel (overrides WHEELS)
make WHEELS="package==version" wheel-x64-7.2

# Re-fetch the wheel sources listed in the requirement files
make download-wheels

# Create / refresh the crossenv used to cross-compile wheels
make crossenv-x64-7.2

# Cleanup (increasing scope)
make wheelclean         # built wheels + wheel status cookies
make crossenvclean      # the above + the crossenv dirs and their cookies
make wheelcleancache    # the local pip cache (work-*/pip)
make crossenvcleanall   # everything: wheels, crossenv, and all caches
```

## Runtime Debugging

```bash
# Package log on NAS
cat /var/packages/<pkg>/var/*.log

# System log
sudo cat /var/log/synopkg.log | grep <pkg>

```

## Debugging with GDB (debug symbols)

To analyse a crash or get a usable backtrace, build the package **with debug symbols** and debug it on the NAS with `gdb` from the **synocli-devel** package.

**1. Build with debug info.** Set `GCC_DEBUG_INFO = 1` in the package's (or the relevant `cross/`) Makefile and rebuild. This keeps debugging information instead of an optimized/stripped build:

- autotools → `--enable-debug`
- CMake → `CMAKE_BUILD_TYPE = RelWithDebInfo` (+ `GCC_DEBUG_FLAGS`)
- meson → debug build type

```makefile
GCC_DEBUG_INFO = 1
```

**2. Install `synocli-devel` on the NAS.** It provides `gdb`, `gdbserver` and `gdb-add-index` (linked under `/usr/local/bin`).

**3. Debug.** Run the binary under `gdb`, or attach to the running service and capture a backtrace:

```bash
# Attach to a running service
sudo gdb -p $(pgrep -f /var/packages/<pkg>/target/bin/<binary>)

# …or run it directly
gdb --args /var/packages/<pkg>/target/bin/<binary> <args>

# In gdb, after the crash:
(gdb) bt full
```

For larger remote sessions, `gdbserver` on the NAS paired with a cross `gdb` on the build host works as well.

!!! tip "Examples in the issue tracker"
    - [#5419](https://github.com/SynoCommunity/spksrc/issues/5419), [#6640](https://github.com/SynoCommunity/spksrc/issues/6640), [#5222](https://github.com/SynoCommunity/spksrc/issues/5222) — gdb backtraces from SynoCommunity packages
    - [tvheadend#1927](https://github.com/tvheadend/tvheadend/issues/1927) — an upstream issue resolved with a backtrace

## Package Contents

```bash
# List SPK contents
tar tvf packages/<pkg>_<arch>_<vers>.spk
```
