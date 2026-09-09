###############################################################################
# spksrc.common/dotnet.mk
#
# Which architectures a dotnet package refuses, and why. Included for every
# package (spksrc.common.mk), because the consumers are spk/ packages that
# include spksrc.spk.mk and never see spksrc.cross/env-dotnet.mk.
#
# Selected by the package:
#   DOTNET_CORE_ARCHS   = 1   a dotnet core app
#   DOTNET_SERVARR_ARCHS= 1   a dotnet 6.0 servarr app
#   DOTNET_SERVARR_ARCHS= 2   ... one hitting the ARMv7 runtime bug
#
# Notes for .NET 6 compatibility:
# 1. dotnet for x86 (32-bit) is unsupported on linux and must be built from source
# 2. ARMv7_ARCHS without full vfpv3 support (having only vfpv3-d16) are not supported
# 3. SRM ARMv7 archs are not supported
# 4. Certain combinations of ARMv7 and DSM are incompatible (issues #4790, #5089, #5302, #5315)
# 5. Comprehensive ARMv7 testing conducted under issue #5574 resulted in the following exclusions
#
# The cross/ side of the same story is in spksrc.cross/env-dotnet.mk, which the
# dotnet build environment pulls in; it excludes on the same grounds.
###############################################################################

# Exclusions for dotnet core apps
ifeq ($(strip $(DOTNET_CORE_ARCHS)),1)
    UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS) armada370 alpine comcerto2k
    UNSUPPORTED_ARCHS_TCVERSION = armv7-6.2.4 armv7-1.2 armv7-1.3
    UNSUPPORTED_ARCHS_REASON := dotnet core ships no runtime for this arch
endif

# Exclusions for dotnet 6.0 servarr apps (except x86)
ifeq ($(strip $(DOTNET_SERVARR_ARCHS)),1)
    UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) armada370 alpine comcerto2k
    UNSUPPORTED_ARCHS_TCVERSION = armv7-6.2.4 armv7-1.2 armv7-1.3
    UNSUPPORTED_ARCHS_REASON := dotnet 6.0 servarr ships no runtime for this arch
endif

# Exclusions for dotnet 6.0 servarr apps (except x86)
# ARMv7 incompatibility -- see: https://github.com/dotnet/runtime/issues/109739
ifeq ($(strip $(DOTNET_SERVARR_ARCHS)),2)
    UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(ARMv7_ARCHS)
    UNSUPPORTED_ARCHS_REASON := dotnet 6.0 servarr on ARMv7: dotnet/runtime#109739
endif
