PKG_NAME = exa
PKG_VERS = 0.10.1
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ogham/exa/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib-ng

# unsupported by cross/zlib-ng
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)
# rust issue with target 'armv5te-unknown-linux-gnueabi'
# https://github.com/rust-lang/compiler-builtins/issues/420
UNSUPPORTED_ARCHS += $(ARMv5_ARCHS)

HOMEPAGE = https://the.exa.website/
COMMENT  = A modern replacement for 'ls'.
LICENSE  = MIT

include ../../mk/spksrc.cross-rust.mk
