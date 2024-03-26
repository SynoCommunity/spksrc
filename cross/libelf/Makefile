PKG_NAME = libelf
PKG_VERS = 0.8.13
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://fossies.org/linux/misc/old
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

# original homepage not reachable anymore (http://www.mr511.de/software/english.html).
HOMEPAGE = https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz/index_ap.html
COMMENT  = libelf is a free ELF object file access library (supports 64-bit ELF files).
LICENSE  = LPGL

GNU_CONFIGURE = 1

INSTALL_MAKE_OPTIONS = install instroot=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)

include ../../mk/spksrc.cross-cc.mk
