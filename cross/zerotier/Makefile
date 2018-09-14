PKG_NAME = ZeroTierOne
PKG_VERS = 1.2.12
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/zerotier/ZeroTierOne/archive
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = https://www.zerotier.com
COMMENT  = A Simple global P2P encrypted LAN for all of your devices.
LICENSE  = GPLv3

GNU_CONFIGURE = 1
CONFIGURE_ARGS = HAVE_CXX=yes
CONFIGURE_TARGET = myConfigure
INSTALL_TARGET = myInstall

ENV+=ZT_SYNOLOGY=1
REQUIRED_DSM=6.1

include ../../mk/spksrc.cross-cc.mk

.PHONY: myConfigure
myConfigure:

.PHONY: myInstall
myInstall:
	$(RUN) mkdir -p $(STAGING_DIR)/bin
	$(RUN) cp zerotier-one $(STAGING_DIR)/bin/zerotier-one
