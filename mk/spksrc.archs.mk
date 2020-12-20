# Common arch definitions

# All available CPU architectures

# Distinct SRM and DSM archs to allow handling of different TCVERSION ranges.
# SRM - Synology Router Manager
SRM_ARM7_ARCHS = northstarplus ipq806x dakota
# DSM - all ARMv7 except SRM specific archs
DSM_ARM7_ARCHS = alpine armada370 armada375 armada38x armadaxp comcerto2k monaco

# Generic archs used for packages supporting multiple archs (where applicable)
GENERIC_ARMv7_ARCH = armv7
GENERIC_ARM64_ARCH = aarch64
GENERIC_x64_ARCH = x64
GENERIC_ARCHS = $(GENERIC_ARMv7_ARCH) $(GENERIC_ARM64_ARCH) $(GENERIC_x64_ARCH)

ARM5_ARCHS = 88f6281
ARM7_ARCHS = $(GENERIC_ARMv7_ARCH) $(DSM_ARM7_ARCHS) $(SRM_ARM7_ARCHS)
# hi3535 is not supported by generic ARMv7 arch
ARM7L_ARCHS = hi3535
ARM8_ARCHS = $(GENERIC_ARM64_ARCH) rtd1296 armada37xx
ARM_ARCHS = $(ARM5_ARCHS) $(ARM7_ARCHS) $(ARM7L_ARCHS) $(ARM8_ARCHS)

PPC_ARCHS = powerpc ppc824x ppc853x ppc854x qoriq

i686_ARCHS = evansport
x64_ARCHS = $(GENERIC_x64_ARCH) apollolake avoton braswell broadwell broadwellnk bromolow cedarview denverton dockerx64 geminilake grantley purley kvmx64 v1000 x86_64

# Arch groups
ALL_ARCHS = $(x64_ARCHS) $(i686_ARCHS) $(PPC_ARCHS) $(ARM_ARCHS)
ARCHS_WITH_GENERIC_SUPPORT = $(filter-out $(GENERIC_ARCHS), $(ARM7_ARCHS) $(ARM8_ARCHS) $(x64_ARCHS))
# PPC_ARCHS except qoriq
OLD_PPC_ARCHS = powerpc ppc824x ppc853x ppc854x

# outdated unsupported archs
OBSOLETE_ARCHS = powerpc ppc824x ppc854x x86
