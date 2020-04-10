PKG_NAME = ripgrep
PKG_VERS = 12.0.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/BurntSushi/ripgrep/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# armv7 without hardfloat is not supported
UNSUPPORTED_ARCHS = hi3535
# powerpc archs (except qoriq) are not supported
UNSUPPORTED_ARCHS += powerpc ppc824x ppc853x ppc854x

HOMEPAGE = https://github.com/BurntSushi/ripgrep
COMMENT  = ripgrep recursively searches directories for a regex pattern 
LICENSE  = public domain/Unlicense


include ../../mk/spksrc.cross-rust.mk
