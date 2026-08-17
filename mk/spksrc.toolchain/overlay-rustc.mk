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
# and the toolchain consumer (toolchain/syno-<arch>-<vers>_rust-<vers>_gcc-<gcc>, pulled
# in by DEPENDS) downloads and extracts it.
#
# Overlay-ready: RUST_CC / RUST_CXX default to $(TC_PREFIX)gcc$(TC_GCC_SUFFIX), so a
# TC_GCC_SUFFIX (empty here) lands the effective TC_GCC in the id / consumer-dir names,
# letting stock-gcc and a future gcc-overlay variant coexist.
#
# A toolchain only declares its arch specifics (e.g. RUST_POSTFIX_ALIASES); the triple comes
# from env-rust.mk's map and TC_RUSTC from the rust consumer's PKG_VERS.
###############################################################################

# Warnings ride tcvars instead, like overlay-binutils-warn: they report a per-PACKAGE choice,
# and _all is skipped once the toolchain cookie exists.
.PHONY: overlay-rustc-warn
ifeq ($(OVERLAY_RUSTC_VERSMISS),1)
overlay-rustc-warn:
	@$(OVERLAY_WARN_RUSTC_VERSMISS)
else
overlay-rustc-warn: ;
endif

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

# ON = custom from-source build + synology triple; OFF = stock rustup rustc + `unknown`
# triple, usable only where rustup ships a std (tc-rust.mk reports it). The switch and its
# default live in spksrc.common/overlay.mk.
ifeq ($(OVERLAY_RUSTC_ON),1)
# Overlay ON (default): our custom toolchain, synology triple.
RUST_TARGET         := $(_RUST_SYNO_TARGET)
TC_RUSTUP_TOOLCHAIN  = $(_RUST_TC_ID)
else
# Overlay OFF: stock rustup rustc + in-tree unknown triple.
RUST_TARGET         := $(_RUST_BASE_TARGET)
TC_RUSTUP_TOOLCHAIN  = $(TC_RUSTC)
endif

# Where libatomic exists the spec was widened to 64 (toolchain-rust.mk, same probe), so the
# widened atomics lower to __atomic_*_N libcalls the Rust link must resolve. Lazy like
# _tc_ld_syslibs: TC_HAS_LIBATOMIC runs the cross gcc, absent while the toolchain bootstraps.
RUSTFLAGS += $(if $(TC_HAS_LIBATOMIC),-Clink-arg=-latomic)

# RUST_LINK_VIA_BINUTILS routes ONLY the Rust package link through the overlay ld (C stays on
# vendor gcc+ld); defaulted in spksrc.common/overlay.mk. gcc picks its ld from -B (gcc < 4.8
# has no -fuse-ld), and that reaches the link driver through the same channel as -latomic above
# -- so there is no wrapper script to write, and nothing for _all to build. The linker itself
# stays the plain cross gcc (tc_vars' default).
ifeq ($(RUST_LINK_VIA_BINUTILS),1)
RUSTFLAGS += -Clink-arg=-B$(OVERLAY_BINUTILS_SHIM)
endif

endif # custom-rust arch (TC_OVERLAY_RUSTC)
