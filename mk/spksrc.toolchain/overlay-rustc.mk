###############################################################################
# spksrc.toolchain/overlay-rustc.mk
#
# OVERLAY_RUSTC: select the custom from-source rustc (+ its binutils link wrapper) for a
# cross rust PACKAGE build. Member of the OVERLAY_<component> family (base + overview:
# overlay-binutils.mk).
#
# Custom Rust toolchain SUPPORT for targets rustup ships no usable prebuilt
# rust-std for (Tier-3 e.g. PowerPC e500: qoriq, ppc853x; or a Tier-2 whose
# prebuilt std targets a newer glibc than the DSM toolchain, e.g. ARMv5 88f6281).
#
# This file is the CONSUMER / package-build side only: it resolves the shared
# custom rustup toolchain id ($(TC_RUSTUP_TOOLCHAIN) = $(_RUST_TC_ID)) so a cross
# rust PACKAGE build selects OUR toolchain (not rustup's glibc-newer std), and it
# (re)generates the binutils linker wrapper the package link uses. A toolchain enters
# here when its base ships a rust consumer dir (TC_OVERLAY_RUSTC); standard archs never do.
#
# The from-source BUILD of the toolchain (rustc + cargo + host/target std, LLVM
# from source) no longer lives here -- it moved to the host-native package
# native/rustc-<vers> (mk/spksrc.native-toolchain.mk + spksrc.native/toolchain-
# rust.mk), which goes through the framework's normal download/extract/patch/
# configure/compile/archive pipeline, like any native toolchain package. Produce a .txz with:
#   make -C native/rustc-<vers> arch-<arch>-<vers>
# and the toolchain consumer (toolchain/syno-<arch>-<vers>-rust-gcc<gcc>, pulled
# in by DEPENDS) downloads and extracts it.
#
# Overlay-ready: RUST_CC / RUST_CXX default to $(TC_PREFIX)gcc$(TC_GCC_SUFFIX), so a
# TC_GCC_SUFFIX (empty here) lands the effective TC_GCC in the id / consumer-dir names,
# letting stock-gcc and a future gcc-overlay variant coexist.
#
# A toolchain only declares its arch specifics (e.g. RUST_POSTFIX_ALIASES); the triple comes
# from env-rust.mk's map and TC_RUSTC from the rust consumer's PKG_VERS.
###############################################################################

# The rust overlay entry -- peer of overlay-binutils. Defined for
# EVERY rust arch (like overlay-binutils): the rustup base install (rustup-rustc, tc-rust.mk)
# always, plus this arch's own overlay artifacts (the binutils linker wrapper) added under
# the custom-rust gate below.
.PHONY: overlay-rustc
overlay-rustc: rustup-rustc

# ============================================================================
# Custom-rust archs only (TC_OVERLAY_RUSTC: a rust consumer dir exists);
# standard archs never enter here.
# ============================================================================
ifneq ($(strip $(TC_OVERLAY_RUSTC)),)

# RUST_TARGET (the in-tree base triple) comes from env-rust.mk's arch map -- the single
# source of truth. Sourced here (guarded; tc_vars.mk includes it again) so it is set
# before we derive the synology triple below.
include ../../mk/spksrc.cross/env-rust.mk

RUST_TOOL_BIN     = $(WORK_DIR)/$(TC_TARGET)/bin/$(TC_PREFIX)
# The build host triple. std is built for it too (not only RUST_TARGET): cargo
# compiles build scripts and proc-macros for the host while cross-compiling.
RUST_BUILD_HOST   ?= x86_64-unknown-linux-gnu
RUST_CC          ?= $(RUST_TOOL_BIN)gcc$(TC_GCC_SUFFIX)

# The custom "overlay" build uses a Synology-vendored triple (unknown -> synology), a uniform
# marker resolved from a JSON target-spec. The shared toolchain id embeds it + arch/DSM/gcc,
# reading like a rustup name (<ver>-<target>) grafted with arch/DSM/gcc.
_RUST_BASE_TARGET := $(RUST_TARGET)
_RUST_SYNO_TARGET := $(subst -unknown-,-synology-,$(RUST_TARGET))
_RUST_TC_ID = $(TC_RUSTC)-$(_RUST_SYNO_TARGET)-$(TC_ARCH)-$(TC_VERS)-gcc$(TC_GCC)

