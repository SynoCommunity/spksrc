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
# Both draw on the same downloaded binutils (below); they differ only in scope.
OVERLAY_BINUTILS       ?= 0
OVERLAY_BINUTILS_VERS  ?= 2.30

# RUST_LINK_VIA_BINUTILS defaults ON for every custom-rust arch (TC_OVERLAY_RUSTC): the
# from-source rustc link is routed through the binutils 2.30 overlay -- NARROW (rust link only;
# C keeps the stock vendor as/ld), unlike the GLOBAL OVERLAY_BINUTILS. Overridable per toolchain/CLI.
ifneq ($(strip $(TC_OVERLAY_RUSTC)),)
RUST_LINK_VIA_BINUTILS ?= 1
endif

# The extracted cross tools (<target>-ld, <target>-as, ...). As a DEPENDS the consumer's
# WORK_DIR propagates to the base toolchain work dir (TC_WORK_DIR), so its .txz unpacks
# usr/local/{bin,...} into TC_WORK_DIR/install (consumer EXTRACT_PATH = INSTALL_DIR).
OVERLAY_BINUTILS_BIN      = $(TC_WORK_DIR)/install/usr/local/bin
# gcc invokes 'as'/'ld' UNPREFIXED via -B, but the tools are <target>-prefixed, so a shim
# dir carries unprefixed symlinks (built by the consumer's POST_INSTALL at $(WORK_DIR)/shim =
# TC_WORK_DIR/shim). Absolute, so the -B path baked into tc_vars is stable across checkouts.
OVERLAY_BINUTILS_SHIM     = $(TC_WORK_DIR)/shim
# GLOBAL redirect: appended to CFLAGS/CXXFLAGS/LDFLAGS/FFLAGS in tc_vars so every
# gcc-driven compile/link uses the overlay as/ld. ONLY for the matched-pair (modern-gcc) case
# -- empty for a rust-link-only arch, whose C builds keep the vendor as/ld.
OVERLAY_BINUTILS_FLAG     = $(if $(filter 1,$(OVERLAY_BINUTILS)),-B$(OVERLAY_BINUTILS_SHIM))

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

# Provision the binutils (download the consumer + build the shim) when EITHER use needs
# it: the global overlay (matched modern gcc) or the narrow rust-link overlay (default ON for every
# custom-rustc arch, set just above). Resolved here, before overlay-rustc.mk consumes it.
_OVERLAY_BINUTILS_NEEDED := $(if $(filter 1,$(OVERLAY_BINUTILS))$(filter 1,$(RUST_LINK_VIA_BINUTILS)),1)

# Provision the binutils overlay as a normal DEPENDS: the consumer extracts the .txz and
# builds the as/ld shim in its POST_INSTALL (symmetric with the rust consumer). Gated on the
# NEED (OVERLAY_BINUTILS=1 or the rust link), not on wildcard existence. Skipped during a
# native-toolchain extract (the rust producer co-builds its own build-time ld).
ifeq ($(_OVERLAY_BINUTILS_NEEDED),1)
ifneq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
DEPENDS += toolchain/$(notdir $(TC_OVERLAY_BINUTILS))
endif
endif
