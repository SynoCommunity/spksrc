PKG_NAME = ioquake
PKG_VERS = 3.0.0
PKG_EXT = zip
PKG_DIST_NAME = master.zip
PKG_DIST_SITE = https://github.com/ioquake/ioq3/archive
PKG_DIR = ioq3-master
#$(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://www.ioquake.org
COMMENT = ioquake 
LICENSE = GPLv2

CONFIGURE_TARGET = ioquake-configure
INSTALL_TARGET = ioquake-install

include ../../mk/spksrc.cross-cc.mk

GNU_CONFIGURE = 1

.PHONY: ioquake-configure

ioquake-configure:
	@$(MSG) "IOQuake configure for $(NAME)"
	$(RUN) "make BUILD_SERVER=1 BUILD_CLIENT=0"

ioquake-install:
	@$(MSG) "IOQuake install for $(NAME)"
	$(RUN) make copyfiles BUILD_SERVER=1 BUILD_CLIENT=0 COPYDIR=$(STAGING_INSTALL_PREFIX)

