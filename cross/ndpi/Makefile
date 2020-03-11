PKG_NAME = nDPI
PKG_VERS = 3.0
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ntop/$(PKG_NAME)/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap

HOMEPAGE = http://www.ntop.org/
COMMENT  = nDPI is an open source LGPLv3 library for deep-packet inspection. Based on OpenDPI it includes ntop extensions. We have tried to push them into the OpenDPI source tree but nobody answered emails so we have decided to create our own source tree.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = nDPI_pre_configure
POST_INSTALL_TARGET = nDPI_post_install


include ../../mk/spksrc.cross-cc.mk

.PHONY: nDPI_pre_configure
nDPI_pre_configure:
	$(RUN) ./autogen.sh $(REAL_CONFIGURE_ARGS)

.PHONY: nDPI_post_install
nDPI_post_install:
	install -m 755 -d $(STAGING_INSTALL_PREFIX)/share/ndpi
	mv $(STAGING_INSTALL_PREFIX)/sbin/ndpi/* $(STAGING_INSTALL_PREFIX)/share/ndpi/
