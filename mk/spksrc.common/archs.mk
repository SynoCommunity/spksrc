###############################################################################
# mk/spksrc.common/archs.mk
#
# Defines architecture and toolchain classification variables for spksrc.
#
# This file:
#  - detects available toolchains and kernel versions
#  - defines CPU architecture groupings
#  - applies architecture exclusions for specific build scenarios
#
# Variables:
#  AVAILABLE_TOOLCHAINS        : detected toolchains ({ARCH}-{TC})
#  AVAILABLE_TCVERSIONS        : detected toolchain versions
#  AVAILABLE_KERNEL            : detected kernel toolchains
#
#  ARM_ARCHS, x64_ARCHS,
#  PPC_ARCHS, i686_ARCHS       : architecture families
#  ARMv5, ARMv7, ARMv8         : ARM variants
#  32bit_ARCHS, 64bit_ARCHS    : bitness groupings
#
#  SUPPORTED_ARCHS             : fully supported architectures
#  LATEST_ARCHS                : latest toolchain per architecture
#  LEGACY_ARCHS                : non-generic, legacy architectures
#
# Notes:
#  - BASEDIR is auto-detected when not explicitly set
#  - Generic architectures are used where multi-arch support exists
#  - Dotnet-related exclusions are handled conditionally
#
###############################################################################

# Allows direct inclusion for backward compatibility
ifeq ($(BASEDIR),)
ifeq ($(filter spksrc workspace,$(shell basename $(CURDIR))),)
BASEDIR = ../../
endif
endif

###

# Available toolchains formatted as '{ARCH}-{TC}'
AVAILABLE_TOOLCHAINS = $(subst syno-,,$(filter-out %-rust,$(sort $(notdir $(wildcard $(BASEDIR)toolchain/syno-*)))))
AVAILABLE_TCVERSIONS = $(sort $(foreach arch,$(AVAILABLE_TOOLCHAINS),$(shell echo ${arch} | cut -f2 -d'-')))

# Available toolchains formatted as '{ARCH}-{TC}'
AVAILABLE_KERNEL = $(subst syno-,,$(sort $(notdir $(wildcard $(BASEDIR)kernel/syno-*))))
AVAILABLE_KERNEL_VERSIONS = $(sort $(foreach arch,$(AVAILABLE_KERNEL),$(shell echo ${arch} | cut -f2 -d'-')))

###

# All available CPU architectures

# Distinct SRM and DSM archs to allow handling of different TCVERSION ranges.
# SRM - Synology Router Manager
SRM_ARMv7_ARCHS = northstarplus ipq806x dakota hawkeye
SRM_ARMv8_ARCHS = cypress
# required in spksrc.pre-check.mk
SRM_ARCHS = $(SRM_ARMv7_ARCHS) $(SRM_ARMv8_ARCHS)

# DSM - all ARMv7 except SRM specific archs
DSM_ARMv7_ARCHS = alpine alpine4k armada370 armada375 armada38x armadaxp monaco
# comcerto2k is the only ARMv7 arch that uses an GCC (4.9.3) and GLIBC (2.20)
DSM_ARMv7_ARCHS += comcerto2k

# Generic archs used for packages supporting multiple archs (where applicable)
GENERIC_ARMv7_ARCH = armv7
GENERIC_ARMv8_ARCH = aarch64
GENERIC_x64_ARCH = x64
GENERIC_ARCHS = $(GENERIC_ARMv7_ARCH) $(GENERIC_ARMv8_ARCH) $(GENERIC_x64_ARCH)

ARMv5_ARCHS = 88f6281
ARMv7_ARCHS = $(GENERIC_ARMv7_ARCH) $(DSM_ARMv7_ARCHS) $(SRM_ARMv7_ARCHS)
# hi3535 is not supported by generic ARMv7 arch
ARMv7L_ARCHS = hi3535
ARMv8_ARCHS = $(GENERIC_ARMv8_ARCH) $(SRM_ARMv8_ARCHS) rtd1296 rtd1619b armada37xx
ARM_ARCHS = $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(ARMv8_ARCHS)

PPC_ARCHS = powerpc ppc824x ppc853x ppc854x qoriq

