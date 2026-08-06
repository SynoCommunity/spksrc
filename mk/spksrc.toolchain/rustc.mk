###############################################################################
# spksrc.toolchain/rustc.mk
#
# Custom Rust toolchain SUPPORT for targets rustup ships no usable prebuilt
# rust-std for (Tier-3 e.g. PowerPC e500: qoriq, ppc853x; or a Tier-2 whose
# prebuilt std targets a newer glibc than the DSM toolchain, e.g. ARMv5 88f6281).
#
# This file is the CONSUMER / package-build side only: it resolves the shared
# custom rustup toolchain id ($(TC_RUSTUP_TOOLCHAIN) = $(_RUST_TC_ID)) so a cross
# rust PACKAGE build selects OUR toolchain (not rustup's glibc-newer std), and it
# (re)generates the lld linker wrapper the package link uses. A toolchain enters
# here by DECLARING RUST_BUILD_TOOLCHAIN (0 or 1); standard archs never do.
#
# The from-source BUILD of the toolchain (rustc + cargo + host/target std, LLVM
# from source) no longer lives here -- it moved to the host-native package
# native/rustc-<vers> (mk/spksrc.native-toolchain.mk + spksrc.native/toolchain-
# rust.mk), which goes through the framework's normal download/extract/patch/
# configure/compile/archive pipeline, like native/gcc8. Produce a .txz with:
#   make -C native/rustc-<vers> arch-<arch>-<vers>
# and the toolchain consumer (toolchain/syno-<arch>-<vers>-rust-gcc<gcc>, pulled
# in by DEPENDS) downloads and extracts it.
#
# Overlay-ready: RUST_CC / RUST_CXX default to $(TC_PREFIX)gcc$(TC_GCC_SUFFIX), so
# once TC_GCC_SUFFIX selects the gcc-8.5 overlay the effective TC_GCC lands in the
# id / consumer-dir names and stock-gcc and overlay-gcc8 artefacts coexist.
# RUST_LINK_VIA_LLD routes the package link through the shipped LLVM lld.
#
# A toolchain sets, before including spksrc.toolchain.mk:
#   RUST_BUILD_TOOLCHAIN = 0            (download the prebuilt .txz; the norm)
#   TC_RUSTC             = 1.82.0       rust version (matches native/rustc-1.82)
#   RUST_TARGET          = powerpc-unknown-linux-gnuspe
#   RUST_POSTFIX_ALIASES = powerpc-linux-gnuspe powerpc-unknown-linux-gnuspe
###############################################################################

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

# Base target = the in-tree rust triple (env-rust.mk arch map / toolchain Makefile).
# The custom "overlay" build uses a Synology-vendored triple (unknown -> synology) --
# a uniform marker that self-identifies our toolchains and is resolved from a JSON
# target-spec. The shared toolchain id embeds the synology triple + arch/DSM/gcc; it
# reads like a normal rustup name (<ver>-<target>) grafted with arch/DSM/gcc (stock
# vs the gcc-8.5 overlay via effective TC_GCC).
_RUST_BASE_TARGET := $(RUST_TARGET)
_RUST_SYNO_TARGET := $(subst -unknown-,-synology-,$(RUST_TARGET))
_RUST_TC_ID = $(TC_RUSTC)-$(_RUST_SYNO_TARGET)-$(TC_ARCH)-$(TC_VERS)-gcc$(TC_GCC)
# Archive revision -- bump (v2, ...) when re-publishing a rebuilt .txz under the same
# id so mirrors/CDN caches don't serve the stale artifact. Tags the .txz name only.
RUST_ARCHIVE_REV ?= v1

# Rust overlay (OVERLAY_RUSTC), part of the OVERLAY_<component> family (OVERLAY_BINUTILS,
# OVERLAY_GCC) but defaulting ON: an arch reaches this block only because it HAS a custom
# rust overlay, so using it is the point. ON (default) uses the custom from-source build
# (native/rustc-<vers>) and the Synology-vendored triple (unknown -> synology, resolved
# from a JSON spec). OFF falls back to the stock rustup rustc + in-tree `unknown` triple --
# valid ONLY for a tier-1/2 base triple (rustup ships a std); a tier-3 base (e.g. PowerPC
# e500) has NO stock std, so OVERLAY_RUSTC=0 is a hard error there. The toolchain declares
# the base triple's tier (RUST_TARGET_TIER). Overridable per package/local.mk/CLI.
# (RUST_OVERLAY is accepted as a deprecated alias during the OVERLAY_* rename.)
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

