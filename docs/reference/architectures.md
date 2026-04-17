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

spksrc defines groups for conditional logic:

### 64-bit Architectures
```makefile
64bit_ARCHS = x64 aarch64 armv8
```

### 32-bit Architectures
```makefile
32bit_ARCHS = x86 armv7 armv7l qoriq comcerto2k ppc853x
```

### ARM Architectures
```makefile
ARM_ARCHS = aarch64 armv8 armv7 armv7l
ARMv7_ARCHS = armv7 armv7l
ARMv8_ARCHS = aarch64 armv8
```

### Intel Architectures
```makefile
x64_ARCHS = x64
x86_ARCHS = x86
```

## Toolchain Versions

| Version | DSM | Status |
|---------|-----|--------|
| 7.2 | DSM 7.2+ | Current |
| 7.1 | DSM 7.0-7.1 | Supported |
| 6.2 | DSM 6.2 | Supported |
| 6.1 | DSM 6.0-6.1 | Limited |
| 5.2 | DSM 5.2 | Legacy |

## Model to Architecture Mapping

### Plus Series (Performance Models)

| Model | Architecture | DSM Support |
|-------|--------------|-------------|
| DS224+ | aarch64 | 7.x |
| DS423+ | aarch64 | 7.x |
| DS723+ | aarch64 | 7.x |
| DS923+ | x64 | 7.x |
| DS1522+ | x64 | 7.x |
| DS1823xs+ | x64 | 7.x |
| DS220+ | aarch64 | 7.x |
| DS720+ | aarch64 | 7.x |
| DS920+ | aarch64 | 7.x |
| DS1520+ | aarch64 | 7.x |
| DS1621+ | x64 | 7.x |
| DS1821+ | x64 | 7.x |
| DS3622xs+ | x64 | 7.x |

### Value Series

| Model | Architecture | DSM Support |
|-------|--------------|-------------|
| DS223 | armv8 | 7.x |
| DS423 | armv8 | 7.x |
| DS224 | armv8 | 7.x |
| DS218 | armv8 | 6.x-7.x |
| DS418 | armv8 | 6.x-7.x |
| DS118 | armv8 | 6.x-7.x |

### J Series (Budget Models)

| Model | Architecture | DSM Support |
|-------|--------------|-------------|
| DS223j | armv8 | 7.x |
| DS220j | armv8 | 7.x |
| DS218j | armv7 | 6.x-7.x |
| DS216j | armv7 | 6.x |
| DS115j | armv7l | 6.x |

### RackStation

| Model | Architecture | DSM Support |
|-------|--------------|-------------|
| RS1221+ | x64 | 7.x |
| RS422+ | armv8 | 7.x |
| RS1619xs+ | x64 | 7.x |
| RS3618xs | x64 | 7.x |
| RS820+ | x64 | 7.x |
| RS2821RP+ | x64 | 7.x |

### FlashStation

| Model | Architecture | DSM Support |
|-------|--------------|-------------|
| FS2500 | x64 | 7.x |
| FS6400 | x64 | 7.x |

## Using Architecture Conditions

### In Makefiles

```makefile
# Only for 64-bit
ifeq ($(findstring $(ARCH),$(64bit_ARCHS)),$(ARCH))
CONFIGURE_ARGS += --enable-64bit
endif

# Exclude 32-bit
UNSUPPORTED_ARCHS = $(32bit_ARCHS)

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
