###############################################################################
# spksrc.toolchain/overlay-rustc.mk
#
# Custom Rust toolchain SUPPORT for targets rustup ships no usable prebuilt
# rust-std for (Tier-3 e.g. PowerPC e500: qoriq, ppc853x; or a Tier-2 whose
# prebuilt std targets a newer glibc than the DSM toolchain, e.g. ARMv5 88f6281).
#
# This file is the CONSUMER / package-build side only: it resolves the shared
# custom rustup toolchain id ($(TC_RUSTUP_TOOLCHAIN) = $(_RUST_TC_ID)) so a cross
# rust PACKAGE build selects OUR toolchain (not rustup's glibc-newer std), and it
# (re)generates the binutils linker wrapper the package link uses. A toolchain enters
# here by DECLARING RUST_BUILD_TOOLCHAIN (0 or 1); standard archs never do.
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
# A toolchain sets, before including spksrc.toolchain.mk:
#   RUST_BUILD_TOOLCHAIN = 0            (download the prebuilt .txz; the norm)
#   TC_RUSTC             = 1.82.0       rust version (matches native/rustc-1.82)
#   RUST_TARGET          = powerpc-unknown-linux-gnuspe
#   RUST_POSTFIX_ALIASES = powerpc-linux-gnuspe powerpc-unknown-linux-gnuspe
###############################################################################

# The rust overlay entry -- peer of overlay-binutils. Defined for
# EVERY rust arch (like overlay-binutils): the rustup base install (rustup-rustc, tc-rust.mk)
# always, plus this arch's own overlay artifacts (the binutils linker wrapper) added under
# the custom-rust gate below.
.PHONY: overlay-rustc
overlay-rustc: rustup-rustc

# ============================================================================
# Custom-rust archs only. Gated on RUST_BUILD_TOOLCHAIN being DECLARED (0 or 1);
# standard archs never enter here.
# ============================================================================
ifneq ($(strip $(RUST_BUILD_TOOLCHAIN)),)

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

# Rust overlay (OVERLAY_RUSTC), part of the OVERLAY_<component> family but defaulting ON: an
# arch reaches this block only because it HAS a custom rust overlay. ON (default) = the custom
# from-source build + synology triple. OFF falls back to stock rustup rustc + in-tree `unknown`
# triple -- valid ONLY for a tier-1/2 base (rustup ships a std); on tier-3 (PowerPC e500) there
# is no stock std, so OVERLAY_RUSTC=0 is a hard error. Tier via RUST_TARGET_TIER; overridable
# per package/local.mk/CLI. (RUST_OVERLAY = deprecated alias.)
OVERLAY_RUSTC    ?= $(or $(RUST_OVERLAY),1)
RUST_TARGET_TIER ?= 3

ifneq ($(filter 1 on ON,$(strip $(OVERLAY_RUSTC))),)
# Overlay ON (default): our custom toolchain, synology triple.
RUST_TARGET         := $(_RUST_SYNO_TARGET)
TC_RUSTUP_TOOLCHAIN  = $(_RUST_TC_ID)
else ifeq ($(strip $(RUST_TARGET_TIER)),3)
$(error rust: OVERLAY_RUSTC=0 on tier-3 target $(_RUST_BASE_TARGET) -- rustup ships no std for it, there is no stock fallback; keep OVERLAY_RUSTC=1)
else
# Overlay OFF on a tier-1/2 arch: stock rustup rustc + in-tree unknown triple.
RUST_TARGET         := $(_RUST_BASE_TARGET)
TC_RUSTUP_TOOLCHAIN  = $(TC_RUSTC)
endif

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


endif # custom-rust arch (RUST_BUILD_TOOLCHAIN declared)
