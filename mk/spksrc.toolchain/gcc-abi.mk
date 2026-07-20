###############################################################################
# spksrc.toolchain/gcc-abi.mk
#
# Derive the target ABI configure flags for rebuilding a modern GCC, from the
# toolchain's OWN stock gcc (the single source of truth) + the fixups a recent
# GCC (>= 8) needs. Pure make; no table, no toolchain Makefile edits.
#
# Requires (set by spksrc.native-toolchain.mk before including this):
#   TC_WORK    = <toolchain>/work/<triple>
#   TC_TARGET  = target triple
# Provides:
#   GCC8_TARGET_ABI
#
# Everything is lazy (=) so it resolves at use time, once the toolchain is
# extracted (a build prerequisite).
#
# Fixups:
#   * --with-cpu present  -> drop --with-arch / --with-tune (GCC>=8 rejects the combo)
#   * --with-cpu=marvell-f-> --with-arch=armv5te (unknown to mainline GCC)
#   * hard-float 32-bit ARM without an fpu -> add --with-fpu=neon (Synology ARM = Cortex-A9+)
#   * powerpc SPE (-gnuspe / e500 triple)  -> add --enable-obsolete (removed in GCC 9)
###############################################################################

_GCC_ABI_STOCK = $(TC_WORK)/bin/$(TC_TARGET)-gcc
_GCC_ABI_RAW   = $(shell test -x $(_GCC_ABI_STOCK) && $(_GCC_ABI_STOCK) -v 2>&1 | tr ' ' '\n' | \
                   grep -iE '^--with-(arch|cpu|tune|float|fpu)=|^--enable-e500_double$$' | sort -u)

_GCC_ABI_ARCH  = $(filter --with-arch=%,$(_GCC_ABI_RAW))
_GCC_ABI_CPU   = $(filter --with-cpu=%,$(_GCC_ABI_RAW))
_GCC_ABI_FLOAT = $(filter --with-float=%,$(_GCC_ABI_RAW))
_GCC_ABI_FPU   = $(filter --with-fpu=%,$(_GCC_ABI_RAW))
_GCC_ABI_E500  = $(filter --enable-e500_double,$(_GCC_ABI_RAW))

# base: cpu wins over arch/tune; marvell-f -> armv5te
_GCC_ABI_BASE = $(if $(_GCC_ABI_CPU),\
                  $(if $(findstring marvell-f,$(_GCC_ABI_CPU)),--with-arch=armv5te,$(_GCC_ABI_CPU)),\
                  $(_GCC_ABI_ARCH))
# fpu: keep the stock one, else default neon for hard-float 32-bit ARM
_GCC_ABI_FPU2 = $(if $(_GCC_ABI_FPU),$(_GCC_ABI_FPU),\
                  $(if $(and $(findstring hard,$(_GCC_ABI_FLOAT)),$(findstring arm,$(TC_TARGET))),--with-fpu=neon))
# SPE obsolete
_GCC_ABI_OBS  = $(if $(findstring gnuspe,$(TC_TARGET)),--enable-obsolete)

GCC8_TARGET_ABI = $(strip $(_GCC_ABI_BASE) $(_GCC_ABI_FLOAT) $(_GCC_ABI_FPU2) $(_GCC_ABI_E500) $(_GCC_ABI_OBS))
