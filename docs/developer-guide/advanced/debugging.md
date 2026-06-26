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

## Package Contents

```bash
# List SPK contents
tar tvf packages/<pkg>_<arch>_<vers>.spk
```
