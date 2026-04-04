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

```bash
# Verbose wheel build
make WHEEL_VERBOSE=1 arch-x64-7.2

# Build single wheel
WHEEL="package==version" make wheel-x64-7.2
```

## Runtime Debugging

```bash
# Package log on NAS
cat /var/packages/<pkg>/var/*.log

# System log
sudo cat /var/log/synopkg.log | grep <pkg>

```

## Package Contents

```bash
# List SPK contents
tar tvf packages/<pkg>_<arch>_<vers>.spk
```
