###############################################################################
# spksrc.toolchain/gcc-abi.mk
#
# Derive the target ABI configure flags for rebuilding a modern GCC, from the
# toolchain's OWN stock gcc -- the single source of truth -- plus the fixups a
# GCC >= 8 needs. Pure make: no table to maintain, no toolchain Makefile edits.
#
# Requires (set by spksrc.native-toolchain.mk before including this):
#   TC_EXTRACT_DIR  where tc-install lands the toolchain
#   TC_TARGET       target triple
# Provides:
#   GCC_TARGET_ABI
#
# Everything is lazy (=), so it resolves at use time -- once the toolchain is
# extracted, which is a build prerequisite.
#
# Fixups:
#   * --with-cpu present   -> drop --with-arch / --with-tune (GCC >= 8 rejects the combo)
#   * --with-cpu=marvell-f -> --with-arch=armv5te (unknown to mainline GCC)
#   * hard-float 32-bit ARM with no fpu -> --with-fpu=neon (Synology ARM is Cortex-A9+)
#   * powerpc SPE (-gnuspe triple)      -> --enable-obsolete (removed in GCC 9)
###############################################################################

_GCC_ABI_STOCK = $(TC_EXTRACT_DIR)/bin/$(TC_TARGET)-gcc
_GCC_ABI_RAW   = $(shell test -x $(_GCC_ABI_STOCK) && $(_GCC_ABI_STOCK) -v 2>&1 | tr ' ' '\n' | \
                   grep -iE '^--with-(arch|cpu|tune|float|fpu)=|^--enable-e500_double$$' | sort -u)

_GCC_ABI_ARCH  = $(filter --with-arch=%,$(_GCC_ABI_RAW))
_GCC_ABI_CPU   = $(filter --with-cpu=%,$(_GCC_ABI_RAW))
_GCC_ABI_FLOAT = $(filter --with-float=%,$(_GCC_ABI_RAW))
_GCC_ABI_FPU   = $(filter --with-fpu=%,$(_GCC_ABI_RAW))
_GCC_ABI_E500  = $(filter --enable-e500_double,$(_GCC_ABI_RAW))

# cpu wins over arch/tune; marvell-f is a vendor name mainline GCC does not know
_GCC_ABI_BASE = $(if $(_GCC_ABI_CPU),\
                  $(if $(findstring marvell-f,$(_GCC_ABI_CPU)),--with-arch=armv5te,$(_GCC_ABI_CPU)),\
                  $(_GCC_ABI_ARCH))
# The stock gcc does not always DECLARE its float ABI -- ppc853x-5.2's 2008 compiler leans
# on --with-cpu=8548 implying it, which a modern gcc no longer does. Fall back to what the
# toolchain asserts: getting this wrong is silent, and yields soft-float runtime libs
# against a hard-float glibc.
_GCC_ABI_TC_FLAGS = $(call _tc_get,TC_EXTRA_BUILD_FLAGS)
_GCC_ABI_FLOAT2   = $(or $(_GCC_ABI_FLOAT),\
                      $(if $(filter -mhard-float -mfloat-abi=hard,$(_GCC_ABI_TC_FLAGS)),--with-float=hard),\
                      $(if $(filter -msoft-float -mfloat-abi=soft,$(_GCC_ABI_TC_FLAGS)),--with-float=soft))

# The fpu, in order of authority: what the stock gcc declares, then what the toolchain
# tells packages to use, then a guess. No Synology ARM gcc declares one, and the guess
# alone used to say neon -- armada370/375/xp have none, so their libgcc and libstdc++ came
# out full of NEON that only faults on the device.
_GCC_ABI_TC_FPU = $(patsubst -mfpu=%,--with-fpu=%,$(filter -mfpu=%,$(_GCC_ABI_TC_FLAGS)))
# What the stock compiler DEFAULTS to: it answers even when it declares nothing, and it is
# the Synology gcc speaking. Every ARM toolchain lands here, answering "vfp" where
# TC_EXTRA_BUILD_FLAGS names something narrower -- vfp is what the vendor's own libgcc and
# libstdc++ were built with, and the overlay replaces exactly those.
# ARM only: a PowerPC gcc answers "none", which configure would take literally.
_GCC_ABI_DEF_FPU = $(if $(findstring arm,$(TC_TARGET)),$(patsubst %,--with-fpu=%,$(word 2,$(shell $(_GCC_ABI_STOCK) -Q --help=target 2>/dev/null | grep -E '^[[:space:]]+-mfpu=[[:space:]]'))))
# TC_EXTRA_BUILD_FLAGS is deliberately NOT consulted here, though it is the authority for
# compiling PACKAGES: it is per-model, and alpine's neon-vfpv4 would give this compiler a
# libstdc++ that no longer serves the generic armv7 arch every ARMv7 package builds through.
_GCC_ABI_FPU2 = $(or $(_GCC_ABI_FPU),$(_GCC_ABI_DEF_FPU),\
                  $(if $(and $(findstring hard,$(_GCC_ABI_FLOAT2)),$(findstring arm,$(TC_TARGET))),--with-fpu=neon))
_GCC_ABI_OBS  = $(if $(findstring gnuspe,$(TC_TARGET)),--enable-obsolete)

GCC_TARGET_ABI = $(strip $(_GCC_ABI_BASE) $(_GCC_ABI_FLOAT2) $(_GCC_ABI_FPU2) $(_GCC_ABI_E500) $(_GCC_ABI_OBS))
