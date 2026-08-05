PKG_NAME = rustc
PKG_VERS = 1.82.0
PKG_EXT  = tar.xz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIST_SITE = https://static.rust-lang.org/dist
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS)-src.$(PKG_EXT)
PKG_DIR  = $(PKG_NAME)-$(PKG_VERS)-src

# Target toolchain to (re)build this custom rustc for (per-arch work dir). Only
# archs whose toolchain declares RUST_TARGET are real rust targets (see below).
TC_ARCH ?= ppc853x
TC_VERS ?= 5.2

# Per-(arch,dsm) archive revision (new structure, CLI-overridable).
include archive-rev.mk

HOMEPAGE = https://www.rust-lang.org/
COMMENT  = Rust 1.82 rebuilt from source as a custom cross toolchain (rustc + cargo + host/target std, LLVM from the bundled source) for legacy Synology toolchains rustup ships no usable prebuilt std for (Tier-3 PowerPC e500; ARMv5 on an older glibc). Produces the rust-<id>.txz the toolchain consumer extracts.
LICENSE  = Apache-2.0, MIT

# The source tarball bundles src/llvm-project and vendors every crate, so the whole
# build is offline: no `git clone`, no submodule fetch. The x.py steps (config.toml,
# LLVM, stage1/stage2) are custom targets in spksrc.native-toolchain-rust.mk; the
# source pipeline (download/extract/patch) is the framework's, so patches live in
# ./patches and are applied by the normal patch step.

##############################################################################
# Packaging via the generic helper (mk/spksrc.native/archive.mk): host the x.py
# stage2 tree (= the rustup toolchain layout), consumed by
# toolchain/syno-<arch>-<vers>-rust-gcc<gcc>.
#   make TC_ARCH=<arch> TC_VERS=<vers> build-archive
#
# Declared BEFORE the native front-end include so the helper (pulled in via
# native-cc.mk) sees ARCHIVE_NAME; the '=' refs (_RUST_TC_ID, RUST_STAGE_DIR,
# RUST_ARCHIVE_REV) resolve later. ARCHIVE_KEEP = . of the stage dir so the tree
# unpacks straight into $(RUSTUP_HOME)/toolchains/<id>.
##############################################################################
ARCHIVE_NAME = rust-$(_RUST_TC_ID)-$(RUST_ARCHIVE_REV)
ARCHIVE_EXT  = txz
ARCHIVE_DIR  = $(RUST_STAGE_DIR)
ARCHIVE_KEEP = .

# Generic native-toolchain front-end dispatches to mk/spksrc.native/toolchain-rust.mk.
NATIVE_TOOLCHAIN = rust
include ../../mk/spksrc.native-toolchain.mk

##############################################################################
# Build rustc for EVERY custom-rust toolchain of a given DSM version (a toolchain
# is a real rust target iff its Makefile declares RUST_TARGET). Consumer dirs
# (syno-<arch>-<vers>-rust-gcc<gcc>) are excluded: the version wildcard only
# matches names ending in -<vers>.
#
#   make all-5.2                 one arch at a time
#   make RUST_JOBS=2 all-6.2.4   2 archs at a time (each still max threads)
#
# Concurrency via xargs -P, deliberately NOT make -j (which would propagate into
# the x.py sub-builds). Keep it low: an LLVM+rustc build is heavy and homogeneous.
##############################################################################
RUST_REAL_ARCHS = $(foreach a,$(patsubst syno-%-$(1),%,$(notdir $(wildcard ../../toolchain/syno-*-$(1)))),$(if $(strip $(shell grep -l '^RUST_TARGET' ../../toolchain/syno-$(a)-$(1)/Makefile 2>/dev/null)),$(a)))

RUST_JOBS ?= 1

.PHONY: all-%
all-%:
	@$(MSG) "rustc-$(PKG_VERS): all-$* -- $(words $(call RUST_REAL_ARCHS,$*)) archs, $(RUST_JOBS) at a time"
	@echo "$(sort $(call RUST_REAL_ARCHS,$*))" | tr ' ' '\n' | \
	   xargs -P $(RUST_JOBS) -I@ $(MAKE) --no-print-directory arch-@-$*
	@$(MSG) "rustc-$(PKG_VERS): all-$* complete"

##############################################################################
# Build rustc for a SPECIFIC toolchain of a given DSM version, then archive it.
#   make arch-ppc853x-5.2     make arch-qoriq-6.2.4
##############################################################################
.PHONY: arch-%
arch-%:
	@$(MSG) "===== rustc-$(PKG_VERS): $* ====="
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) all
	@$(MAKE) --no-print-directory TC_ARCH=$(firstword $(subst -, ,$*)) TC_VERS=$(lastword $(subst -, ,$*)) build-archive
