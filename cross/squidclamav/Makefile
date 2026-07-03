PKG_NAME = squidclamav
PKG_VERS = 7.1
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/$(PKG_NAME)/$(PKG_NAME)/$(PKG_VERS)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/c_icap

HOMEPAGE = https://squidclamav.darold.net/
COMMENT  = SquidClamav is an antivirus for Squid proxy based on the Awards winnings ClamAv anti-virus toolkit.
LICENSE  = GPLv3

GNU_CONFIGURE = 1

CONFIGURE_ARGS  = --prefix=$(INSTALL_PREFIX) --with-c-icap=$(INSTALL_DIR)/$(INSTALL_PREFIX)
ADDITIONAL_CFLAGS = -I$(INSTALL_DIR)/$(INSTALL_PREFIX)/include/c_icap

POST_INSTALL_TARGET = squidclamav_post_install

include ../../mk/spksrc.cross-cc.mk

.PHONY: squidclamav_post_install
squidclamav_post_install:
	@$(RUN) sed -i 's?^clamd_local .*?clamd_local $(INSTALL_PREFIX)/var/run/clamd/clamd.ctl?' $(STAGING_INSTALL_PREFIX)/etc/squidclamav.conf
