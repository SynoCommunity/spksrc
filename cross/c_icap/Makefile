PKG_NAME = c_icap
PKG_VERS = 0.2.2
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://downloads.sourceforge.net/project/c-icap/c-icap/0.2.x
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS =

HOMEPAGE = http://c-icap.sourceforge.net/
COMMENT  = c-icap is an implementation of an ICAP server. It can be used with HTTP proxies that support the ICAP protocol to implement content adaptation and filtering services.
LICENSE  = LGPLv2.1

PRE_CONFIGURE_TARGET = c_icap_pre_configure
GNU_CONFIGURE = 1
CONFIGURE_ARGS = --enable-large-files --with-zlib=$(INSTALL_DIR)/$(INSTALL_PREFIX)/lib -C

include ../../mk/spksrc.cross-cc.mk

.PHONY: c_icap_pre_configure
c_icap_pre_configure:
	cp src/config.cache $(WORK_DIR)/$(PKG_DIR)
	$(RUN) ; autoconf
