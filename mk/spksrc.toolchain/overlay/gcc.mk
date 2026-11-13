###############################################################################
# spksrc.toolchain/overlay/gcc.mk
#
# OVERLAY_GCC, consumer side: a modern gcc for this (arch, DSM), installed BESIDE the vendor
# one and picked by version suffix. Member of the OVERLAY_<component> family; the switches
# and their defaults are in spksrc.common/overlay.mk, this file applies them.
#
# The overlay ships NO as/ld of its own -- those come from the binutils overlay through -B,
# which is why spksrc.common/overlay/gcc.mk makes gcc require it. One archive per component,
# composed at use time: that is what lets a gcc be rebuilt without touching binutils, and
# vice versa.
#
# Where its drivers are (TC_OVERLAY_GCC_PATH) and the suffix they carry (TC_GCC_SUFFIX) are
# written by spksrc.toolchain/tc_vars.mk, beside the toolchain's own TC_PATH; the flags that
# put its headers and runtimes in front by spksrc.toolchain/tc-flags.mk.
#
# PRODUCED by native/gcc-<version>, CONSUMED here by downloading the published .txz through
# overlay/syno-<arch>-<dsm>_gcc-<version> -- no per-build recompile in CI.
###############################################################################

# Installed at tcvars time too, as overlay-binutils-install is: after it, since the gcc
# overlay links its as/ld at install time. The tc_vars files wait for both -- TC_HAS_FORTRAN
# looks for the overlay's gfortran -- because tcvars runs under the caller's jobserver.
.PHONY: overlay-gcc-install
overlay-gcc-install: overlay-binutils-install
	@$(if $(_OVERLAY_GCC_ON),MAKEFLAGS= $(MAKE) --no-print-directory -C $(firstword $(_OVERLAY_GCC_DIR)),:)
generate_tc_vars_mk generate_tc_vars_other: overlay-gcc-install

# Report a degraded state. Conditions AND wording both come from spksrc.common/overlay.mk;
# this only picks which one to print. Hung off tcvars like the other components: the
# switches are a PER-PACKAGE choice, and _all is skipped once the toolchain cookie exists.
.PHONY: overlay-gcc-warn
overlay-gcc-warn:
	@$(call overlay_warn,GCC,VERSION_MISSING NO_BINUTILS)
