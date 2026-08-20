###############################################################################
# spksrc.toolchain/overlay-binutils.mk
#
# OVERLAY_BINUTILS, consumer side: a modern GNU binutils for this (arch, DSM). Member of the
# OVERLAY_<component> family; the switches and their defaults are in spksrc.common/overlay.mk,
# this file applies them.
#
# Two scopes draw on the same download:
#   OVERLAY_BINUTILS        GLOBAL -- as/ld (and ar, nm, strip, ...) for every compilation,
#                           baked into tc_vars. Only safe under a MATCHED modern gcc: a modern
#                           binutils rejects vendor flags a stock gcc emits (arm-marvell's
#                           -mcpu=marvell-f). Off by default.
#   RUST_LINK_VIA_BINUTILS  NARROW -- only the Rust link, C keeps the vendor as/ld. For archs
#                           whose stock ld breaks Rust but whose gcc emits standard flags.
#                           ppc853x REQUIRES it: its 2008 ld 2.18 mishandles Rust's TLS/PIE.
#
# PRODUCED by native/binutils-<ver>, CONSUMED here by downloading the published .txz through
# toolchain/syno-<arch>-<dsm>_binutils-<ver>_gcc-<gcc> -- no per-build recompile in CI.
###############################################################################

# The extracted cross tools (<target>-ld, <target>-as, ...), inside the CONSUMER's own work
# dir -- TC_OVERLAY_BINUTILS is that directory. Keeping each overlay self-contained is what
# lets two versions of one component coexist; only these pointers then decide which is used.
OVERLAY_BINUTILS_BIN      = $(TC_OVERLAY_BINUTILS)/work/install/usr/local/bin
# gcc invokes 'as'/'ld' UNPREFIXED via -B, but the tools are <target>-prefixed, so a shim dir
# carries unprefixed symlinks (built by the consumer's POST_INSTALL at $(WORK_DIR)/shim).
# Absolute, so the -B path baked into tc_vars is stable across checkouts.
OVERLAY_BINUTILS_SHIM     = $(TC_OVERLAY_BINUTILS)/work/shim
# GLOBAL redirect, folded into CFLAGS/CXXFLAGS/LDFLAGS/FFLAGS by tc_vars. Empty unless the
# global overlay is active -- a -B into a shim that never gets built would silently leave
# every compile on the vendor as/ld.
OVERLAY_BINUTILS_FLAG     = $(if $(OVERLAY_BINUTILS_ON),-B$(OVERLAY_BINUTILS_SHIM))

# `make clean` on the base toolchain also cleans whichever overlay consumers it has, so a
# rebuild re-extracts them instead of reusing a stale install. Only ADDS a prerequisite to the
# generic clean; the consumers go through native-install.mk, so this never recurses. The last
# message labels the base's own rm, which the generic recipe prints unlabelled right after --
# otherwise it reads as a second pass over the last consumer.
ifneq ($(strip $(TC_OVERLAY_RUSTC))$(strip $(TC_OVERLAY_BINUTILS)),)
clean: clean-overlay-consumers
.PHONY: clean-overlay-consumers
clean-overlay-consumers:
	@for d in $(TC_OVERLAY_RUSTC) $(TC_OVERLAY_BINUTILS) ; do \
	  if [ -d "$$d" ] ; then $(MSG) "clean consumer $$(basename $$d)" ; $(MAKE) --no-print-directory -C "$$d" clean ; fi ; \
	done
	@$(MSG) "clean toolchain $(TC)"
endif


# Provision the binutils overlay as a normal DEPENDS: the consumer extracts the .txz and
# builds the as/ld shim in its POST_INSTALL (symmetric with the rust consumer).
ifeq ($(OVERLAY_BINUTILS_PROVISION),1)
DEPENDS += toolchain/$(notdir $(TC_OVERLAY_BINUTILS))
endif

# Report a degraded or risky state. Conditions AND wording both come from
# spksrc.common/overlay.mk; this only picks which one to print. Hung off tcvars (not _all):
# the switches are a PER-PACKAGE choice, and _all is skipped once the toolchain cookie exists.
.PHONY: overlay-binutils-warn
ifeq ($(OVERLAY_BINUTILS_VERSION_MISSING),1)
overlay-binutils-warn:
	@$(OVERLAY_WARN_BINUTILS_VERSION_MISSING)
else ifeq ($(OVERLAY_BINUTILS_MISSING),1)
overlay-binutils-warn:
	@$(OVERLAY_WARN_BINUTILS_MISSING)
else ifeq ($(OVERLAY_BINUTILS_ON),1)
overlay-binutils-warn:
	@$(OVERLAY_WARN_BINUTILS_UNMATCHED)
else
overlay-binutils-warn: ;
endif
