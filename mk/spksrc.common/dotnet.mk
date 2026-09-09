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
# Selected for a package built with the dotnet SDK by spksrc.cross-dotnet.mk itself:
#   DOTNET_BUILD_ARCHS  = 1   the archs dotnet has no runtime port for
###############################################################################

# dotnet is absent here for four different reasons, so the reason is picked by the arch at
# hand: one umbrella line would misdescribe most of a list that is not homogeneous.
# First match wins, most specific first.
_dotnet_why = $(strip $(or \
  $(if $(filter $(ARCH)-$(TCVERSION),armv7-6.2.4 armv7-1.2 armv7-1.3),dotnet is incompatible with this arch/DSM pair (issues #4790 #5089 #5302 #5315)),\
  $(if $(filter $(ARCH),armada370),dotnet needs full vfpv3 and this toolchain is vfpv3-d16),\
  $(if $(filter $(ARCH),alpine),dotnet segfaults on this arch despite capable silicon (issue #5302)),\
  $(if $(filter $(ARCH),comcerto2k),dotnet is incompatible with this arch (issue #5574)),\
  $(if $(filter $(ARCH),$(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS)),dotnet has no runtime port for this arch)))

# Servarr 2 refuses every ARMv7, capable silicon included, on a .NET 6.0 runtime segfault
# rather than a missing port -- its own ground, and it takes precedence over the map above.
_dotnet_why_servarr2 = $(or $(if $(filter $(ARCH),$(ARMv7_ARCHS)),dotnet 6.0 segfaults on ARMv7 (dotnet/runtime#109739)),$(_dotnet_why))

# Anything built with the dotnet SDK; spksrc.cross-dotnet.mk sets this before it includes
# spksrc.common.mk. Narrower than the app lists below: only the archs with no runtime port.
ifeq ($(strip $(DOTNET_BUILD_ARCHS)),1)
    UNSUPPORTED_ARCHS += $(PPC_ARCHS) $(ARMv5_ARCHS) $(i686_ARCHS) $(ARMv7L_ARCHS)
    UNSUPPORTED_ARCHS_REASON := $(_dotnet_why)
endif

# Exclusions for dotnet core apps
ifeq ($(strip $(DOTNET_CORE_ARCHS)),1)
    UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(i686_ARCHS) armada370 alpine comcerto2k
    UNSUPPORTED_ARCHS_TCVERSION = armv7-6.2.4 armv7-1.2 armv7-1.3
    UNSUPPORTED_ARCHS_REASON := $(_dotnet_why)
endif

# Exclusions for dotnet 6.0 servarr apps (except x86)
ifeq ($(strip $(DOTNET_SERVARR_ARCHS)),1)
    UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) armada370 alpine comcerto2k
    UNSUPPORTED_ARCHS_TCVERSION = armv7-6.2.4 armv7-1.2 armv7-1.3
    UNSUPPORTED_ARCHS_REASON := $(_dotnet_why)
endif

# Exclusions for dotnet 6.0 servarr apps (except x86)
# ARMv7 incompatibility -- see: https://github.com/dotnet/runtime/issues/109739
ifeq ($(strip $(DOTNET_SERVARR_ARCHS)),2)
    UNSUPPORTED_ARCHS = $(PPC_ARCHS) $(ARMv5_ARCHS) $(ARMv7L_ARCHS) $(ARMv7_ARCHS)
    UNSUPPORTED_ARCHS_REASON := $(_dotnet_why_servarr2)
endif