# OVERLAY_RUSTC (default ON): ON = custom from-source build + synology triple; OFF = stock
# rustup rustc + `unknown` triple, usable only where rustup ships a std (tc-rust.mk reports it).
OVERLAY_RUSTC    ?= 1

ifneq ($(filter 1 on ON,$(strip $(OVERLAY_RUSTC))),)
# Overlay ON (default): our custom toolchain, synology triple.
RUST_TARGET         := $(_RUST_SYNO_TARGET)
TC_RUSTUP_TOOLCHAIN  = $(_RUST_TC_ID)
else
# Overlay OFF: stock rustup rustc + in-tree unknown triple.
RUST_TARGET         := $(_RUST_BASE_TARGET)
TC_RUSTUP_TOOLCHAIN  = $(TC_RUSTC)
endif

# Widened atomics (RUST_MAX_ATOMIC_WIDTH) become __atomic_*_N libcalls, so the Rust link
# needs libatomic. Lazy like _tc_ld_syslibs: TC_HAS_LIBATOMIC runs the cross gcc, which does
# not exist yet while the toolchain is still being bootstrapped.
RUSTFLAGS += $(if $(RUST_MAX_ATOMIC_WIDTH),$(if $(TC_HAS_LIBATOMIC),-Clink-arg=-latomic))

# RUST_LINK_VIA_BINUTILS routes ONLY the Rust package link through the overlay ld (C stays on
# vendor gcc+ld). Default ON for every custom-rustc arch (overlay-binutils.mk normally sets it;
# ?= 1 is the standalone fallback). The link goes through CARGO_TARGET_<triple>_LINKER, a
# gcc -B<OVERLAY_BINUTILS_SHIM> wrapper, since cargo always honors the linker channel.
RUST_LINK_VIA_BINUTILS ?= 1
ifeq ($(RUST_LINK_VIA_BINUTILS),1)
RUST_BINUTILS_CC = $(TC_WORK_DIR)/binutils-cc
TC_RUST_LINKER   = $(RUST_BINUTILS_CC)

define RUST_BINUTILS_CC_SCRIPT
#!/bin/sh
# The cross gcc with its ld redirected to the OVERLAY_BINUTILS ld via -B (gcc < 4.8
# has no -fuse-ld). Used as CARGO_TARGET_<triple>_LINKER for the package build.
exec "$(RUST_CC)" -B"$(OVERLAY_BINUTILS_SHIM)" "$$@"
endef
endif

# Per-step status line (stdout + status-build.log), so the long from-source steps are
# trackable there like the framework's NAME lines: NAME: toolchain-rust-<step>.
rustc_status = $(MSG) $$(printf "%s MAKELEVEL: %02d, PARALLEL_MAKE: %s, ARCH: %s-%s, NAME: toolchain-rust-%s\n" "$$(date +%Y%m%d-%H%M%S)" $(MAKELEVEL) "$(PARALLEL_MAKE)" "$(TC_ARCH)" "$(TC_VERS)" "$(1)") | tee --append $(STATUS_LOG)

# The binutils gcc wrapper: this arch's overlay artifact, so it hangs off overlay-rustc
# (only when the rust link goes through the binutils overlay ld). Cheap + PHONY so the
# baked absolute path stays current. No shim dir: the -B points straight at the shipped
# ld dir in the extracted .txz (GNU ld needs no -Qy filtering).
overlay-rustc: $(if $(filter 1,$(RUST_LINK_VIA_BINUTILS)),rustc-binutils-linker)
.PHONY: rustc-binutils-linker
ifeq ($(RUST_LINK_VIA_BINUTILS),1)
rustc-binutils-linker:
	@$(call rustc_status,binutils-linker)
	$(file >$(RUST_BINUTILS_CC),$(RUST_BINUTILS_CC_SCRIPT))
	@chmod +x $(RUST_BINUTILS_CC)
else
rustc-binutils-linker: ;
endif


endif # custom-rust arch (TC_OVERLAY_RUSTC)
