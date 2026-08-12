###############################################################################
# spksrc.toolchain/overlay-binutils.mk
#
# OVERLAY_BINUTILS: install a modern GNU binutils for this (arch, DSM) and route
# EVERY cross compilation through its as/ld -- not just rustc.
#
# It is the base layer of the OVERLAY_<component> family:
#   OVERLAY_BINUTILS  modern as/ld for all packages on the arch   (this file)
#   OVERLAY_RUSTC     custom from-source rustc                    (rustc.mk)
#   OVERLAY_GCC       gcc-8.5                                     (future, native/gcc8)
# OVERLAY_GCC and the ppc853x OVERLAY_RUSTC both REQUIRE OVERLAY_BINUTILS (gcc-8.5 emits
# relocations, and Rust's TLS/PIE output on ppc853x, that the stock vendor ld -- 2008
# GNU ld 2.18 on ppc853x -- and LLVM lld both mishandle). Standalone (OVERLAY_BINUTILS=1
# with the stock gcc) is also valid: a modern ld fixes e.g. the ppc853x dynamic-TPREL
# TLS bug for plain C too. 2.30 is the DSM-7.1/7.2 default (same version native/gcc8
# co-builds), new enough for every backend/reloc in play and still targeting the
# legacy glibc. Declared 0/1 in the base toolchain Makefile; only legacy archs (glibc
# <= 2.20 / DSM <= 6.2.4) need it -- DSM 7.0+ already ship binutils >= 2.30.
#
# The binutils is PRODUCED by native/binutils-<ver> (co-build + publishable archive,
# `make -C native/binutils-<ver> arch-<arch>-<vers>`) and CONSUMED here by DOWNLOADING
# the published .txz through the per-arch consumer toolchain/syno-<arch>-<vers>-
# binutils<ver> (like the rust consumer) -- no per-build recompile in CI.
###############################################################################

# TWO distinct uses of the overlay binutils -- keep them separate, because a modern
# binutils is only safe under a MATCHED modern gcc:
#
#   OVERLAY_BINUTILS         GLOBAL: the default as/ld for EVERY compilation on the arch
#                            (baked into tc_vars). Valid ONLY with a matched modern gcc --
#                            the future gcc-8.5 overlay (OVERLAY_GCC=1 => OVERLAY_BINUTILS=1),
#                            where gcc-8.5 + binutils-2.30 are an upstream pair. It must NOT
#                            be turned on under a stock/vendor gcc: a modern binutils rejects
#                            vendor flags the old gcc emits (e.g. arm-marvell's -mcpu=marvell-f)
#                            and is an unnecessary mismatch. Default OFF; only gcc8 sets it.
#
#   RUST_LINK_VIA_BINUTILS   NARROW (rustc.mk / base toolchain): routes ONLY the Rust package
#                            link (CARGO_TARGET_<triple>_LINKER) through the overlay ld. The C
#                            toolchain stays the stock vendor gcc+ld. Used where the stock ld
#                            breaks Rust's output but the stock gcc emits standard flags a
#                            modern ld accepts -- ppc853x (2008 ld 2.18 mangles Rust TLS/PIE;
#                            gcc 4.3.7 uses standard -mcpu=8548). Explicit per rust arch.
#
# Both draw on the same downloaded binutils (below); they differ only in scope.
OVERLAY_BINUTILS       ?= 0
OVERLAY_BINUTILS_VERS  ?= 2.30

# RUST_LINK_VIA_BINUTILS defaults ON for every custom-rustc toolchain (RUST_BUILD_TOOLCHAIN
# declared): our from-source rustc is UNIFORMLY linked with the binutils 2.30 overlay -- the
# std is built with it (producer, toolchain-rust.mk) and the same overlay is reused as the
# package CARGO_TARGET_<triple>_LINKER (consumer, rustc.mk). It stays NARROW (rust link only;
# the C toolchain keeps the stock vendor as/ld), unlike the GLOBAL OVERLAY_BINUTILS above.
# Overridable per toolchain/CLI. Non-rust archs never enter this branch, so it stays 0 there.
ifneq ($(strip $(RUST_BUILD_TOOLCHAIN)),)
RUST_LINK_VIA_BINUTILS ?= 1
endif

