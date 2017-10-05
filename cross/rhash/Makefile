PKG_NAME = RHash
PKG_VERS = 1.3.5
PKG_EXT = tar.gz
PKG_DIST_NAME = v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/rhash/RHash/archive
PKG_DIST_FILE=$(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE   = http://rhash.sourceforge.net/
COMMENT  = RHash is a console utility for computing and verifying hash sums of files.
LICENSE  = MIT

GNU_CONFIGURE = 0
CONFIGURE_TARGET=nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/bin/
	@$(RUN) cp rhash $(STAGING_INSTALL_PREFIX)/bin/
