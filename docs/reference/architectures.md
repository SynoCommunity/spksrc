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

spksrc identifies each Synology platform by its CPU codename (`apollolake`, `geminilake`, `rtd1296`, ...); these are grouped into the generic build architectures used to compile packages (`mk/spksrc.common/archs.mk`). The table below maps the common current platforms to their build architecture and example models.

For the authoritative CPU of a specific model, see Synology's [**What kind of CPU does my NAS have?**](https://www.synology.com/en-us/knowledgebase/DSM/tutorial/General/What_kind_of_CPU_does_my_NAS_have).

Use the controls to filter by build architecture or search for a platform or model:

<p>
  <label>Build arch:
    <select id="archFilter" onchange="filterArchTable()">
      <option value="">All</option>
      <option value="x64">x64 (Intel/AMD 64-bit)</option>
      <option value="aarch64">aarch64 (ARM 64-bit)</option>
    </select>
  </label>
  &nbsp;
  <input id="archSearch" type="text" placeholder="Search platform or model…" oninput="filterArchTable()" size="28">
</p>

<table id="archTable" markdown="0">
  <thead>
    <tr><th>Platform</th><th>Build arch</th><th>CPU</th><th>Integrated GPU</th><th>Example models</th></tr>
  </thead>
  <tbody>
    <tr data-arch="x64" data-gpu="yes"><td>geminilake</td><td>x64</td><td>Intel</td><td>Intel UHD Graphics 605 (Gen9.5)</td><td>DS224+, DS423+, DVA1622, DS220+, DS420+, DS720+, DS920+, DS1520+</td></tr>
    <tr data-arch="x64" data-gpu="yes"><td>apollolake</td><td>x64</td><td>Intel</td><td>Intel HD Graphics 500/505 (Gen9, Broxton)</td><td>DS620slim, DS1019+, DS218+, DS418play, DS718+, DS918+</td></tr>
    <tr data-arch="x64" data-gpu="no"><td>denverton</td><td>x64</td><td>Intel Atom C3000</td><td>—</td><td>DVA3221, RS820+, DS2419+, DS1819+, DVA3219, RS2818RP+, RS2418+, DS1618+</td></tr>
    <tr data-arch="x64" data-gpu="yes"><td>v1000</td><td>x64</td><td>AMD Ryzen</td><td>AMD Radeon Vega</td><td>FS2500, RS2423+, DS1823xs+, DS2422+, RS822+, RS2821RP+, RS2421+, RS1221+, DS1621+, DS1821+</td></tr>
    <tr data-arch="x64" data-gpu="yes"><td>r1000</td><td>x64</td><td>AMD Ryzen</td><td>AMD Radeon Vega</td><td>DS923+, DS723+, DS1522+, RS422+</td></tr>
    <tr data-arch="x64" data-gpu="no"><td>broadwell</td><td>x64</td><td>Intel Xeon-D</td><td>—</td><td>FS3400, FS2017, RS3618xs, RS18017xs+, RS4017xs+, RS3617xs+, DS3617xs</td></tr>
    <tr data-arch="x64" data-gpu="no"><td>avoton</td><td>x64</td><td>Intel Atom C2000</td><td>—</td><td>RS1219+, RS818+, DS1817+, DS1517+, RS2416+, DS415+, DS1515+, DS1815+, DS2415+, RS815+</td></tr>
    <tr data-arch="aarch64" data-gpu="no"><td>rtd1296</td><td>aarch64</td><td>Realtek</td><td>ARM Mali-T820 (not used for transcoding)</td><td>DS420j, DS220j, RS819, DS418j, DS418, DS218, DS218play, DS118</td></tr>
    <tr data-arch="aarch64" data-gpu="no"><td>armada37xx</td><td>aarch64</td><td>Marvell</td><td>—</td><td>DS120j, DS119j</td></tr>
  </tbody>
</table>

Hardware transcoding through the [SynoCli Video Driver](../packages/synocli-videodriver.md) targets **Intel iGPUs** (`apollolake`, `geminilake`); the AMD Radeon Vega (`v1000`/`r1000`) and ARM Mali GPUs are present but not driven by that Intel VA-API/QSV stack.

<script>
function filterArchTable() {
  var a = document.getElementById('archFilter').value.toLowerCase();
  var q = document.getElementById('archSearch').value.toLowerCase();
  document.querySelectorAll('#archTable tbody tr').forEach(function (r) {
    var okArch = !a || r.getAttribute('data-arch') === a;
    var okText = !q || r.textContent.toLowerCase().indexOf(q) >= 0;
    r.style.display = (okArch && okText) ? '' : 'none';
  });
}
</script>

Older PowerPC platforms (`powerpc`, `ppc824x`, `ppc853x`, `ppc854x`) and other legacy families are listed under [Architecture Groups](#architecture-groups). The complete platform-to-family mapping is defined in `mk/spksrc.common/archs.mk`.

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