i686_ARCHS = evansport
x64_ARCHS = $(GENERIC_x64_ARCH) apollolake avoton braswell broadwell broadwellnk broadwellnkv2 broadwellntbap bromolow cedarview denverton dockerx64 epyc7002 geminilake geminilakenk grantley purley kvmx64 v1000 v1000nk r1000 r1000nk x86 x86_64

32bit_ARCHS = $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS) $(PPC_ARCHS)
64bit_ARCHS = $(ARMv8_ARCHS) $(x64_ARCHS)

# Arch groups
ALL_ARCHS = $(x64_ARCHS) $(i686_ARCHS) $(PPC_ARCHS) $(ARM_ARCHS)
ARCHS_WITH_GENERIC_SUPPORT = $(sort $(foreach version, $(AVAILABLE_TCVERSIONS), $(foreach arch, $(GENERIC_ARCHS), $(addsuffix -$(version),$(shell sed -n 's/^TC_ARCH = \(.*\)/\1/p' $(BASEDIR)toolchain/syno-$(arch)-$(version)/Makefile 2>/dev/null)))))
# PPC_ARCHS except qoriq
OLD_PPC_ARCHS = powerpc ppc824x ppc853x ppc854x

# outdated unsupported archs
DEPRECATED_ARCHS = powerpc ppc824x ppc854x ppc853x

# Notes for .NET 6 compatibility:
# 1. dotnet for x86 (32-bit) is unsupported on linux and must be built from source
# 2. ARMv7_ARCHS without full vfpv3 support (having only vfpv3-d16) are not supported
# 3. SRM ARMv7 archs are not supported
# 4. Certain combinations of ARMv7 and DSM are incompatible (issues #4790, #5089, #5302, #5315)
# 5. Comprehensive ARMv7 testing conducted under issue #5574 resulted in the following exclusions

# Exclusions for dotnet core apps
ifeq ($(strip $(DOTNET_CORE_ARCHS)),1)
    UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS) armada370 alpine comcerto2k
    UNSUPPORTED_ARCHS_TCVERSION = armv7-6.2.4 armv7-1.2 armv7-1.3
endif

# Exclusions for dotnet 6.0 servarr apps (except x86)
ifeq ($(strip $(DOTNET_SERVARR_ARCHS)),1)
    UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) armada370 alpine comcerto2k
    UNSUPPORTED_ARCHS_TCVERSION = armv7-6.2.4 armv7-1.2 armv7-1.3
endif

# Exclusions for dotnet 6.0 servarr apps (except x86)
# ARMv7 incompatibility — see: https://github.com/dotnet/runtime/issues/109739
ifeq ($(strip $(DOTNET_SERVARR_ARCHS)),2)
    UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(ARMv7_ARCHS)
endif

# Filter to exclude TC versions greater than DEFAULT_TC (from local configuration)
TCVERSION_DUPES = $(addprefix %,$(filter-out $(DEFAULT_TC),$(AVAILABLE_TCVERSIONS)))

# remove unsupported (outdated) archs
ARCHS_DUPES_DEPRECATED += $(addsuffix %,$(DEPRECATED_ARCHS))

# Filter for all-supported
ARCHS_DUPES = $(ARCHS_WITH_GENERIC_SUPPORT) $(ARCHS_DUPES_DEPRECATED) $(TCVERSION_DUPES)

# supported: used for all-supported target
SUPPORTED_ARCHS = $(sort $(filter-out $(ARCHS_DUPES), $(AVAILABLE_TOOLCHAINS)))

# default: used for all-latest target
LATEST_ARCHS = $(foreach arch,$(sort $(basename $(subst -,.,$(basename $(subst .,,$(SUPPORTED_ARCHS)))))),$(arch)-$(notdir $(subst -,/,$(sort $(filter %$(lastword $(notdir $(subst -,/,$(sort $(filter $(arch)%, $(AVAILABLE_TOOLCHAINS)))))),$(sort $(filter $(arch)%, $(AVAILABLE_TOOLCHAINS))))))))

# legacy: used for all-legacy and when kernel support is used
#         all archs except generic archs
LEGACY_ARCHS = $(sort $(filter-out $(addsuffix %,$(GENERIC_ARCHS)), $(AVAILABLE_TOOLCHAINS)))
