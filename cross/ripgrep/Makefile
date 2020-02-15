PKG_NAME = ripgrep
PKG_VERS = 11.0.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/BurntSushi/ripgrep/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# armv7 without hardfloat is not supported
UNSUPPORTED_ARCHS = hi3535
# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += powerpc ppc824x ppc853x ppc854x


include ../../mk/spksrc.cross-rust.mk


