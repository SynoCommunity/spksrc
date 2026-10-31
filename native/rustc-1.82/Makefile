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

HOMEPAGE = https://www.rust-lang.org/
COMMENT  = A language empowering everyone to build reliable and efficient software.
LICENSE  = Apache-2.0, MIT

# The source tarball bundles src/llvm-project and vendors every crate, so the whole
# build is offline: no `git clone`, no submodule fetch. The x.py steps (config.toml,
# LLVM, stage1/stage2) are custom targets in spksrc.native/toolchain-rust.mk; the
# source pipeline (download/extract/patch) is the framework's, so patches live in
# ./patches and are applied by the normal patch step.
#
# NO manual prerequisite: the Rust link needs a modern binutils (RUST_LINK_VIA_BINUTILS,
# default ON), so this build CO-BUILDS native/binutils-$(vers) for the SAME arch on the
# fly (rustc_binutils_cobuild, a rustc_prepare step). It is deliberately NOT a DEPENDS --
# a DEPENDS could not carry the per-(arch,DSM) parametrization. So `make arch-<arch>-<vers>`
# is self-contained; you never build binutils separately.

##############################################################################
# Packaging via the generic helper (mk/spksrc.build/archive.mk): host the x.py
# stage2 tree (= the rustup toolchain layout), consumed by
# overlay/syno-<arch>-<vers>_rust-<vers>_gcc-<gcc>.
#   make TC_ARCH=<arch> TC_VERS=<vers> build-archive
#
# Declared BEFORE the native front-end include so the helper (pulled in via
# native-cc.mk) sees ARCHIVE_NAME; the '=' refs (_RUST_TC_ID, RUST_STAGE_DIR)
# resolve later. ARCHIVE_KEEP = . of the stage dir so the tree unpacks straight
# into $(RUSTUP_HOME)/toolchains/<id>.
#
# PKG_REV tags the .txz name only; bump it -- or pass PKG_REV=vN on
# the command line, then rename -- when re-publishing a rebuilt archive under the same
# id so mirrors/CDN caches don't serve the stale artifact. Each consumer toolchain
# (syno-<arch>-<vers>_rust-<vers>_gcc-<gcc>) pins its own current rev the same way (mirrors
# native/binutils-2.30's PKG_REV; no shared/cross-included rev file).
##############################################################################
PKG_REV ?= v1
ARCHIVE_NAME = rust-$(_RUST_TC_ID)-$(PKG_REV)
ARCHIVE_EXT  = txz
ARCHIVE_DIR  = $(RUST_STAGE_DIR)
ARCHIVE_KEEP = .

# Generic native-toolchain front-end dispatches to mk/spksrc.native/toolchain-rust.mk.
NATIVE_TOOLCHAIN = rust
include ../../mk/spksrc.native-toolchain.mk
