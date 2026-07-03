PKG_NAME = c_icap
PKG_VERS = 0.5.9
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/c-icap/c-icap/0.5.x
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/bzip2 cross/openssl cross/pcre cross/berkeleydb

HOMEPAGE = http://c-icap.sourceforge.net/
COMMENT  = c-icap is an implementation of an ICAP server. It can be used with HTTP proxies that support the ICAP protocol to implement content adaptation and filtering services.
LICENSE  = LGPLv2.1

PRE_CONFIGURE_TARGET = c_icap_pre_configure
POST_INSTALL_TARGET = c_icap_post_install

GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-large-files --disable-static --with-zlib=$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib -C

include ../../mk/spksrc.cross-cc.mk

.PHONY: c_icap_pre_configure
c_icap_pre_configure:
	cp src/config.cache $(WORK_DIR)/$(PKG_DIR)
	$(RUN) ; autoconf

.PHONY: c_icap_post_install
c_icap_post_install:
	@$(RUN) sed -i 's?^PidFile .*?PidFile $(INSTALL_PREFIX)/var/run/c-icap/c-icap.pid?' $(STAGING_INSTALL_PREFIX)/etc/c-icap.conf
	@$(RUN) sed -i 's?^CommandsSocket .*?CommandsSocket $(INSTALL_PREFIX)/var/run/c-icap/c-icap.ctl?' $(STAGING_INSTALL_PREFIX)/etc/c-icap.conf
	@$(RUN) sed -i 's?^Port .*?Port 10344?' $(STAGING_INSTALL_PREFIX)/etc/c-icap.conf
