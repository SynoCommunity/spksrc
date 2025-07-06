PKG_NAME = bat
PKG_VERS = 0.25.0
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/sharkdp/bat/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# package `home v0.5.11` cannot be built because it requires rustc 1.81 or newer, while the latest supported rustc version is 1.77.2
# a build with rustc 1.83.0 fails with:
# /rustc/90b35a6239c3d8bdabc530a6a0816f7ff89a0aaf/library/std/src/sys/pal/unix/stack_overflow.rs:270: undefined reference to `getauxval'
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

HOMEPAGE = https://github.com/sharkdp/bat
COMMENT = A cat(1) clone with wings.
LICENSE = MIT or Apache 2.0

include ../../mk/spksrc.cross-rust.mk
