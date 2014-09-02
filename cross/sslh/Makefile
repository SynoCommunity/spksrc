PKG_NAME = sslh
PKG_VERS = v1.16
SRC_VERSION = v1.16
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(SRC_VERSION).$(PKG_EXT)
PKG_DIST_SITE = http://www.rutschle.net/tech
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)
SRC_DIR= $(WORK_DIR)/$(PKG_NAME)-$(PKG_VERS)/
VERSION="v1.16"

DEPENDS = cross/libconfig

HOMEPAGE = http://www.rutschle.net/tech/sslh.shtml
COMMENT  = sslh accepts HTTPS, SSH and OpenVPN connections on the same port
LICENSE  =

CONFIGURE_TARGET = nop
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk

.PHONY: myInstall
myInstall:
	@$(RUN) mkdir -p $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin
	@$(RUN) cp $(SRC_DIR)sslh-fork $(WORK_DIR)/install/$(INSTALL_PREFIX)/bin/sslh

