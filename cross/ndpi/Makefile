PKG_NAME = nDPI
PKG_VERS = 4.10
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://github.com/ntop/nDPI/archive
PKG_DIST_FILE = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/libpcap cross/json-c

# cross/libpcap not supported:
UNSUPPORTED_ARCHS = $(OLD_PPC_ARCHS)

HOMEPAGE = https://www.ntop.org/
COMMENT  = nDPI is an open source LGPLv3 library for deep-packet inspection. Based on OpenDPI it includes ntop extensions. We have tried to push them into the OpenDPI source tree but nobody answered emails so we have decided to create our own source tree.
LICENSE  = LGPLv3

GNU_CONFIGURE = 1
INSTALL_MAKE_OPTIONS = install DESTDIR=$(INSTALL_DIR)

PRE_CONFIGURE_TARGET = nDPI_pre_configure

include ../../mk/spksrc.cross-cc.mk

.PHONY: nDPI_pre_configure
nDPI_pre_configure:
	$(RUN) ./autogen.sh $(REAL_CONFIGURE_ARGS)
