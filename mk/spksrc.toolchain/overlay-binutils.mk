###############################################################################
# spksrc.toolchain/overlay-binutils.mk
#
# OVERLAY_BINUTILS: install a modern GNU binutils for this (arch, DSM) and route
# EVERY cross compilation through its as/ld -- not just rustc.
#
# It is the base layer of the OVERLAY_<component> family (with OVERLAY_RUSTC,
# overlay-rustc.mk). The ppc853x OVERLAY_RUSTC REQUIRES it: Rust's TLS/PIE output there
# is mishandled by the stock 2008 GNU ld 2.18. Standalone (OVERLAY_BINUTILS=1 with a
# matched modern gcc) is also valid -- a modern ld fixes the ppc853x dynamic-TPREL TLS
# bug for plain C too. 2.30 is the DSM-7.1/7.2 default; only legacy archs (glibc <= 2.20
# / DSM <= 6.2.4) need it.
#
# The binutils is PRODUCED by native/binutils-<ver> (co-build + publishable archive,
# `make -C native/binutils-<ver> arch-<arch>-<vers>`) and CONSUMED here by DOWNLOADING
# the published .txz through the per-arch consumer toolchain/syno-<arch>-<vers>-
# binutils<ver> (like the rust consumer) -- no per-build recompile in CI.
###############################################################################

# TWO distinct uses -- kept separate because a modern binutils is only safe under a MATCHED
# modern gcc:
#
#   OVERLAY_BINUTILS         GLOBAL: default as/ld for EVERY compilation (baked into tc_vars).
#                            Valid ONLY with a matched modern gcc; under a stock/vendor gcc a
#                            modern binutils rejects the vendor flags it emits (e.g. arm-marvell's
#                            -mcpu=marvell-f). Default OFF.
#
#   RUST_LINK_VIA_BINUTILS   NARROW: routes ONLY the Rust package link through the overlay ld;
#                            the C toolchain stays stock vendor gcc+ld. For archs whose stock ld
#                            breaks Rust but whose stock gcc emits standard flags (ppc853x).
#                            Default ON for every custom-rust arch.
#
# Both draw on the same downloaded binutils; they differ only in scope. The switches and
# their defaults live in spksrc.common/overlay.mk -- this file only consumes the outcome.

# The extracted cross tools (<target>-ld, <target>-as, ...), inside the CONSUMER's own work
# dir -- TC_OVERLAY_BINUTILS is that directory. Keeping each overlay self-contained is what
# lets two versions of one component coexist; only these pointers then decide which is used.
OVERLAY_BINUTILS_BIN      = $(TC_OVERLAY_BINUTILS)/work/install/usr/local/bin
# gcc invokes 'as'/'ld' UNPREFIXED via -B, but the tools are <target>-prefixed, so a shim dir
# carries unprefixed symlinks (built by the consumer's POST_INSTALL at $(WORK_DIR)/shim).
# Absolute, so the -B path baked into tc_vars is stable across checkouts.
OVERLAY_BINUTILS_SHIM     = $(TC_OVERLAY_BINUTILS)/work/shim
# GLOBAL redirect: appended to CFLAGS/CXXFLAGS/LDFLAGS/FFLAGS in tc_vars so every
# gcc-driven compile/link uses the overlay as/ld. ONLY for the matched-pair (modern-gcc) case
# -- empty for a rust-link-only arch, whose C builds keep the vendor as/ld.
# Only when the GLOBAL overlay is active: a -B into a shim that never gets built would
# silently leave every compile on the stock as/ld.
OVERLAY_BINUTILS_FLAG     = $(if $(OVERLAY_BINUTILS_ON),-B$(OVERLAY_BINUTILS_SHIM))

# `make clean` on a custom-rust base toolchain also cleans its downloaded consumers --
# the rust std (syno-<arch>-<vers>_rust-<vers>_gcc-<gcc>) and this binutils overlay
# (syno-<arch>-<vers>-binutils<vers>) -- so a rebuild re-extracts them fresh instead of
# reusing a stale extracted install. This only ADDS a prerequisite to the generic clean
# (recipe stays in spksrc.rules.mk); the consumers go through native-install.mk, not these gates, so
# they never recurse. Makes `make clean` in the base toolchain authoritative (CI no longer
# cleans each consumer by hand).
ifneq ($(strip $(TC_OVERLAY_RUSTC)),)
clean: clean-rust-consumers
.PHONY: clean-rust-consumers
clean-rust-consumers:
	@for d in $(TC_OVERLAY_RUSTC) $(TC_OVERLAY_BINUTILS) ; do \
	  if [ -d "$$d" ] ; then $(MSG) "clean consumer $$(basename $$d)" ; $(MAKE) --no-print-directory -C "$$d" clean ; fi ; \
	done
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