# Some targets' stock binutils ld is too old to link modern Rust cdylibs (ppc853x's
# 2008 GNU ld 2.18 segfaults). RUST_LINK_VIA_LLD = 1 builds the toolchain with LLVM
# lld in the sysroot (config lld=true, so it ships inside the .txz) and routes the
# package link through it. The redirect lives in the LINKER -- a gcc wrapper
# ($(RUST_LLD_CC)) adding -B$(RUST_LLD_SHIM_DIR) -- because cargo ignores
# CARGO_TARGET_*_RUSTFLAGS once maturin sets RUSTFLAGS, whereas the linker channel is
# always honored. The shim drops -Qy (a legacy SysV arg lld rejects); -B is required
# since gcc < 4.8 has no -fuse-ld. RUST_LLD resolves via the rustup toolchain symlink,
# so it works in both modes (from-source stage2, or the extracted .txz).
RUST_LINK_VIA_LLD ?= 0
ifeq ($(RUST_LINK_VIA_LLD),1)
RUST_LLD_SHIM_DIR = $(TC_WORK_DIR)/lld-shim
RUST_LLD_CC       = $(TC_WORK_DIR)/lld-cc
# $(BASEDIR) (the repo root, stable) rather than $(RUSTUP_HOME) (derived from CURDIR),
# so the absolute path baked into the lld shim is the same under the CI docker and a
# local checkout regardless of the invoking directory.
RUST_LLD          = $(BASEDIR)/distrib/rustup/toolchains/$(_RUST_TC_ID)/lib/rustlib/$(RUST_BUILD_HOST)/bin/gcc-ld/ld.lld
TC_RUST_LINKER    = $(RUST_LLD_CC)

define RUST_LLD_SHIM_SCRIPT
#!/bin/sh
# LLVM lld (ELF), dropping -Qy -- a legacy SysV "ident" arg gcc's link spec passes
# that lld does not accept. Invoking the ld.lld path selects lld's ELF flavor.
newargs=""
for a in "$$@"; do case "$$a" in -Qy) ;; *) newargs="$$newargs $$a" ;; esac; done
exec "$(RUST_LLD)" $$newargs
endef

define RUST_LLD_CC_SCRIPT
#!/bin/sh
# The cross gcc with its ld redirected to lld via -B (gcc < 4.8 has no -fuse-ld).
# Used as CARGO_TARGET_<triple>_LINKER for the package build.
exec "$(RUST_CC)" -B"$(RUST_LLD_SHIM_DIR)" "$$@"
endef
endif

# RUST_LINK_VIA_BINUTILS routes ONLY the Rust package link through the overlay ld, while
# the C toolchain keeps the stock vendor gcc+ld -- for archs whose stock ld breaks Rust's
# output but whose stock gcc emits standard flags a modern ld accepts (ppc853x). Declared
# per-arch in the base toolchain Makefile; independent of the GLOBAL OVERLAY_BINUTILS
# (that one, for a matched gcc-8.5 pair, redirects ALL compilation via tc_vars -- see
# overlay-binutils.mk). The link goes through CARGO_TARGET_<triple>_LINKER (= a gcc
# -B<overlay shim> wrapper): cargo ignores CARGO_TARGET_*_RUSTFLAGS once maturin sets
# RUSTFLAGS but always honors the linker; GNU ld needs no -Qy filtering, unlike lld.
# OVERLAY_BINUTILS_SHIM comes from overlay-binutils.mk.
RUST_LINK_VIA_BINUTILS ?= 0
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

# Generate the lld linker shim + gcc wrapper (needed by the package link in BOTH modes;
# hooked from tc-rust.mk post_rustc_target). PHONY + cheap so the baked absolute paths
# stay current. The shim dir is an ORDER-ONLY prerequisite, not an in-recipe mkdir:
# $(file >) writes at recipe-EXPANSION time, which precedes the recipe's own shell
# commands, so a `mkdir` line would run too late.
.PHONY: rustc-lld-linker
ifeq ($(RUST_LINK_VIA_LLD),1)
rustc-lld-linker: | $(RUST_LLD_SHIM_DIR)
	@$(call rustc_status,lld-linker)
	$(file >$(RUST_LLD_SHIM_DIR)/ld,$(RUST_LLD_SHIM_SCRIPT))
	@chmod +x $(RUST_LLD_SHIM_DIR)/ld
	$(file >$(RUST_LLD_CC),$(RUST_LLD_CC_SCRIPT))
	@chmod +x $(RUST_LLD_CC)

$(RUST_LLD_SHIM_DIR):
	@mkdir -p $@
else
rustc-lld-linker: ;
endif

# Generate the binutils gcc wrapper (hooked from tc-rust.mk post_rustc_target). Cheap
# + PHONY so the baked absolute path stays current. No shim dir: the -B points straight
# at the shipped ld dir in the extracted .txz (GNU ld needs no -Qy filtering).
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
