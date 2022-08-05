# Common arch definitions

# All available CPU architectures

# Distinct SRM and DSM archs to allow handling of different TCVERSION ranges.
# SRM - Synology Router Manager
SRM_ARMv7_ARCHS = northstarplus ipq806x dakota
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
ARMv8_ARCHS = $(GENERIC_ARMv8_ARCH) rtd1296 armada37xx
ARM_ARCHS = $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(ARMv8_ARCHS)

PPC_ARCHS = powerpc ppc824x ppc853x ppc854x qoriq

i686_ARCHS = evansport
x64_ARCHS = $(GENERIC_x64_ARCH) apollolake avoton braswell broadwell broadwellnk bromolow cedarview denverton dockerx64 geminilake grantley purley kvmx64 v1000 x86 x86_64

32bit_ARCHS = $(ARMv5_ARCHS) $(ARMv7_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS) $(PPC_ARCHS)
64bit_ARCHS = $(ARMv8_ARCHS) $(x64_ARCHS)

# Arch groups
ALL_ARCHS = $(x64_ARCHS) $(i686_ARCHS) $(PPC_ARCHS) $(ARM_ARCHS)
ARCHS_WITH_GENERIC_SUPPORT = $(sort $(foreach version, $(AVAILABLE_TCVERSIONS), $(foreach arch, $(GENERIC_ARCHS), $(addsuffix -$(version),$(shell sed -n 's/^TC_ARCH = \(.*\)/\1/p' ../../toolchain/syno-$(arch)-$(version)/Makefile 2>/dev/null)))))
# PPC_ARCHS except qoriq
OLD_PPC_ARCHS = powerpc ppc824x ppc853x ppc854x

# outdated unsupported archs
DEPRECATED_ARCHS = powerpc ppc824x ppc854x ppc853x

DOTNET_UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) 
# .NET for x86 (32-bit) is supported on windows only (for linux, it must be built from source)
DOTNET_UNSUPPORTED_ARCHS += $(i686_ARCHS)
# issue #5315
DOTNET_UNSUPPORTED_ARCHS += armada370
# issue #5302
DOTNET_UNSUPPORTED_ARCHS += alpine
# issue #5089
DOTNET_UNSUPPORTED_ARCHS += monaco
# issue #4790
DOTNET_UNSUPPORTED_ARCHS += armadaxp

# compatibility with .NET not yet confirmed:
# alpine4k armada375 armada38x comcerto2k
