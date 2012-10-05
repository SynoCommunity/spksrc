PKG_NAME = squidclamav
PKG_VERS = 6.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://squidclamav.darold.net/
COMMENT  = SquidClamav is an antivirus for Squid proxy based on the Awards winnings ClamAv anti-virus toolkit.
LICENSE  = GNU GPL v3

GNU_CONFIGURE = 1
PRE_COMPILE_TARGET = myPreCompile

CONFIGURE_ARGS  = --prefix=$(INSTALL_PREFIX) --with-c-icap=$(INSTALL_DIR)/$(INSTALL_PREFIX)
ADDITIONAL_CFLAGS = -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include/c_icap

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreCompile
myPreCompile:
	sed -i 's/"\/etc\/squidclamav.conf"/"\/usr\/local\/squidguard\/etc\/squidclamav.conf"/' $(WORK_DIR)/$(PKG_DIR)/src/squidclamav.h