# The per-arch consumer that downloads + extracts the published binutils .txz.
OVERLAY_BINUTILS_CONSUMER = syno-$(TC_ARCH)-$(TC_VERS)-binutils$(OVERLAY_BINUTILS_VERS)
OVERLAY_BINUTILS_DIR      = $(BASEDIR)/toolchain/$(OVERLAY_BINUTILS_CONSUMER)
# The extracted cross tools (<target>-ld, <target>-as, ...). The .txz unpacks
# usr/local/{bin,...} into work-native/install (the consumer's EXTRACT_PATH = INSTALL_DIR).
OVERLAY_BINUTILS_BIN      = $(OVERLAY_BINUTILS_DIR)/work-native/install/usr/local/bin
# gcc invokes 'as'/'ld' UNPREFIXED via -B, but the tools are <target>-prefixed, so a
# shim dir carries unprefixed symlinks. $(BASEDIR)-anchored so the -B path baked into
# tc_vars is identical under the CI docker and a local checkout.
OVERLAY_BINUTILS_SHIM     = $(OVERLAY_BINUTILS_DIR)/work-native/shim
# GLOBAL redirect: appended to CFLAGS/CXXFLAGS/LDFLAGS/FFLAGS in tc_vars so every
# gcc-driven compile/link uses the overlay as/ld. ONLY for the matched-pair (gcc8) case
# -- empty for a rust-link-only arch, whose C builds keep the vendor as/ld.
OVERLAY_BINUTILS_FLAG     = $(if $(filter 1,$(OVERLAY_BINUTILS)),-B$(OVERLAY_BINUTILS_SHIM))

# `make clean` on a custom-rust base toolchain also cleans its downloaded consumers --
# the rust std (syno-<arch>-<vers>-rust-gcc<gcc>) and this binutils overlay
# (syno-<arch>-<vers>-binutils<vers>) -- so a rebuild re-extracts them fresh instead of
# reusing a stale extracted install. This only ADDS a prerequisite to the generic clean
# (recipe stays in spksrc.rules.mk); the consumers don't declare RUST_BUILD_TOOLCHAIN, so
# they never recurse. Makes `make clean` in the base toolchain authoritative (CI no longer
# cleans each consumer by hand).
ifneq ($(strip $(RUST_BUILD_TOOLCHAIN)),)
clean: clean-rust-consumers
.PHONY: clean-rust-consumers
clean-rust-consumers:
	@for d in $(BASEDIR)/toolchain/syno-$(TC_ARCH)-$(TC_VERS)-rust-gcc$(TC_GCC) $(OVERLAY_BINUTILS_DIR) ; do \
	  if [ -d "$$d" ] ; then $(MSG) "clean consumer $$(basename $$d)" ; $(MAKE) --no-print-directory -C "$$d" clean ; fi ; \
	done
endif

# Provision the binutils (download the consumer + build the shim) when EITHER use needs
# it: the global overlay (gcc8) or the narrow rust-link overlay (default ON for every
# custom-rustc arch, set just above). Resolved here, before rustc.mk consumes it.
_OVERLAY_BINUTILS_NEEDED := $(if $(filter 1,$(OVERLAY_BINUTILS))$(filter 1,$(RUST_LINK_VIA_BINUTILS)),1)

.PHONY: overlay-binutils
# Skip during a native-toolchain extract (NATIVE_TOOLCHAIN_EXTRACT=1): when the rust
# producer (native/rustc-<ver>) extracts THIS toolchain's sysroot it does not need the
# binutils overlay (it co-builds its own build-time ld), so avoid a needless download --
# same gate as the base toolchain's rust-consumer DEPENDS.
ifeq ($(_OVERLAY_BINUTILS_NEEDED),1)
ifeq ($(NATIVE_TOOLCHAIN_EXTRACT),1)
overlay-binutils: ;
else
overlay-binutils:
	@$(MSG) "OVERLAY_BINUTILS: binutils $(OVERLAY_BINUTILS_VERS) for $(TC_ARCH)-$(TC_VERS) (download via $(OVERLAY_BINUTILS_CONSUMER))"
	@# A package build invokes the base toolchain with WORK_DIR=<pkg toolchain work> and
	@# ARCH/TCVERSION as command-line vars; those PROPAGATE into every sub-make. Override
	@# them for the consumer: WORK_DIR to its OWN work-native (else it extracts into the base
	@# toolchain's work dir and the shim below dangles), and clear ARCH/TCVERSION so it builds
	@# as the plain native download it is (the consumer is under toolchain/ so stage0 is inert).
	@$(MAKE) --no-print-directory -C $(OVERLAY_BINUTILS_DIR) ARCH= TCVERSION= WORK_DIR=$(OVERLAY_BINUTILS_DIR)/work-native
	@mkdir -p $(OVERLAY_BINUTILS_SHIM)
	@ln -sf $(OVERLAY_BINUTILS_BIN)/$(TC_TARGET)-ld $(OVERLAY_BINUTILS_SHIM)/ld
	@ln -sf $(OVERLAY_BINUTILS_BIN)/$(TC_TARGET)-as $(OVERLAY_BINUTILS_SHIM)/as
endif
else
overlay-binutils: ;
endif
