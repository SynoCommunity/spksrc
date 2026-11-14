# 3.8.x requires rustc 1.85; 3.6.1 keeps the older toolchains supported.
PKG_NAME = dysk
PKG_VERS = 3.6.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/Canop/dysk/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

MIN_RUSTC_VERSION = 1.75

UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://dystroy.org/dysk/
COMMENT = A linux utility to get information on filesystems, like df but better.
LICENSE = MIT

CARGO_BUILD_ARGS = --locked

include ../../mk/spksrc.cross-rust.mk
