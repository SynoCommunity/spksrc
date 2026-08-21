###############################################################################
# spksrc.toolchain/overlay-gcc.mk
#
# OVERLAY_GCC, consumer side: a modern gcc for this (arch, DSM), installed BESIDE the
# vendor one and picked by version suffix. Member of the OVERLAY_<component> family; the
# switches and their defaults are in spksrc.common/overlay.mk, this file applies them.
#
# The overlay ships NO as/ld of its own -- those come from OVERLAY_BINUTILS through -B,
# which is why overlay.mk makes gcc require it. One archive per component, composed at
# use time: that is what lets a gcc be rebuilt without touching binutils, and vice versa.
#
# PRODUCED by native/gcc-<vers>, CONSUMED here by downloading the published .txz through
# toolchain/syno-<arch>-<dsm>_gcc-<vers>_gcc-<base> -- no per-build recompile in CI.
###############################################################################

# The extracted compilers (<target>-gcc-8.5, <target>-g++-8.5, ...), inside the CONSUMER's
# own work dir. Self-contained like the other overlays, so two gcc versions can coexist
# and only the pointers below decide which one a build sees.
OVERLAY_GCC_BIN = $(TC_OVERLAY_GCC)/work/install/usr/local/bin

# Which gcc a build uses. The suffix tc_vars appends to the gcc-family drivers only
# (cc/cxx/cpp/fc); binutils tools keep their plain names.
#
# Discovered by wildcard rather than declared, so a future gcc-12 overlay needs no change
# here -- OVERLAY_GCC_VERS already picked the directory, this just reads what is in it.
#
# Pairing gcc-<v> with a matching g++-<v> is what does the work: an archive ships both
# gcc-8.5 and gcc-8.5.0 while g++ exists only as g++-8.5, and a stock toolchain ships a
# versioned gcc alias but never a versioned g++. Pairing leaves exactly one answer.
#
# Lazy (=): the bin dir only exists once the consumer has been extracted.
_OVERLAY_GCC_PREFIX = $(OVERLAY_GCC_BIN)/$(TC_PREFIX)
_OVERLAY_GCC_FOUND  = $(patsubst $(_OVERLAY_GCC_PREFIX)gcc-%,%,$(wildcard $(_OVERLAY_GCC_PREFIX)gcc-[0-9]*))
_OVERLAY_GCC_PAIRED = $(foreach v,$(_OVERLAY_GCC_FOUND),$(if $(wildcard $(_OVERLAY_GCC_PREFIX)g++-$(v)),$(v)))
OVERLAY_GCC_SUFFIX  = $(if $(OVERLAY_GCC_ON),$(if $(_OVERLAY_GCC_PAIRED),-$(firstword $(_OVERLAY_GCC_PAIRED))))

# The gcc-family drivers, the ones the suffix applies to. Everything else tc_vars emits
# (ar, nm, strip, ...) is a binutils tool and belongs to the other overlay.
TC_GCC_TOOLS = gcc g++ cpp gfortran

# Provision the gcc overlay as a normal DEPENDS, symmetric with the binutils consumer.
ifeq ($(OVERLAY_GCC_ON),1)
DEPENDS += toolchain/$(notdir $(TC_OVERLAY_GCC))
endif

# Provision at tcvars time, not only through the toolchain's DEPENDS above: _all is skipped
# once the toolchain cookie exists, so a package that switches OVERLAY_GCC on afterwards
# would otherwise have tc_vars point at a consumer that was never extracted -- and the
# version suffix, read by wildcard from that directory, would come back empty.
.PHONY: overlay-gcc-install
ifeq ($(OVERLAY_GCC_ON),1)
overlay-gcc-install:
	@$(MAKE) --no-print-directory -C $(TC_OVERLAY_GCC)
else
overlay-gcc-install: ;
endif

# Report a degraded state. Conditions AND wording both come from spksrc.common/overlay.mk;
# this only picks which one to print. Hung off tcvars like the other two: the switches are
# a PER-PACKAGE choice, and _all is skipped once the toolchain cookie exists.
.PHONY: overlay-gcc-warn
ifeq ($(OVERLAY_BINUTILS_FORCED),1)
overlay-gcc-warn:
	@$(OVERLAY_WARN_BINUTILS_FORCED)
else ifeq ($(OVERLAY_GCC_VERSION_MISSING),1)
overlay-gcc-warn:
	@$(OVERLAY_WARN_GCC_VERSION_MISSING)
else ifeq ($(OVERLAY_GCC_NO_BINUTILS),1)
overlay-gcc-warn:
	@$(OVERLAY_WARN_GCC_NO_BINUTILS)
else
overlay-gcc-warn: ;
endif
