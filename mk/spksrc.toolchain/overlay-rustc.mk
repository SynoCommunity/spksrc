###############################################################################
# spksrc.toolchain/overlay-rustc.mk
#
# OVERLAY_RUSTC, consumer side: pick the custom from-source rustc for a cross rust PACKAGE
# build. Member of the OVERLAY_<component> family; the decisions are in
# spksrc.common/overlay.mk, this file applies them.
#
# It resolves the shared rustup toolchain id ($(TC_RUSTUP_TOOLCHAIN) = $(_RUST_TC_ID)) so the
# build selects OUR toolchain rather than rustup's glibc-newer std, for the targets rustup
# ships no usable one for: Tier-3 PowerPC e500 (qoriq, ppc853x), or a Tier-2 whose prebuilt
# std targets a newer glibc than the DSM toolchain (ARMv5 88f6281). An arch enters here when
# it has a rust consumer dir (TC_OVERLAY_RUSTC); standard archs never do.
#
# The toolchain itself is BUILT by native/rustc-<vers> and downloaded by the consumer:
#   make -C native/rustc-<vers> arch-<arch>-<vers>
###############################################################################

# Warnings ride tcvars instead, like overlay-binutils-warn: they report a per-PACKAGE choice,
# and _all is skipped once the toolchain cookie exists.
.PHONY: overlay-rustc-warn
ifeq ($(OVERLAY_RUSTC_VERSION_MISSING),1)
overlay-rustc-warn:
	@$(OVERLAY_WARN_RUSTC_VERSION_MISSING)
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
