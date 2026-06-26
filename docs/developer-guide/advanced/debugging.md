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

**3. Debug.** Run the binary under `gdb`, or attach to the running service:

```bash
# Attach to a running service
sudo gdb -p $(pgrep -f /var/packages/<pkg>/target/bin/<binary>)

# …or run it directly
gdb --args /var/packages/<pkg>/target/bin/<binary> <args>
```

For larger remote sessions, `gdbserver` on the NAS paired with a cross `gdb` on the build host works as well.

### Essential gdb commands

```text
run                     # start the program (when launched with --args)
continue   (c)          # resume after a breakpoint or signal
break <func|file:line>  # set a breakpoint, e.g. break main
bt                      # backtrace of the current thread
bt full                 # backtrace with local variables in each frame

# Threads (essential for multi-threaded crashes)
info threads            # list all threads, the * marks the current one
thread <n>              # switch to thread n
thread apply all bt     # backtrace of every thread

# Inspecting a frame
frame <n>   (f <n>)     # select stack frame n from the backtrace
up / down               # move one frame towards the caller / callee
info locals             # local variables of the selected frame
info args                # arguments of the selected function
print <expr>  (p)       # evaluate/print a variable or expression

quit       (q)          # leave gdb
```

A typical crash investigation is: `bt` to see where it died, `thread apply all bt` to see what every thread was doing, then `frame N` + `info locals` / `print` to inspect the offending frame.

### Analysing a Synology core dump

When a process crashes, DSM writes a **compressed core dump** to `/volume1`, named `@<binary>.synology_<platform>_<model>.<pid>.core.gz`:

```bash
$ ls -1 /volume1/*.core.gz
@deluged.synology_apollolake_918+.90075.core.gz
@jackett.synology_apollolake_918+.72806.core.gz
@tvheadend.synology_apollolake_918+.72806.core.gz
```

Decompress it and open it together with the (debug-symbol) binary:

```bash
gunzip /volume1/@tvheadend.synology_apollolake_918+.72806.core.gz
gdb /var/packages/tvheadend/target/bin/tvheadend \
    /volume1/@tvheadend.synology_apollolake_918+.72806.core

(gdb) bt
(gdb) thread apply all bt
```

For an accurate backtrace, the binary should have been built with `GCC_DEBUG_INFO = 1` (step 1); otherwise the trace is mostly addresses.

References: [#5419](https://github.com/SynoCommunity/spksrc/issues/5419), [#6640](https://github.com/SynoCommunity/spksrc/issues/6640), [#5222](https://github.com/SynoCommunity/spksrc/issues/5222) and [tvheadend#1927](https://github.com/tvheadend/tvheadend/issues/1927) show real backtraces.

## Package Contents

```bash
# List SPK contents
tar tvf packages/<pkg>_<arch>_<vers>.spk
```
