PKG_NAME = sslh
PKG_VERS = 1.19c
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-v$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://www.rutschle.net/tech/sslh
PKG_DIR = $(PKG_NAME)-v$(PKG_VERS)

DEPENDS = cross/libconfig cross/pcre

HOMEPAGE = http://www.rutschle.net/tech/sslh.shtml
COMMENT  = sslh accepts HTTPS, SSH and OpenVPN connections on the same port
LICENSE  = GPLv2

CONFIGURE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(STAGING_INSTALL_PREFIX)/bin
	@$(RUN) cp $(WORK_DIR)/$(PKG_DIR)/sslh-fork $(STAGING_INSTALL_PREFIX)/bin/sslh

