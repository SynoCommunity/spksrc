PKG_NAME = bsdiff
PKG_VERS = 4.3
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.daemonology.net/$(PKG_NAME)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS	= cross/bzip2

HOMEPAGE = http://www.daemonology.net/bsdiff/
COMMENT  = bsdiff and bspatch are tools for building and applying patches to binary files
LICENSE  = BSD

CONFIGURE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

myInstall: $(PRE_INSTALL_TARGET)
	$(RUN) $(MAKE) install PREFIX=$(STAGING_INSTALL_PREFIX) INSTALL=install
