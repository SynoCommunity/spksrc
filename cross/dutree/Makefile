PKG_NAME = dutree
PKG_VERS = 0.2.18
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/nachoparker/dutree/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

# linker error: unknown relocation type 95 for symbol...
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

DEPENDS =

HOMEPAGE = https://ownyourbits.com/2018/03/25/analyze-disk-usage-with-dutree/
COMMENT  = A tool to analyze file system usage written in Rust.
LICENSE  = GPLv3

include ../../mk/spksrc.cross-rust.mk
