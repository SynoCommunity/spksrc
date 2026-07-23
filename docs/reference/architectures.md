# Architectures

This page documents CPU architectures supported by spksrc and Synology devices.

## Overview

Synology NAS devices use various CPU architectures. spksrc cross-compiles packages for each supported architecture.

## Architecture Naming

Architectures are identified as `<arch>-<tcversion>` where:

- `<arch>` - CPU architecture identifier
- `<tcversion>` - DSM toolchain version (e.g., 7.2, 6.2)

Example: `x64-7.2` = Intel 64-bit, DSM 7.2 toolchain

## Current Architectures (DSM 7.x)

| Architecture | CPU Family | Description | Example Models |
|--------------|------------|-------------|----------------|
| `x64` | Intel 64-bit | x86-64 processors | DS923+, RS1221+ |
| `aarch64` | ARM 64-bit | ARM Cortex-A57 (Marvell) | DS220+, DS720+, DS920+ |
| `armv8` | ARM 64-bit | ARM Cortex-A55 (Realtek) | DS223, DS423, RS422+ |

## Legacy Architectures (DSM 6.x)

| Architecture | CPU Family | Description | Example Models |
|--------------|------------|-------------|----------------|
| `x86` | Intel 32-bit | x86 processors | DS216play |
| `armv7` | ARM 32-bit | Various ARM v7 | DS218j, DS418 |
| `armv7l` | ARM 32-bit | Low-end ARM v7 | DS115j |
| `qoriq` | QorIQ | Freescale QorIQ | DS215j |
| `comcerto2k` | Comcerto | Mindspeed Comcerto | DS414j |
| `ppc853x` | PowerPC | PowerPC 85xx | DS109j |

## Architecture Groups

spksrc classifies every platform codename into groups used for conditional logic, defined in `mk/spksrc.common/archs.mk`. The generic build arch of each family is shown in the comments.

### Architecture families

```makefile
x64_ARCHS    # Intel/AMD 64-bit (build arch: x64)
             #   x64 apollolake avoton braswell broadwell(nk...) bromolow
             #   cedarview denverton epyc7002 geminilake(nk) grantley purley
             #   kvmx64 dockerx64 v1000(nk) r1000(nk) x86 x86_64
ARM_ARCHS    # all ARM = ARMv5_ARCHS + ARMv7_ARCHS + ARMv7L_ARCHS + ARMv8_ARCHS
PPC_ARCHS    # powerpc ppc824x ppc853x ppc854x qoriq
i686_ARCHS   # evansport (Intel 32-bit, build arch: i686)
```

### ARM variants

```makefile
ARMv5_ARCHS  = 88f6281                                       # build arch: armv5
ARMv7_ARCHS  = armv7 alpine alpine4k armada370 armada375 \
               armada38x armadaxp monaco comcerto2k ...      # build arch: armv7
ARMv7L_ARCHS = hi3535                                        # build arch: armv7l
ARMv8_ARCHS  = aarch64 rtd1296 rtd1619b armada37xx ...       # build arch: aarch64
```

### Bitness groupings

```makefile
32bit_ARCHS = ARMv5_ARCHS + ARMv7_ARCHS + ARMv7L_ARCHS + i686_ARCHS + PPC_ARCHS
64bit_ARCHS = ARMv8_ARCHS + x64_ARCHS
```

### Generic & deprecated

```makefile
GENERIC_ARCHS  = armv7 aarch64 x64        # used by multi-arch packages
OLD_PPC_ARCHS  = powerpc ppc824x ppc853x ppc854x   # deprecated PowerPC
```

For the per-platform Synology model mapping, see [Model ↔ Architecture](model-architecture.md).

## Toolchain Versions

| Version | DSM | Status |
|---------|-----|--------|
| 7.2 | DSM 7.2+ | Current |
| 7.1 | DSM 7.0-7.1 | Supported |
| 6.2 | DSM 6.2 | Supported |
| 6.1 | DSM 6.0-6.1 | Limited |
| 5.2 | DSM 5.2 | Legacy |

## Model to Architecture Mapping

The Synology model ↔ platform/architecture mapping — with a family filter and a model search — now lives on its own page:

- [Reference: Model ↔ Architecture](model-architecture.md)

## Using Architecture Conditions

### In Makefiles

```makefile
# Only for 64-bit
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-64bit
endif

# Needs a 64-bit target (refuses 32-bit archs)
REQUIRE_64BIT = 1

# ARM-specific
ifeq ($(findstring $(ARCH),$(ARM_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-neon
endif
```

### In local.mk

```makefile
# Build only for these architectures
SUPPORTED_ARCHS = x64-7.2 aarch64-7.2
```

## Finding Your Architecture

### From DSM

1. Log into DSM web interface
2. Go to **Control Panel** > **Info Center** > **General**
3. Note the **CPU Model** and **Model Name**
4. Look up in the tables above

### From SSH

```bash
# Show kernel architecture
uname -m

# Show Synology platform (maps to architecture)
cat /proc/syno_platform

# Show CPU architecture details
cat /proc/syno_cpu_arch
```

### From Package Download

The package download page at [packages.synocommunity.com](https://packages.synocommunity.com) automatically detects your NAS architecture when accessed from the device.

## External References

- [Synology Product Compatibility](https://www.synology.com/compatibility)
- [Synology Archive](https://archive.synology.com/download/)
